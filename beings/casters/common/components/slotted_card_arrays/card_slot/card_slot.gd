class_name CardSlot extends Node3D

#distance a card should be from the card slot
const CARD_DISTANCE = 0.01

var _attached_card: Card
var attached_card: Card:
	get(): return _attached_card
	set(val): pass
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
	
	#When the card has its state changed again, this will make it automatically detatch
	card.changed_location.connect(_handle_card_moving)

'''
Detatches the card in the slot, if present. Returns true if there was a card, false if not
'''
func detach_card() -> Card:
	if _attached_card != null:
		var removed_card = _attached_card
		
		#disconnect the signal as card won't be attached anymore
		_attached_card.changed_location.disconnect(_handle_card_moving)
		_attached_card = null
		has_card_attached = false
		return removed_card
	else:
		return null

func _handle_card_moving(_old_loc, _new_loc):
	detach_card()
