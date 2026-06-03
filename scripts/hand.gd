class_name Hand extends Node3D

#shorthand access to this enum val
const IN_HAND = Enums.CardState.IN_HAND

var hand: Array[Card] = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

#TODO: Delete this or change to return list of IDs
'''
Utility function just to get the list of cards in the hand
Returns: a string of the list of card names
'''
func list_cards_in_hand():
	var card_names = []
	for card in hand:
		card_names.append(card.card_data.cardName)
	return ", ".join(card_names)

func add_card_to_hand(card: Card):
	if card not in hand:
		card.left_hand.connect(remove_card_from_hand)
		card.ready_state_change(IN_HAND)
		hand.append(card)
		_update_hand_positions()

func remove_card_from_hand(card: Card):
	if card in hand:
		card.left_hand.disconnect(remove_card_from_hand)
		hand.erase(card)
		_update_hand_positions()

'''
Updates the positions of all cards in the hand based on their sizes
'''
func _update_hand_positions():
	for i in range(hand.size()):
		#get offset of the card relative to hand
		var offset = calculate_card_offset(i)
		
		#adds the offset to the hand origin to shift card
		var new_pos = global_transform.origin + offset
		
		#move the card into new position
		hand[i].animate_move_card(new_pos)

'''
Calculates the position a card should be assigned based on its index:
Params:
	- index: the index of a card in the hand
Returns:
	- offset: Vector3 for the relative position of the card to the hand origin
'''
func calculate_card_offset(index: int):
	# Takes card with then gives space on either side
	var card_space = Constants.CARD_WIDTH + 0.2 
	var total_width = (hand.size() - 1) * card_space
	
	#extends out left and right from the hand node, remaining centered
	var offset = transform.basis.x * (index * card_space - int(total_width/2))
	
	return offset
