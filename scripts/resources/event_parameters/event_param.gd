@abstract
class_name EventParam extends Node

#Whether a selection is made by the player
var is_chosen: bool

var actor: Actor = null
var parent_card: Card = null

func _init(chosen: bool):
	is_chosen = chosen

#================================================
# Public methods
#================================================

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
