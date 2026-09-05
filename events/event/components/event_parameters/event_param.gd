@abstract
class_name EventParam extends Node

signal selection_requested #sent when asking actor to make a choice

#Whether a selection is made by the player
var is_chosen: bool

var actor: Actor = null:
	set = _set_actor
var parent_card: Card = null

func _init(my_actor: Actor, my_card: Card, chosen: bool):
	actor = my_actor
	parent_card = my_card
	is_chosen = chosen

#================================================
# Public methods
#================================================

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

func _set_actor(val: Actor):
	actor = val
