@abstract
class_name TargetParam extends EventParam

signal updated_targets

@export_category("Selection")

#Whether the target is chosen by the player
var is_chosen: bool = false:
	set(val): 
		is_chosen = val
		notify_property_list_changed()

'''
Toggles visibility of a property depending on a given condition
'''
func set_property_visibility(property: Dictionary, condition: bool):
	if condition:
		property.usage |= PROPERTY_USAGE_EDITOR
	else:
		property.usage &= ~PROPERTY_USAGE_EDITOR

'''
Takes the range and grabs all viable targets. Has the 
owner choose the target, if applicable.
'''
@abstract
func get_targets(actor: Being)
