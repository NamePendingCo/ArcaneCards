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
actor: Actor = null, card: Card = null, event_name: String = "") -> EventLauncher:
	
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
	
	#Build the list of parameters to update
	var updating_params_list: Array[EventParam] = []
	for param_name in params_to_update:
		updating_params_list.append(param_dict[param_name])
	
	event_template.params_to_update = updating_params_list
	
	var launcher = EventLauncher.new(event_template, actor, card)
	launcher.name = event_name + "_launcher"
	
	return launcher

'''
Very silly helper function that is used by an effect launcher
'''
func _repopulate_params(event: Event, param_dict: Dictionary[String, EventParam]):
	var event_effects = event.effects
	
	for i in range(mini(effects.size(), event_effects.size())):
		var effect_resource: EffectResource = effects[i]
		var effect = event_effects[i]
		
		effect_resource.populate_params(effect, param_dict)
