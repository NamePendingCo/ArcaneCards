@tool
class_name Event extends Resource

signal effects_len_changed(int)

signal event_triggered

#TODO: consider
@export

var is_invocation: bool = true
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
	pass

'''
Usually connected with a signal. When called, signals to the battle_manager
to be added to the event stack.
'''
func trigger():
	event_triggered.emit()

'''
Runs the event and all effects that should occur as part of it.
'''
func run():
	for effect in effects:
		effect.invoke()
