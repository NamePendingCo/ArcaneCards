@tool
@abstract
class_name Event extends Resource

signal effects_len_changed(int)

signal event_triggered
signal event_running

var is_invocation: bool
#The lists of names of param selections that should be made
#by actor upon this event triggering. For editor use
@export var choice_param_names: Array[String]
#actual internal list variables used when selections made.
#Set by the spell_data
var choice_params: Array[EventParam]

#List of effects that occur during this event
@export
var effects: Array[Effect]:
	set(val):
		effects = val
		for effect in effects:
			effect._num_parent_effects = effects.size()

# The list of events that this event has triggered during its invocation
var triggered_events: Array[Event]

#The entity making the event occur
var actor: Being

func _ready():
	triggered_events = []

'''
Usually connected with a signal. When called, signals to the battle_manager
to be added to the event stack.
'''
func trigger():
	event_triggered.emit(self)

'''
Send signal that this event is running. Only used right now
to notify it is being invoked.
'''
func declare_running():
	event_running.emit()

'''
Runs the event and all effects that should occur as part of it.
'''
func run():
	for effect in effects:
		effect.invoke()

'''
Calculates the priority score for the event for determining. 
Execution order if triggered at the same time. The lower
the score, the earlier it goes.
Returns:
	- score: a positive int
'''
func calculate_priority() -> int:
	return 1
