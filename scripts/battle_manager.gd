class_name BattleManager extends Node3D

#Signals to notify about phase starts
signal round_load_phase_began #likely won't ever need this one
signal draw_phase_began
signal upkeep_phase_began
signal casting_phase_began
signal adjudication_phase_began
signal end_phase_began

const RoundPhase = Enums.RoundPhase

@export
var casters: Array[Caster] = []

var round_num: int
var current_phase: RoundPhase

var event_stack: Array[Event] #stack used for event processing
var to_stack_list: Array[Event] #events queued to be added to stack before triggering event
var to_stack_after_list: Array[Event] #events queued to be added to stack after the triggering event

#collection of events that listen for signal from cards
var card_listening_events: Array[Event]

func _ready():
	current_phase = RoundPhase.NULL
	event_stack = []

'''
All game start and setup stuff should be done here
'''
func startMatch():
	round_num = 0 #starts at zero so it can increase every round
	phaseRoundLoad()

'''
Advances to the next phase based on the current phase. Use this by default so that
if we add intermediary phases, we just need to upkeep this function instead of modifying
all calls of the phase function
'''
func advancePhase():
	# next phase is either the next phase on the list, or if it is END resets to ROUND_LOAD
	var next_phase = current_phase + 1 if current_phase < RoundPhase.END else RoundPhase.ROUND_LOAD
	
	match next_phase:
		RoundPhase.ROUND_LOAD: phaseRoundLoad()
		RoundPhase.DRAW: phaseDraw()
		RoundPhase.UPKEEP: phaseUpkeep()
		RoundPhase.CASTING: phaseCasting()
		RoundPhase.ADJUDICATION: phaseAdjudication()
		RoundPhase.END: phaseEnd()
		_: assert(false, "Next phase was not an accepted phase.")

'''
Any events that should occur technical wise but not mechanically go here.
'''
func phaseRoundLoad():
	current_phase = RoundPhase.ROUND_LOAD
	round_load_phase_began.emit()
	
	round_num += 1 #Increases the round number
	
	advancePhase()

'''
The draw phase of the game. Any events that should occur go here.
'''
func phaseDraw():
	current_phase = RoundPhase.DRAW
	draw_phase_began.emit()
	
	_process_event_stack() #Handle any draw phase events/invocations
	
	#should be last in the phase
	_do_standard_draw()
	
	advancePhase()

'''
Have all casters in game do their standard draw.
'''
func _do_standard_draw():
	#Maybe actually create an effect here and run that so it can be modified?
	pass

'''
Runs the upkeep phase of the game.
'''
func phaseUpkeep():
	current_phase = RoundPhase.UPKEEP
	if round_num == 1:
		#skip upkeep phase for first round
		advancePhase()
	
	upkeep_phase_began.emit()
	
	_process_event_stack() #Handle any upkeep phase events/invocations
	
	_casters_gain_mana_income()
	_casters_pay_upkeep()

#TODO
func _casters_gain_mana_income():
	pass

#TODO	
func _casters_pay_upkeep():
	for caster in casters:
		caster.declare_paying_upkeep()

'''
Processes a declaration to pay upkeep by running any events that it triggers
'''
func _process_upkeep_payment(caster: Caster):
	_process_event_stack()

#TODO: Add an await function (or two) waiting on casters to make their choices
'''
Should allow casters to pick their cards here
'''
func phaseCasting():
	current_phase = RoundPhase.CASTING
	casting_phase_began.emit()
	
	advancePhase()

'''
Resolution of actions. Most important for having the effect stack here.
'''
func phaseAdjudication():
	current_phase = RoundPhase.ADJUDICATION
	adjudication_phase_began.emit()
	
	# Loop that should go here to cycle through activations and also invocations
	
	advancePhase()

'''
All end phase mechanics triggered here
'''
func phaseEnd():
	current_phase = RoundPhase.END
	end_phase_began.emit()
	
	_process_event_stack() #Handle any end phase events/invocations
	
	advancePhase()

'''
Takes a card object and activates it, registering each
event into its event list.
Params:
	- card: a Card
'''
func _activate_card(card: Card):
	for key in card.events:
		var event: Event = card.events[key]
		event.event_triggered.connect(_queue_event)
		
		if event is ActivationEvent:
			#Activation event should do nothing here
			continue
		elif event is OnPhaseEvent:
			var phase_signal: Signal
			#Picks correct signal based on phase type
			match event.phase:
				RoundPhase.DRAW: phase_signal = draw_phase_began
				RoundPhase.UPKEEP: phase_signal = upkeep_phase_began
				RoundPhase.CASTING: phase_signal = casting_phase_began
				RoundPhase.ADJUDICATION: phase_signal = adjudication_phase_began
				RoundPhase.END: phase_signal = end_phase_began
			phase_signal.connect(event.trigger)
		
	card.events[Constants.ACTIVATION_KEY].trigger()

'''
When passed a card object, registers a card for any
listeners that need to track it.
Params:
	- card: a card object
'''
func _register_card(card: Card):
	for event in listening_events:
		print()

'''
Takes a list of events, sorts them based on the sort function, 
then places them on the event stack. Then clears the list.
'''
func _stack_event_list(event_list: Array[Event]):
	event_list.sort_custom(func(a, b): return true) #TODO replace with real comparison function
	event_stack.append_array(to_stack_list)
	event_list.clear()

'''
Takes in an event and processes if there are triggered events. 
Puts events into the stack in appropriate order of after events, 
the original event, then any preceding events, sorting them as
appropriate. Then returns if there are no new preceding events.
Returns:
	- True if to_stack_list is empty after announcing event
	- False if to_stack_list has items in it
'''
func _handled_triggered_events(event: Event) -> bool:
	
	#Updates the triggered events list for the event
	event.triggered_events.append(to_stack_list)
	event.triggered_events.append(to_stack_after_list)
	
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
While event stack not empty, get top then pass to pre-trigger. If true,
pop from spell stack and trigger. If false, discard
'''
func _process_event_stack():
	while not event_stack.is_empty():
		#checks the top item on stack. If no new events stacked, run it
		var event = event_stack.pop_back()
		
		#Send signal that this event is running
		event.declare_running()
		
		#TODO add function for checking effects
		
		if _handled_triggered_events(event):
			event.run()

func _queue_event(event: Event):
	to_stack_list.append(event)
