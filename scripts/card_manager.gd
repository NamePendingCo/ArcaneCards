class_name CardManager extends Node3D

#sent to notify it created a card
signal created_card(card: Card)

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
func instantiate_card(data: CardData, start_pos: Vector3 = position):
	var new_card: Card = card_scene.instantiate()
	new_card.position = start_pos
	add_child(new_card)
	new_card.card_data = data
	#tell listeners a new card object has been made
	created_card.emit(new_card)
	print(new_card.card_data.cardName + " Created at " + str(new_card.position))
	return new_card

func instantiate_card_from_id(card_id: String, start_pos: Vector3 = position):
	var card_data = CardDatabase.get_card_data(card_id)
	return instantiate_card(card_data, start_pos)
