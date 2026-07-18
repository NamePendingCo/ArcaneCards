@tool
@abstract
class_name Event extends Resource

#This might not be needed anymore. TBD
signal effects_len_changed(int)

signal event_activated #When the event is enabled

signal event_triggered #when told to run
signal event_running #when actually running

enum EventState {
	INACTIVE = 0,
	ACTIVE = 1,
	SUPRESSED = 2
}

#The lists of names of param selections that should be made
#by actor upon this event triggering. For editor use
@export var choice_param_names: Array[String]

#actual internal list variables used when selections made.
#Set by the spell_data
var choice_params: Array[EventParam]

#List of effects that occur during this event
@export
var effects: Array[Effect]

# The list of events that this event has triggered during its invocation
var triggered_events: Array[Event]

# When true, this event is treated as a regular game
# driven event and not an action triggered during play.
var is_system_event: bool = false

# Whether this event should count as an invocation for its card
var is_invocation: bool = true

#Tracks the current state of the event
var event_state: EventState:
	set(val):
		if event_state == val:
			#return if event doesn't change
			return
			
		event_state = val
		
		match event_state:
			EventState.INACTIVE:
				_deactivate_event()
			EventState.ACTIVE:
				_activate_event()
			EventState.SUPRESSED:
				_suppress_event()

#The entity making the event occur
var actor: Actor = null

#Parent card that owns this event. Not always set
var parent_card: Card = null

func _ready():
	event_state = EventState.INACTIVE
	triggered_events = []
	print("my effects %s" % effects)

#================================================
# Public methods
#================================================

'''
Usually connected with a signal. When called, signals to the battle_manager
to be added to the event stack.
'''
func trigger():
	print("Triggered Event %s for %s which is %s" % [self, actor.name, EventState.keys()[event_state]])
	#Only can trigger if active
	if event_state == EventState.ACTIVE:
		print("Event is active")
		event_triggered.emit(self)

'''
Have the event go through and make all selections for 
the parameters and conditions. Then send signal that this event is running.
'''
func prepare_to_run():
	print("Preparing to run event")
	
	for param in choice_params:
		#Loops through and makes all choices for parameters
		
		if param is TargetParam:
			param.update_range()
		
		param.request_selection()
	
	#Announce the event is running
	event_running.emit()
	
	#TODO put here a loop that has each effect also announce it is happening

'''
Runs the event and all effects that should occur as part of it. Does not
run if the event is not active.
'''
func run():
	print("Running event: %s which is %s" % [self, EventState.keys()[event_state]])
	#Should not run if inactive or suppressed.
	if event_state != EventState.ACTIVE:
		return
	
	print("-> Event is active")
	#print("%s" % effects.map(func(a: Effect): a.effect_id))
	
	for effect in effects:
		print(Effect.EffectID.keys()[effect.effect_id])
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

#================================================
# Private methods
#================================================

#In case its necessary--run when set to active
func _activate_event():
	event_activated.emit()

#In case its necessary--run when set to inactive (but not suppressed)
func _deactivate_event():
	triggered_events.clear() #ensure no hanging references

#In case its necessary--run when set to suppressed
func _suppress_event():
	pass
