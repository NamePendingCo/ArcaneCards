@abstract
class_name EventParam extends Node

#Whether a selection is made by the player
var is_chosen: bool = true:
	set(val):
		is_chosen = val
		notify_property_list_changed()

var _actor: Actor = null
var _parent_card: Card = null

'''
Disables the parameter to ensure no further use.
'''
func disable():
	var connections = get_incoming_connections()
	for conn in connections:
		conn.signal.disconnect(conn.callable)

#================================================
# Private methods
#================================================

'''
Toggles visibility of a property depending on a given condition
'''
func _set_property_visibility(property: Dictionary, condition: bool):
	if condition:
		property.usage |= PROPERTY_USAGE_EDITOR
	else:
		property.usage &= ~PROPERTY_USAGE_EDITOR
