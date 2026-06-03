class_name CardSlot extends Node3D

#distance a card should be from the card slot
const CARD_DISTANCE = 0.01

var _attached_card: Card
var has_card_attached: bool

# Called when the node enters the scene tree for the first time.
func _ready():
	_attached_card = null

func attach_card(card: Card):
	if card == null:
		return
	_attached_card = card
	has_card_attached = true

	#moves the card to a position just above the card slot
	var card_pos = global_transform.origin + transform.basis.x * CARD_DISTANCE
	card.animate_move_card(card_pos)
	card.detatched_from_slot.connect(detach_card)

'''
Detatches the card in the slot, if present. Returns true if there was a card, false if not
'''
func detach_card():
	if _attached_card != null:
		_attached_card.detatched_from_slot.disconnect(detach_card)
		_attached_card = null
		has_card_attached = false
		return true
	else:
		return false
