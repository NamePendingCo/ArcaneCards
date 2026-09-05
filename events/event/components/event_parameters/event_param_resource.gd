@tool
@abstract
class_name EventParamResource extends Resource

#Whether a selection is made by the player
var is_chosen: bool = true:
	set(val):
		is_chosen = val
		notify_property_list_changed()

#An array that require references to other params
#that need to be coompleted after all params are made
var unfinished_params: Array[EventParam] = []

'''
Abstract function. Used to build the parameter at runtime.
'''
@abstract
func build_param(actor: Actor, card: Card) -> EventParam;

'''
Fills in the param references that are needed that could not be built
in initial call because they referenced external parameters that might
not have been created as objects yet.
Params:
	- param_dict: A dictionary of parameters to use to set parameter vals
'''
func complete_unfinished_params(params_dict: Dictionary[String, EventParam]):
	unfinished_params.clear()
	

'''
Toggles visibility of a property depending on a given condition
'''
func _set_property_visibility(property: Dictionary, condition: bool):
	if condition:
		property.usage |= PROPERTY_USAGE_EDITOR
	else:
		property.usage &= ~PROPERTY_USAGE_EDITOR
