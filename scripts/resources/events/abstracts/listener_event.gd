@tool
@abstract
class_name ListenerEvent extends Event

'''
This is an abstract class to cover all events that occur
upon a signal instead of a direct internal trigger.
'''

#If true, this event runs after the event that triggered it
@export var isRunAfter: bool = false:
	set(val):
		isRunAfter = val
		notify_property_list_changed()

'''
Disconnects from all existing trigger signals
'''
func disconnect_all_triggers():
	var connections = get_incoming_connections()
	for conn in connections:
		if conn.callable == trigger:
			conn.signal.disconnect(conn.callable)

func _deactivate_event():
	super()
	disconnect_all_triggers()
