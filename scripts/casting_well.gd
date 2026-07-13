class_name CastingWell extends SlottedCardArray

signal num_slots_updated(new_num_slots) #Announce when slot num changes

const SPACE_BETWEEN_SLOTS = 0.8

#constants for number of slots
const DEFAULT_SLOTS = 3
const MIN_SLOTS = 1
const MAX_SLOTS = 5

#for creating new card slots
const CARD_SLOT_PATH = "res://scenes/CardSlot.tscn"
var card_slot_scene : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	card_slot_scene = preload(CARD_SLOT_PATH)
	for i in range(DEFAULT_SLOTS):
		add_slot()

func _get_relevant_location() -> Card.Location:
	return Card.Location.CASTING_WELL

'''
Adds a slot to the casting well
'''
func add_slot():
	if num_slots + 1 > MAX_SLOTS:
		print("Slots cannot be increased above " + str(MAX_SLOTS))
		return
	
	var offset = transform.basis.x * num_slots * (Constants.CARD_WIDTH + SPACE_BETWEEN_SLOTS)
	
	#creates new slot object
	var new_slot: CardSlot = card_slot_scene.instantiate()
	new_slot.set_position(offset)
	#adds as a child of well
	add_child(new_slot)
	#adds to list
	card_slots.push_back(new_slot)
	num_slots_updated.emit(num_slots)

'''
Removes the last slot from the slots list and destroys it.
'''
func remove_slot():
	if num_slots - 1 < MIN_SLOTS:
		print("Slots cannot be lowered below " + str(MIN_SLOTS))
		return
	
	var removed_slot = card_slots.pop_back()
	
	#discards the card attached to the node, if possible
	removed_slot.attached_card.discard()
	#delete as child
	remove_child(removed_slot)
	#clear from memory
	removed_slot.queue_free()
	num_slots_updated.emit(num_slots)

func set_slots(new_num_slots: int):
	#make sure not to go outside of slot range
	new_num_slots = clamp(new_num_slots, MIN_SLOTS, MAX_SLOTS)
	while new_num_slots != num_slots:
		if new_num_slots > num_slots:
			#adds slot if not enough
			add_slot()
		else:
			#removes slot if too many
			remove_slot()

'''
Alias for add card to array for casting well
'''
func add_card_to_well(card: Card, slot_num: int=-1):
	card.location = Card.Location.CASTING_WELL
	return _add_card_to_array(card, slot_num)

func move_card_in_well(slot_num_from: int, slot_num_to: int):
	_move_between_slots(card_slots[slot_num_from], card_slots[slot_num_to])

'''
Takes a list of cards and arranges them into the available
casting slots, in order. If there are not enough slots available,
ignores the last parts of the list.
Params:
	- cards: The ordered list of cards to attach, no repeats
'''
func set_casting_cards(cards: Array[Card]):
	
	print("selected cards to cast:")
	for card in cards:
		print(card.card_data.cardName)
	
	cards = cards.slice(0, card_slots.size())
	
	for index in range(card_slots.size()):
		var slot: CardSlot = card_slots.get(index)
		var card: Card = cards.get(index) if cards.size() > index else null
		
		if card == slot.attached_card:
			continue
		elif (card != null) and (card.location == Card.Location.CASTING_WELL):
			for other_slot in card_slots:
				if other_slot.attached_card == card:
					_move_between_slots(other_slot, slot)
					continue
		var detached_card: Card = slot.detach_card()
			
		if (detached_card != null) and (detached_card not in cards):
			detached_card.mark_to_discard()
		
		if card != null:
			add_card_to_well(card, index)

func _move_between_slots(slot_from: CardSlot, slot_to: CardSlot):
	var card = slot_from.detach_card()
	
	if not _attach_card_to_slot(card, slot_to):
		_attach_card_to_slot(card, slot_from)
