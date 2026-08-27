@tool
class_name EventData extends Resource

'''
Wrapper for a collection of events and parameters. Useful for
storing on a player.
'''

var debug_log: bool = false

#@export_subgroup("Events and Effects")
#list of targeting parameters which are used by effects
@export var parameters: Dictionary[String, EventParam] = {}

#dictionary of events on this card
@export
var events: Dictionary[String, EventResource] = {}

'''
Sets up the collection of the events
Params:
	- actor: the actor who controls the events
	- card: optional param. If present, card the event is associated with
'''
func setup_events(actor: Actor, card: Card = null):
	for param_name in parameters:
		if debug_log: print("Setting up parameter: %s" % param_name)
		_set_up_parameter(parameters[param_name], actor, card)
		
	for event_name in events:
		if debug_log: print("Setting up event: %s" % event_name)
		var event: Event = events[event_name]
		
		#Set the event to use the card's actor and card
		event.actor = actor
		event.parent_card = card
		
		_prepare_event_params(event, event_name)

#================================================
# Private methods
#================================================

'''
Sets up the parameters to be ready for the game.
'''
func _set_up_parameter(parameter: EventParam, actor: Actor, card: Card = null):
	parameter._being_parent = actor
	parameter._card_parent = card
	
	#Connect all relevant signals to parameter
	if parameter is BeingTargetParam:
		parameter.selection_requested.connect(actor._choose_being_from_range)
		
		#Allow for requesting the being list from actor
		if parameter is BeingTargetFilterParam:
			parameter = parameter as BeingTargetFilterParam
			parameter.requested_beings_list.connect(actor._pass_all_beings_to_param)
			
	elif parameter is CardTargetParam:
		parameter.selection_requested.connect(actor._choose_card_from_range)
		
		#Allow for requesting the cards list from actor
		if parameter is CardTargetFilterParam:
			parameter = parameter as CardTargetFilterParam
			parameter.requested_cards_list.connect(actor._pass_all_cards_to_param)
			
			var being_target_name: String = parameter.being_range_name
			var being_param = parameters[being_target_name] if being_target_name in parameters else null
			
			assert(being_param != null, \
			"CardTargetFilterParam %s wants parameter %s, but it is not in params list" % [parameter, being_target_name])
			
			parameter._being_range = parameters[being_target_name]

'''
Prepares an event's parameters and makes sure they are all appropriately set.
'''
func _prepare_event_params(event: Event, event_name: String):
	if debug_log: print("Preparing event params for event %s" % event_name)
	#Populate param list from names
	for param_name in event.choice_param_names:
		var param = parameters[param_name] if param_name in parameters else null
		
		assert(param != null, \
		"Event %s wants parameter %s, but it is not in params list" % [event_name, param_name])
		
		assert(param.is_chosen, \
		"Event %s wants to choose parameter %s, but it is not chosen" % [event_name, param_name])
		
		event.params_to_update.append(parameters[param_name])
		
		#Auto set initial value for param if it is not chosen
		if not param.is_chosen:
			param.update_range()
			
	
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
	
