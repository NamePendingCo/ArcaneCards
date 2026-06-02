class_name CardManager extends Node3D

const CARD_SCENE_PATH = "res://scenes/Card.tscn"

var card_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	card_scene = preload(CARD_SCENE_PATH)

'''
Creates a new card, then returns it
Params:
	- data: the card data to use for the card object
Return:
	- new_card: the newly created card object
'''
func instatiate_card(data: CardData):
	var new_card = card_scene.instantiate()
	add_child(new_card)
	new_card.data = data
	return new_card

'''
Params:
	- card: the card to move
	- new_pos: the new location for the card
'''
func animate_move_card(card: Card, new_pos: Vector3):
	var tween = get_tree().create_tween()
	tween.tween_property(card, "position", new_pos, 0.1)
