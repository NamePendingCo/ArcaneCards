@tool
class_name EventResource extends Resource

#The lists of names of param selections that should be made
#by actor upon this event triggering. For editor use
@export var params_to_update: Array[String]

#List of effects that occur during this event
@export
var effects: Array[EffectResource]

#if the event is a system event, which should go after others
@export
var is_system_event: bool = false

'''
Creates the event launcher for the event the resource defines
Params:
	- param_dict: the parameters to assign to the effects in the card
	- actor: optional for setting the actor of the event
	- card: optional for setting the card this event is for
'''
func set_up_event_launcher(param_dict: Dictionary[String, EventParam], 
actor: Actor = null, card: Card = null, event_name: String = "") -> EventLauncher:
	
	#Create the actual event to duplicate
	var event_template: Event = _build_event_template(param_dict, event_name)
	
	var launcher = EventLauncher.new(event_template, actor, card)
	launcher.name = event_name + "_launcher"
	
	launcher.is_system_event = is_system_event
	
	return launcher

func _build_event_template(param_dict: Dictionary[String, EventParam], event_name: String = "") -> Event:
	#Create the actual event to duplicate
	var event_template: Event = Event.new()
	if event_name != "":
		event_template.name = event_name
	
	#Create the list of effects
	var event_effects: Array[Effect] = []
	for effect_resource in effects:
		var new_effect = effect_resource.build_effect(param_dict)
		event_effects.append(new_effect)
		event_template.add_child(new_effect)
		new_effect.name = "%s_%s" % [event_name, new_effect.effect_string]
		
		#Sets the owner of the effect to be the event template the moment both are in tree
		event_template.tree_entered.connect(new_effect.set_owner.bind(event_template), CONNECT_ONE_SHOT)
	
	event_template.effects = event_effects
	
	event_template.is_system_event = is_system_event
	
	#Build the list of parameters to update
	var updating_params_list: Array[EventParam] = []
	for param_name in params_to_update:
		updating_params_list.append(param_dict[param_name])
	
	event_template.params_to_update = updating_params_list
	
	return event_template
