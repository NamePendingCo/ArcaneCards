class_name Event extends Node

'''
This class represents an actual event occuring in the game as handled by
the event resolving system in the battle manager. They should usually only
exist to run once and then disappear. Rarely should this ever be created
directly. Instead we should rely on EventLaunchers to create these based on 
their pre-defined blueprint.
'''

signal event_running #when actually running

#The entity making the event occur
var actor: Actor = null
#Parent card that owns this event. Not always set
var parent_card: Card = null

#List of effects that occur during this event
@export
var effects: Array[Effect]
#list of parameters to update before the event runs. Should always
#include the parameters that require choices
@export
var params_to_update: Array[EventParam]

var is_prepared_to_run: bool = false

# The list of events that this event has triggered during its invocation
var triggered_events: Array[Event] = []

# When true, this event is treated as a regular game
# driven event and not an action triggered during play.
var is_system_event: bool = false
# Whether this event should count as an invocation for its card
var is_invocation: bool = true

#================================================
# Public methods
#================================================

'''
Have the event go through and make all selections for 
the parameters and conditions. Then send signal that this event is running.
'''
func prepare_to_run():
	print("\nPreparing to run event: %s" % self)
	
	print("\tParams to update: %s" % str(params_to_update))
	
	for param in params_to_update:
		#Loops through and makes all choices for parameters
		
		if param is TargetParam:
			param.update_range()
	
	is_prepared_to_run = true
	
	#Announce the event is running
	event_running.emit(is_invocation)
	
	#TODO put here a loop that has each effect also announce it is happening

'''
Runs the event and all effects that should occur as part of it. Does not
run if the event is not active.
'''
func run():
	print("\nRunning Event: %s with effects:" % name)
	
	for effect in effects:
		print("\t%s" % effect)
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
