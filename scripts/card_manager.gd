class_name CardManager extends Node3D

const CARD_SCENE_PATH = "res://scenes/Card.tscn"

@export
var my_caster: Caster #the card manager's caster

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
func instatiate_card(data: CardData, start_pos: Vector3 = position):
	var new_card: Card = card_scene.instantiate()
	new_card.position = start_pos
	add_child(new_card)
	new_card.card_data = data
	new_card.card_owner = my_caster
	print(new_card.card_data.cardName + " Created at " + str(new_card.position))
	return new_card
