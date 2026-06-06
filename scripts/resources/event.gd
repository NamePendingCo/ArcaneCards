class_name Event extends Resource

signal eventTriggered

@export
var effects: Array[Effect]

@export
var isInvocation: bool = true

# The list of events that this event has triggered during its invocation
var triggered_events: Array[Event]

func _ready():
	triggered_events = []
	pass

'''
Usually connected with a signal. When called, signals to the battle_manager
to be added to the event stack.
'''
func trigger():
	eventTriggered.emit()

'''
Runs the event and all effects that should occur as part of it.
'''
func run():
	for effect in effects:
		effect.invoke()
