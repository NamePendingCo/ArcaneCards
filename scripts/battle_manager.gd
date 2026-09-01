class_name BattleManager extends Node3D

#Signals to notify about phase starts
signal round_load_phase_began #likely won't ever need this one
signal draw_phase_began
signal upkeep_phase_began
signal casting_phase_began
signal adjudication_phase_began
signal end_phase_began

enum RoundPhase {
	NULL,
	ROUND_LOAD,
	DRAW,
	UPKEEP,
	CASTING,
	ADJUDICATION,
	END
}

var match_in_progress: bool
var round_num: int
var current_phase: RoundPhase

var caster_priority_order: Array[Caster] #Order that caster cards should be resolved in
var casting_list: Array[Card] #list of cards that are being cast, sorted for processing order

var event_stack: Array[Event] #stack used for event processing
var to_stack_list: Array[Event] #events queued to be added to stack before triggering event
var to_stack_after_list: Array[Event] #events queued to be added to stack after the triggering event

#collection of events that listen for signal from cards
var card_listening_events: Array[Event]

func _ready():
	current_phase = RoundPhase.NULL
	event_stack = []
	match_in_progress = false
	
	#Connect all card creation to _register_card
	var casters = get_tree().get_nodes_in_group(Constants.GROUP_CASTER)
	print(casters)
	for caster: Caster in casters:
		caster.card_manager.created_card.connect(_register_card)
		
		#Loop through the basic events, connect to them all
		for event_name in caster.caster_events_wrapper.event_launchers:
			var launcher = caster.caster_events_wrapper.event_launchers[event_name]
			_register_event_launcher(launcher)
			print("%s: %s" % [event_name, launcher.actor])

#================================================
# Public methods
#================================================

'''
All game start and setup stuff should be done here
'''
func startMatch():
	print("Starting match...")
	round_num = 0 #starts at zero so it can increase every round
	match_in_progress = true
	
	caster_priority_order = []
	
	var casters = get_tree().get_nodes_in_group(Constants.GROUP_CASTER)
	for caster: Caster in casters:
		caster.on_game_start()
		caster_priority_order.append(caster)
	
	_process_event_stack()
	
	runMatch()

'''
Loops through and perpetually runs the game, acting as the main source of
runtime instead of a series of infinitely recursive calls by the phases.
'''
func runMatch():
	
	'''
	Loops through all phases. Tbh, might eventually be worth
	merging runMatch and advancePhase together.
	'''
	while match_in_progress:
		#Needs an await because of the delay in advance phase atm
		await advancePhase()
	
	print("Game has ended.")

'''
Advances to the next phase based on the current phase. Use this by default so that
if we add intermediary phases, we just need to upkeep this function instead of modifying
all calls of the phase function
'''
func advancePhase():
	# next phase is either the next phase on the list, or if it is END resets to ROUND_LOAD
	var next_phase = current_phase + 1 if current_phase < RoundPhase.END else RoundPhase.ROUND_LOAD
	
	var delay = 0.3
	print("Advancing to phase %s after temporary delay of %f seconds" %\
	 [RoundPhase.find_key(next_phase), delay])
	#Temporary delay to separate phases 
	await get_tree().create_timer(delay).timeout
	
	var phase_func: Callable
	
	match next_phase:
		RoundPhase.ROUND_LOAD: phase_func = phaseRoundLoad
		RoundPhase.DRAW: phase_func = phaseDraw
		RoundPhase.UPKEEP: phase_func = phaseUpkeep
		RoundPhase.CASTING: phase_func = phaseCasting
		RoundPhase.ADJUDICATION: phase_func = phaseAdjudication
		RoundPhase.END: phase_func = phaseEnd
		_: assert(false, "Next phase was not an accepted phase.")
		
	if phase_func != null:
		await phase_func.call()

'''
Any events that should occur technical wise but not mechanically go here.
'''
func phaseRoundLoad():
	current_phase = RoundPhase.ROUND_LOAD
	round_load_phase_began.emit()
	
	round_num += 1 #Increases the round number
	print("==============")
	print("Round %d" % round_num)
	print("==============")
	
	if round_num > 1:
		#Moves first priority to end of priority
		caster_priority_order.push_back(caster_priority_order.pop_front())
	
	advancePhase()

'''
The draw phase of the game. Any events that should occur go here.
'''
func phaseDraw():
	current_phase = RoundPhase.DRAW
	
	#Notify that the phase has begun. Should trigger
	#casters to create their standard draw
	draw_phase_began.emit()
	
	_process_event_stack() #Handle any draw phase events/invocations

'''
Runs the upkeep phase of the game.
'''
func phaseUpkeep():
	current_phase = RoundPhase.UPKEEP
	if round_num == 1:
		#skip upkeep phase for first round
		return
	
	#Notify that the phase has begun. Should trigger
	#casters to create their gain mana income and pay upkeep events
	upkeep_phase_began.emit()
	
	_process_event_stack() #Handle any upkeep phase events/invocations

