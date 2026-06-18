@abstract
class_name EventParam extends Resource

signal updated_targets

'''
this is purely an abstract class made to help
categorize the param classes for list making.
'''

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
