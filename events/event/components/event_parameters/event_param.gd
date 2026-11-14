@abstract
class_name EventParam extends Node

## Whether a selection is made by the player.
var is_chosen: bool

var actor: Actor = null:
	set = _set_actor
var parent_card: Card = null

#================================================
# Public methods
#================================================

## Helper function for static constructors.
func _set_base_vals(my_actor: Actor, my_card: Card, chosen: bool):
	actor = my_actor
	parent_card = my_card
	is_chosen = chosen

## Updates the value of the parameter. Will create a decision if needed.
@abstract func update_value() -> void;

## Disables the parameter to ensure no further use.
func disable():
	var connections = get_incoming_connections()
	for conn in connections:
		conn.signal.disconnect(conn.callable)

#================================================
# Private methods
#================================================

func _set_actor(val: Actor):
	actor = val