'''
Have casters choose their cards for casting any any other 
'''
func phaseCasting():
	current_phase = RoundPhase.CASTING
	casting_phase_began.emit()
	
	#in case any events were triggered, handle them. 
	#Though there REALLY SHOULDN'T BE
	_process_event_stack()
	
	#Get all beings in game
	var beings = get_tree().get_nodes_in_group(Constants.GROUP_CASTER)
	var casting_decision_coroutines: AwaitGroup = AwaitGroup.new()
	
	var decision_funcs: Array[Callable] = []
	
	#Gets the choose casting cards functions from each caster
	for being in beings:
		being = being as Being #Casts to ensure is a being
		decision_funcs.append(being.make_casting_phase_decisions)
	
	print("Preparing to await")
	
	#Waits for all decisions to be completed
	await casting_decision_coroutines.multi_function(decision_funcs)
	
	print("After await")
	
	#Reveal all decisions made once ready
	for being in beings:
		being = being as Being #Casts to ensure is a being
		being.reveal_casting_phase_decisions()
	
	#in case any events were triggered, handle them
	_process_event_stack()
	
	#counts the slots iterated through when arranging the cards
	var slot_counter: int = 0
	var adding_to_list: bool = true
	while adding_to_list:
		adding_to_list = false #Set to false at start, must be reenabled each loop
		for caster in caster_priority_order:
			if caster.my_casting_well.num_slots <= slot_counter:
				continue
			adding_to_list = true #Made an addition, so keep looping
			var card: Card = caster.my_casting_well.cards[slot_counter]
			if card != null:
				casting_list.append(card)
		slot_counter += 1

'''
Resolution of actions. Most important for having the effect stack here.
'''
func phaseAdjudication():
	current_phase = RoundPhase.ADJUDICATION
	adjudication_phase_began.emit()
	
	#TODO function to sort casting list
	
	for card in casting_list:
		card.progress_casting(1) #progress card
		_process_event_stack() #process all triggered events
	
	casting_list.clear()

'''
All end phase mechanics triggered here
'''
func phaseEnd():
	current_phase = RoundPhase.END
	end_phase_began.emit()
	
	_process_event_stack() #Handle any end phase events/invocations

#================================================
# Private methods
#================================================

'''
Takes an event and connects with its trigger signal, as well
as connecting it to any signals necessary.
Params:
	- event: an event
'''
func _handle_activated_event(launcher: EventLauncher):
	launcher.event_triggered.connect(_queue_event)
	
	if launcher is OnPhaseEvent:
		var phase_signal: Signal
		#Picks correct signal based on phase type
		match launcher.phase:
			RoundPhase.DRAW: phase_signal = draw_phase_began
			RoundPhase.UPKEEP: phase_signal = upkeep_phase_began
			RoundPhase.CASTING: phase_signal = casting_phase_began
			RoundPhase.ADJUDICATION: phase_signal = adjudication_phase_began
			RoundPhase.END: phase_signal = end_phase_began
		phase_signal.connect(launcher.trigger)

'''
When passed a card object, registers a card for any
listeners that need to track it.
Params:
	- card: a card object
'''
func _register_card(card: Card):
	for event_name in card.events:
		var launcher: EventLauncher = card.events_wrapper.event_launchers[event_name]
		_register_event_launcher(launcher)

'''
Registers an event directly.
Params:
	- event: the event to register
'''
func _register_event_launcher(launcher: EventLauncher):
	launcher.event_activated.connect(_handle_activated_event.bind(launcher))

'''
Takes a list of events, sorts them based on the sort function, 
then places them on the event stack. Then clears the list.
'''
func _stack_event_list(event_list: Array[Event]):
	# Sorts by priority score. Higher scores go earlier in list
	event_list.sort_custom(\
	func(a: Event, b: Event):
		return a.calculate_priority() > b.calculate_priority())
		
	event_stack.append_array(event_list)
	event_list.clear()

func _initial_stack_setup():
	_stack_event_list(to_stack_list)
	_stack_event_list(to_stack_after_list)

'''
Takes in an event and processes if there are triggered events. 
Puts events into the stack in appropriate order of after events, 
the original event, then any preceding events, sorting them as
appropriate. Then returns if there are no new preceding events.
Returns:
	- True if to_stack_list is empty after announcing event
	- False if to_stack_list has items in it
'''
func _process_triggered_events(event: Event) -> bool:
	
	#Updates the triggered events list for the event
	event.triggered_events.append_array(to_stack_list)
	event.triggered_events.append_array(to_stack_after_list)
	
	if to_stack_list.is_empty():
		#If no preceding event was triggered, add after events
		# and return true
		_stack_event_list(to_stack_after_list)
		return true
	else:
		#If event triggered preceding events, 
		# add preceding events and repush event,
		# then add after events and return false
		_stack_event_list(to_stack_list)
		event_stack.push_back(event)
		_stack_event_list(to_stack_after_list)
		return false

'''
While event stack not empty, pop top then prepare to run and pass to
process_triggered_events. If true, run event. If false, ignore and loop
'''
func _process_event_stack():
	_initial_stack_setup()
	while not event_stack.is_empty():
		print("Processing event stack...")
		print("events:")
		for event in event_stack:
			print("%s: %s" % [event.actor, event])
		
		#checks the top item on stack. If no new events stacked, run it
		var event = event_stack.pop_back()
		
		#Make all event decisions and conditional checks
		#and send signal that this event is running
		event.prepare_to_run()
		
		#TODO add function for checking effects
		
		if _process_triggered_events(event):
			event.run()

'''
Adds an event to the queue so it can be triggered in order.
Gets connected to an event's trigger when it is activated.
'''
func _queue_event(event: Event):
	to_stack_list.append(event)
