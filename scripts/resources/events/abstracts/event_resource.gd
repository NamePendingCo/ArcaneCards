@tool
class_name EventResource extends Resource

#The lists of names of param selections that should be made
#by actor upon this event triggering. For editor use
@export var params_to_update: Array[String]

#List of effects that occur during this event
@export
var effects: Array[EffectResource]

'''
Creates the event launcher for the event the resource defines
Params:
	- param_dict: the parameters to assign to the effects in the card
	- actor: optional for setting the actor of the event
	- card: optional for setting the card this event is for
'''
func set_up_event_launcher(param_dict: Dictionary[String, EventParam], 
actor: Actor = null, card: Card = null) -> EventLauncher:
	
	#Create the list of effects
	var event_effects: Array[Effect] = []
	for effect_resource in effects:
		var new_effect = effect_resource.build_effect(param_dict)
		event_effects.append(new_effect)
	
	#Build the list of parameters to update
	var updating_params_list: Array[EventParam] = []
	for param_name in params_to_update:
		updating_params_list.append(param_dict[param_name])
	
	#Create the actual event to duplicate
	var event_template: Event = Event.new()
	event_template.effects = event_effects
	event_template.params_to_update = updating_params_list
	
	var launcher = EventLauncher.new(event_template, actor, card)
	
	return launcher
