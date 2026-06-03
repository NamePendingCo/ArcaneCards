class_name CardSlot extends Node3D

#distance a card should be from the card slot
const CARD_DISTANCE = 0.01

var attached_card: Card
var has_card_attached: bool = (attached_card != null)

# Called when the node enters the scene tree for the first time.
func _ready():
	attached_card = null

func attach_card(card: Card):
	attached_card = card
	if card != null:
		#moves the card to a position just above the card slot
		var card_pos = global_transform.origin + transform.basis.x * CARD_DISTANCE
		card.animate_move_card(card_pos)
		card.detatched_from_slot.connect(detach_card)

'''
Detatches the card in the slot, if present. Returns true if there was a card, false if not
'''
func detach_card():
	if attached_card != null:
		attached_card.detatched_from_slot.disconnect(detach_card)
		attached_card = null
		return true
	else:
		return false
