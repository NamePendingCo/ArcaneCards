@abstract
class_name ListenerEvent extends Event

'''
This is an abstract class to cover all events that occur
inside a card but are not the activation event. Mainly
defined so that its easier to set up the card data UI
for design purposes so we only ever have one activation
event.
'''

#If true, this event runs after the event that triggered it
@export var isRunAfter: bool = false

'''
Disconnects from all existing trigger signals
'''
func disconnect_all_triggers():
	var connections = get_incoming_connections()
	for conn in connections:
		if conn.callable == trigger:
			conn.signal.disconnect(conn.callable)
