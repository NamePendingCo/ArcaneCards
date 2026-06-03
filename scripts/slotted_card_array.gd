@abstract
class_name SlottedCardArray extends Node3D

#actual tracker for card slots. Each hold reference to card in well
@export
var card_slots: Array[CardSlot]

'''
Just used to return the state a card should be changed to when attached
'''
@abstract
func _get_relevant_card_state()

#easy variable for tracking size of card_slots
var num_slots: int:
	get: return card_slots.size()
	set(val): pass

'''
Helper function that attaches a card to a card slot
Params:
	- card: a card
	- slot: a card slot
Returns: True on success, false on failure
'''
func _attach_card_to_slot(card: Card, slot: CardSlot):
	if not slot.has_card_attached:
		#must process that the card's state is changing first
		card.ready_state_change(_get_relevant_card_state())
		#then attaches card, as 
		slot.attach_card(card)
		return true
	else:
		var notif_str = "Failed to attach %s to slot %s of %s"
		print(notif_str % [card.card_data.cardName, str(slot), str(self)])
		return false

'''
Adds a card to the zone. Defaults to first available slot unless specified
Params:
	- card: Card to be added to the well
	- slot_num: the index of the slot, or -1 if first available slot
Return:
	- True if card could be added, False if it could not
'''
func _add_card_to_array(card: Card, slot_num: int=-1):
	if slot_num == -1:
		for slot in card_slots:
			if _attach_card_to_slot(card, slot):
				return true
	elif slot_num >= 0 and slot_num < num_slots:
		return _attach_card_to_slot(card, card_slots[slot_num])
	return false
	
func get_first_card_in_array():
	for slot in card_slots:
		if slot.has_card_attached:
			return slot._attached_card
	return null
