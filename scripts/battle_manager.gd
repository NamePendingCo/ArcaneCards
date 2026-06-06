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

@export
var casters: Array[Caster] = []

var round_num: int
var current_phase: RoundPhase

var event_stack: Array[Event] #stack used for event processing
var to_stack_list: Array[Event] #events queued to be added to stack


func _ready():
	current_phase = RoundPhase.NULL
	event_stack = []

#TODO Clean up description
'''
goes through the actor event and see what effects are present. 
Notify affected cards/casters of what will occur so they can send 
relevant signals. Then, see if there is anything in to_stack_list. 
If there is, order them based on RULESET HERE, add them all to 
both the actor's triggeredEvents list and the spellStack, and then return False. 
Otherwise return true
Returns:
	- True if to_stack_list is empty after announcing event
	- False if to_stack_list has items in it
'''
func _pre_trigger(event: Event) -> bool:
	#TODO make some sort of announcement of event here
	
	if to_stack_list.is_empty():
		return true
	else:
		to_stack_list.sort_custom(func(a, b): return true) #TODO replace with real comparison function
		event.triggered_events.append_array(to_stack_list)
		event_stack.append_array(to_stack_list)
		return false

'''
While event stack not empty, get top then pass to pre-trigger. If true,
pop from spell stack and trigger. If false, discard
'''
func _process_event_stack():
	while not event_stack.is_empty():
		#checks the top item on stack
		if _pre_trigger(event_stack[-1]):
			var running_event: Event = event_stack.pop_back()
			running_event.run()

func _queue_event():
	pass

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
