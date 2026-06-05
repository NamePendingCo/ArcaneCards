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

var roundNum: int
var currentPhase: RoundPhase

func _ready():
	currentPhase = RoundPhase.NULL

#TODO Clean up description
'''
goes through the actor event and see what effects are present. 
Notify affected cards/casters of what will occur so they can send 
relevant signals. Then, see if there is anything in toStack. 
If there is, order them based on RULESET HERE, add them all to 
both the actor's triggeredEvents list and the spellStack, and then return False. 
Otherwise return true
'''
func _pre_trigger(actor):# -> bool:
	pass

'''
The big one. While event stack not empty, get top then pass to pre-trigger. If true,
pop from spell stack and trigger. If false, discard
'''
func _process_event_stack():
	pass
	

'''
All game start and setup stuff should be done here
'''
func startMatch():
	roundNum = 0 #starts at zero so it can increase every round
	phaseRoundLoad()

'''
Advances to the next phase based on the current phase. Use this by default so that
if we add intermediary phases, we just need to upkeep this function instead of modifying
all calls of the phase function
'''
func advancePhase():
	# next phase is either the next phase on the list, or if it is END resets to ROUND_LOAD
	var next_phase = currentPhase + 1 if currentPhase < RoundPhase.END else RoundPhase.ROUND_LOAD
	
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
	currentPhase = RoundPhase.ROUND_LOAD
	round_load_phase_began.emit()
	
	roundNum += 1 #Increases the round number
	
	advancePhase()

'''
The draw phase of the game. Any events that should occur go here.
'''
func phaseDraw():
	currentPhase = RoundPhase.DRAW
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
	currentPhase = RoundPhase.UPKEEP
	if roundNum == 1:
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
	pass

#TODO: Add an await function (or two) waiting on casters to make their choices
'''
Should allow casters to pick their cards here
'''
func phaseCasting():
	currentPhase = RoundPhase.CASTING
	casting_phase_began.emit()
	
	advancePhase()

'''
Resolution of actions. Most important for having the effect stack here.
'''
func phaseAdjudication():
	currentPhase = RoundPhase.ADJUDICATION
	adjudication_phase_began.emit()
	
	# Loop that should go here to cycle through activations and also invocations
	
	advancePhase()

'''
All end phase mechanics triggered here
'''
func phaseEnd():
	currentPhase = RoundPhase.END
	end_phase_began.emit()
	
	_process_event_stack() #Handle any end phase events/invocations
	
	advancePhase()
