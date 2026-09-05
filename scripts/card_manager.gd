class_name CardManager extends Node3D

#sent to notify it created a card
signal created_card(card: Card)
#used to request the parent to mark themself as owner of card
signal requested_card_owner(card: Card)

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
	- start_pos: the global location for the card
'''
func instantiate_card(data: CardData, start_pos: Vector3 = position):
	var new_card: Card = card_scene.instantiate()
	new_card.position = start_pos
	
	#This needs to be after add child or the owner will get reset I guess
	requested_card_owner.emit(new_card)
	
	new_card.card_data = data
	
	print("\nNew Card Created: %s" % new_card)
	
	#tell listeners a new card object has been made
	created_card.emit(new_card)
	
	#Bring the card into the fold
	add_child(new_card)
	
	return new_card

'''
Takes a card id and returns a newly created card.
Params:
	- card_id: a card id to look up in the table.
	- start_pos: the global location for the card
Return:
	- new_card: the newly created card object
'''
func instantiate_card_from_id(card_id: String, start_pos: Vector3 = position):
	var card_data = CardDatabase.get_card_data(card_id)
	return instantiate_card(card_data, start_pos)
