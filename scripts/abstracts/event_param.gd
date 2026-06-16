@abstract
class_name EventParam extends Resource

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
