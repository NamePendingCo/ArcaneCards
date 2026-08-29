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

@abstract
func build_param() -> EventParam;

#Fills in the param references that are needed
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
