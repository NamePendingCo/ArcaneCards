@tool
class_name EventData extends Resource

#@export_subgroup("Events and Effects")
#list of targeting parameters which are used by effects
@export var parameters: Dictionary[String, EventParam] = {}

#dictionary of events on this card
@export
var events: Dictionary[String, Event] = {}

func setup_events(caster: Caster, card: Card = null):
	for param_name in parameters:
		parameters[param_name]._being_parent = caster
		parameters[param_name]._card_parent = card
	for event_name in events:
		var event: Event = events[event_name]
		
		#Set the event to use the card's actor and card
		event.actor = caster
		event.parent_card = card
		
		_prepare_event_params(event, event_name)

#================================================
# Private methods
#================================================

'''
Prepares an event's parameters and makes sure they are all appropriately set.
'''
func _prepare_event_params(event: Event, event_name: String):
	#Populate param list from names
	for param_name in event.choice_param_names:
		var param = parameters[param_name] if param_name in parameters else null
		
		assert(param != null, \
		"Event %s wants parameter %s, but it is not in params list" % [event_name, param_name])
		
		assert(param.is_chosen, \
		"Event %s wants to choose parameter %s, but it is not chosen" % [event_name, param_name])
		
		event.choice_params.append(parameters[param_name])
	
	for effect in event.effects:
		if effect is TargetedEffect:
			_prepare_target_param(effect, event_name)

'''
Set up the targeting parameter for a targeted effect.
Params:
	- effect: the effect to set up
	- event: name of parent event, for debugging
'''
func _prepare_target_param(effect: TargetedEffect, event_name: String):
	#get the name
	var target_param_name: String = effect.target_param_name
	
	assert(target_param_name in parameters, \
	"Event %s's effect %s target parameter %s not in params list" % \
	[event_name, effect.effect_id, target_param_name])
	
	#get the param
	var param = parameters[effect.target_param_name]
	
	#check type for a targetedEffect
	if effect is BeingEffect:
		effect.targets_param = param if param is BeingTargetParam else null
	elif effect is CardEffect:
		effect.targets_param = param if param is CardTargetParam else null
	
	assert(effect.targets_param != null, \
	"Event %s's effect %s target parameter %s is incorrect type"% \
	[event_name, effect.effect_id, target_param_name])
	
