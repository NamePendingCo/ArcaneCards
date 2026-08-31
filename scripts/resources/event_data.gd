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
'''
func setup_events(actor: Actor, card: Card = null):
	
	var params = _set_up_parameters(parameters_list, actor, card)
		
	var events = _set_up_event_launchers(events_list, params)
	
	return EventsWrapper.new(events, params)

#================================================
# Private methods
#================================================

func _set_up_parameters(param_resources: Dictionary[String, EventParamResource], 
actor: Actor, card: Card) -> Dictionary[String, EventParam]:
	var params: Dictionary[String, EventParam] = {}
	
	for param_name in param_resources:
		params[param_name] = param_resources[param_name].build_param()
	
	for param_resource: EventParamResource in param_resources.values():
		param_resource.complete_unfinished_params(params)
	
	return params

func _set_up_event_launchers(event_resources: Dictionary[String, EventResource], 
params: Dictionary[String, EventParam]) -> Dictionary[String, EventLauncher]:
	
	var launchers: Dictionary[String, EventLauncher] = {}
	
	for event_name in event_resources:
		launchers[event_name] = event_resources[event_name].set_up_event_launcher(params)
	
	return launchers
