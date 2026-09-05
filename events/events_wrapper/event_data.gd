@tool
class_name EventData extends Resource

'''
Resource that stores information for loading a set of events
and parameters.
'''

#@export_subgroup("Events and Effects")
#list of targeting parameters which are used by effects
@export var parameters_list: Dictionary[String, EventParamResource] = {}

#dictionary of events on this card
@export var events_list: Dictionary[String, EventResource] = {}

'''
Sets up the collection of the events
Params:
	- actor: the actor who controls the events
	- card: optional param. If present, card the event is associated with
Returns:
	An EventWrapper built around these events
'''
func get_new_events_wrapper(actor: Actor = null, card: Card = null) -> EventsWrapper:
	
	var params = _set_up_parameters(parameters_list, actor, card)
		
	var events = _set_up_event_launchers(events_list, params, actor, card)
	
	var wrapper = EventsWrapper.new(events, params)
	
	return wrapper

#================================================
# Private methods
#================================================

'''
Helper function, sets up all parameters that are defined in the event data.
Param:
	- param_resource: the resource defining the parameters to set up
	- actor: the actor who these params are attached to
	- card: the card who these params are attached to
'''
func _set_up_parameters(param_resources: Dictionary[String, EventParamResource], 
actor: Actor, card: Card) -> Dictionary[String, EventParam]:
	var params: Dictionary[String, EventParam] = {}
	
	for param_name in param_resources:
		var param = param_resources[param_name].build_param(actor, card)
		params[param_name] = param
		param.name = param_name
	
	for param_resource: EventParamResource in param_resources.values():
		param_resource.complete_unfinished_params(params)
	
	return params

'''
Helper function. Sets up the event launchers defined in the data.
Params:
	event_resources: all resource that should be set up
	params: the parameters to attach to the effects in the events
	actor: the actor who will be performing these events
	card: the card the events are attached to
'''
func _set_up_event_launchers(event_resources: Dictionary[String, EventResource], 
params: Dictionary[String, EventParam], actor: Actor, card: Card) -> Dictionary[String, EventLauncher]:
	
	var launchers: Dictionary[String, EventLauncher] = {}
	
	for event_name in event_resources:
		launchers[event_name] = event_resources[event_name].set_up_event_launcher(params, actor, card, event_name)
	
	return launchers
