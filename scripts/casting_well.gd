class_name CastingWell extends SlottedCardArray

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
	_add_card_to_array(card, slot_num)

'''
Takes a list of cards and arranges them into the available
casting slots, in order. If there are not enough slots available,
ignores the last parts of the list.
Params:
	- cards: The ordered list of cards to attach, no repeats
'''
func set_casting_cards(cards: Array[Card]):
	
	cards = cards.slice(0, card_slots.size())
	
	for index in range(card_slots.size()):
		var slot = card_slots.get(index)
		var card = cards.get(index)
		
		if (card == null) and (card != slot.attached_card):
			var detached_card: Card = slot.attached_card
			
			slot.detach_card()
			add_card_to_well(card, index)
			
			if detached_card not in cards:
				detached_card.mark_to_discard()
