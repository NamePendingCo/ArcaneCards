class_name BattleManager extends Node3D

enum RoundPhase {
	NULL,
	ROUND_LOAD,
	DRAW,
	UPKEEP,
	CASTING,
	ADJUDICATION,
	END
}

var roundNum: int
var currentPhase: RoundPhase

func _ready():
	currentPhase = RoundPhase.NULL

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
	roundNum += 1 #Increases the round number
	
	advancePhase()

'''
The draw phase of the game. Any events that should occur go here.
'''
func phaseDraw():
	currentPhase = RoundPhase.DRAW
	advancePhase()

'''
Runs the upkeep phase of the game.
'''
func phaseUpkeep():
	currentPhase = RoundPhase.UPKEEP
	
	if roundNum == 1:
		advancePhase()

#TODO: Add an await function (or two) waiting on casters to make their choices
'''
Should allow casters to pick their cards here
'''
func phaseCasting():
	currentPhase = RoundPhase.CASTING
	advancePhase()

'''
Resolution of actions. Most important for having the effect stack here.
'''
func phaseAdjudication():
	currentPhase = RoundPhase.ADJUDICATION
	advancePhase()

'''
All end phase mechanics triggered here
'''
func phaseEnd():
	currentPhase = RoundPhase.END
	advancePhase()
