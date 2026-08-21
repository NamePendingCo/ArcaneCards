@abstract
class_name EventParam extends Resource

signal selection_requested #sent when asking actor to make a choice

#Whether a selection is made by the player
var is_chosen: bool = true:
	set(val):
		is_chosen = val
		notify_property_list_changed()

var _being_parent: Being = null
var _card_parent: Card = null

'''
Asks the actor to make the choices for its parameters.
'''
func request_selection():
	if is_chosen:
		selection_requested.emit(self)

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
