class_name Hand extends Node3D

#width of a card object
const CARD_WIDTH = 300

var hand: Array[Card]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func add_card_to_hand(card: Card):
	if card not in hand:
		hand.append(card)
		update_hand_positions()

'''
Updates the positions of all cards in the hand based on their sizes
'''
func update_hand_positions():
	for i in range(hand.size()):
		#get offset of the card relative to hand
		var offset = calculate_card_offset(i)
		
		#adds the offset to the hand origin to shift card
		var new_pos = transform.origin + offset
		var card = hand[i]

'''
Calculates the position a card should be assigned based on its index:
Params:
	- index: the index of a card in the hand
Returns:
	- offset: Vector3 for the relative position of the card to the hand origin
'''
func calculate_card_offset(index: int):
	var total_width = (hand.size() - 1) * CARD_WIDTH
	
	var offset = transform.origin + transform.basis.y * index * CARD_WIDTH - total_width/2
	
	return offset
