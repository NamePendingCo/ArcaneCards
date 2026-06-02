class_name CardSlot extends Node3D

#distance a card should be from the card slot
const CARD_DISTANCE = 0.01

var attached_card: Card: set=attach_card
var has_card_attached: bool = (attached_card != null)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func attach_card(card: Card):
	attached_card = card
	if card != null:
		#moves the card to a position just above the card slot
		var card_pos = position + transform.basis.x * CARD_DISTANCE
		card.animate_move_card(card_pos)

'''
Detatches the card in the slot, if present. Returns true if there was a card, false if not
'''
func detach_card():
	if attached_card != null:
		attached_card = null
		return true
	else:
		return false
