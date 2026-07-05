@tool
@abstract
class_name Event extends Resource

signal effects_len_changed(int)

signal event_triggered
signal event_running

enum EventState {
	INACTIVE = 0,
	ACTIVE = 1,
	DISABLED = 2
}

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

# When true, this event is treated as a regular game
# driven event and not an action triggered during play.
var is_system_event: bool = false

var event_state: EventState:
	set(val):
		event_state = val
		if val == EventState.ACTIVE:
			_activate_event()
		else:
			_deactivate_event()

#The entity making the event occur
var actor: Being

func _ready():
	event_state = EventState.INACTIVE
	triggered_events = []

#================================================
# Functions below here
#================================================

@abstract
func _activate_event()

@abstract
func _deactivate_event()

'''
Usually connected with a signal. When called, signals to the battle_manager
to be added to the event stack.
'''
func trigger():
	#Only can trigger if active
	if event_state == EventState.ACTIVE:
		event_triggered.emit(self)

'''
Have the event go through and make all selections for 
the parameters and conditions. Then send signal that this event is running.
'''
func prepare_to_run():
	
	#TODO handle params
	
	event_running.emit()

'''
Runs the event and all effects that should occur as part of it.
'''
func run():
	for effect in effects:
		effect.run()

'''
Calculates the priority score for the event for determining. 
Execution order if triggered at the same time. The lower
the score, the earlier it goes.
Returns:
	- score: a positive int
'''
func calculate_priority() -> int:
	var priority: int = 0
	if is_system_event:
		priority += 1 << 15 #TODO: decide actual flag
	
	return priority
