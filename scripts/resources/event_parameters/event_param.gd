@abstract
class_name EventParam extends Node

#Whether a selection is made by the player
var is_chosen: bool

var actor: Actor = null
var parent_card: Card = null

func _init(my_actor: Actor, my_card: Card, chosen: bool):
	actor = my_actor
	parent_card = my_card
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
