@abstract
class_name SlottedCardArray extends CasterElementBase

## Parent class for casting well and concentration circle.
## 
## Allows for tracking a batch of cards in a bunch.

## actual tracker for card slots. Each hold reference to card in well
@export
var card_slots: Array[CardSlot]

## Easy variable for tracking size of card_slots
var num_slots: int:
	get: return card_slots.size()
	set(val): pass

var cards: Array[Card]:
	get:
		var cards_array: Array[Card] 
		cards_array.assign(card_slots.map(func(slot: CardSlot): return slot.attached_card))
		return cards_array
	set(val): pass

#================================================
# Public methods
#================================================

func get_first_card_in_array():
	for slot in card_slots:
		if slot.has_card_attached:
			return slot.attached_card
	return null

## Gets the slot a card is in. Or -1 if its not in a slot. [br][br]
## Params: [br]
## - card: the card to check [br][br]
## Returns: [br]
## - the slot number of the card, or -1 if not present.
func get_cards_slot(card: Card):
	var slot_num = 0
	for slot in card_slots:
		if slot.attached_card == card:
			return slot_num
		slot_num += 1
	
	return -1

#================================================
# Private methods
#================================================

## Helper function that attaches a card to a card slot. [br][br]
## Params: [br]
## - card: a card. [br]
## - slot: a card slot. [br][br]
## Returns: True on success, false on failure
func _attach_card_to_slot(card: Card, slot: CardSlot):
	if not slot.has_card_attached:
		#must change the card's location first
		card.location = _get_relevant_location()
		#then attaches card, as 
		slot.attach_card(card)
		return true
	else:
		var notif_str = "Failed to attach %s to slot %s of %s"
		print(notif_str % [card.card_data.cardName, str(slot), str(self)])
		return false

## Adds a card to the zone. Defaults to first available slot unless specified. [br][br]
## Params: [br]
## - card: Card to be added to the well. [br]
## - slot_num: the index of the slot, or -1 if first available slot. [br][br]
## Return: [br]
## - True if card could be added, False if it could not.
func _add_card_to_array(card: Card, slot_num: int=-1):
	if slot_num == -1:
		for slot in card_slots:
			if _attach_card_to_slot(card, slot):
				return true
	elif slot_num >= 0 and slot_num < num_slots:
		return _attach_card_to_slot(card, card_slots[slot_num])
	return false
