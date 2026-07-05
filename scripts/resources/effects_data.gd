@tool
class_name EffectsData extends Resource

@export_category("Events and Effects")
#list of targeting parameters which are used by effects
@export var params: Dictionary[String, EventParam]

#dictionary of events on this card
var events: Dictionary[String, Event] = {}
#exported activation event so designer can only set one
@export var activation_event: ActivationEvent:
	set(val):
		activation_event = val
		events[Constants.ACTIVATION_KEY] = activation_event
#export listening events so any other events can be set
@export var _events: Dictionary[String, ListenerEvent]:
	set(val):
		_events = val
		events.clear()
		for key in _events:
			events[key] = _events[key]
		events[Constants.ACTIVATION_KEY] = activation_event


'''
Uses the designer name based parameters in events and effects
and sets the actual variables to use them.
'''
func prepare_params():
	for key in events.keys():
		var event: Event = events[key]
		#Populate param list from names
		for param_name in event.choice_param_names:
			assert(param_name in params, \
			"Parameter %s not in params list" % param_name)
			
			event.choice_params.append(params[param_name])
		
		for effect in event.effects:
			#TODO - handle effect params
			continue
	pass
