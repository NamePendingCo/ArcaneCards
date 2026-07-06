@tool
class_name EffectsData extends Resource

#fixed keys for event dict
const ACTIVATION_KEY = "onActivation"
const CAST_KEY = "onCast"
const DISCARD_KEY = "onDiscard"

#@export_subgroup("Events and Effects")
#list of targeting parameters which are used by effects
@export var parameters: Dictionary[String, EventParam]

#dictionary of events on this card
@export
var events: Dictionary[String, Event] = {}

func _init():
	#on default, create an empty event for activation, as most cards will need it
	events[ACTIVATION_KEY] = UnsignaledEvent.new()

'''
Uses the designer name based parameters in events and effects
and sets the actual variables to use them.
'''
func prepare_params():
	for key in events.keys():
		var event: Event = events[key]
		#Populate param list from names
		for param_name in event.choice_param_names:
			assert(param_name in parameters, \
			"Parameter %s not in params list" % param_name)
			
			event.choice_params.append(parameters[param_name])
		
		for effect in event.effects:
			#TODO - handle effect params
			continue
	pass
