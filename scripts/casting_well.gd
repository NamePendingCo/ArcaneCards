class_name CastingWell extends Node3D

const SPACE_BETWEEN_SLOTS = 0.8

#constants for number of slots
const DEFAULT_SLOTS = 3
const MIN_SLOTS = 1
const MAX_SLOTS = 5

#for creating new card slots
const CARD_SLOT_PATH = "res://scenes/CardSlot.tscn"
var card_slot_scene : PackedScene

#actual tracker for card slots. Each hold reference to card in well
var card_slots: Array[CardSlot]

#easy variable for tracking size of card_slots
var num_slots: int:
	get: return card_slots.size()
	set(val): pass

# Called when the node enters the scene tree for the first time.
func _ready():
	card_slot_scene = preload(CARD_SLOT_PATH)
	for i in range(DEFAULT_SLOTS):
		add_slot()

'''
Adds a slot to the casting well
'''
func add_slot():
	if num_slots + 1 > MAX_SLOTS:
		print("Slots cannot be increased above " + str(MAX_SLOTS))
		return
	
	var offset = transform.basis.x * num_slots * (Constants.CARD_WIDTH + SPACE_BETWEEN_SLOTS)
	
	var slot_pos = global_position + offset
	
	print(global_transform.origin)
	print(slot_pos)
	
	#creates new slot object
	var new_slot: CardSlot = card_slot_scene.instantiate()
	new_slot.global_position = slot_pos
	#adds as a child of well
	add_child(new_slot)
	#adds to list
	card_slots.push_back(new_slot)
	print(new_slot.transform)

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
Helper function that attaches a card to a card slot
Params:
	- card: a card
	- slot: a card slot
Returns: True on success, false on failure
'''
func _attach_card_to_slot(card: Card, slot: CardSlot):
	if not slot.has_card_attached:
		slot.attached_card = card
		card.handle_state_change(Enums.CardState.CASTING)
		return true
	else:
		return false

'''
Adds a card to the casting well in the first available slot
Params:
	- card: Card to be added to the well
Return:
	- True if card could be added, False if it could not
'''
func add_card_to_well(card: Card, slot_num: int=-1):
	if slot_num == -1:
		for slot in card_slots:
			if _attach_card_to_slot(card, slot):
				return true
	elif slot_num >= 0 and slot_num < num_slots:
		return _attach_card_to_slot(card, card_slots[slot_num])
	return false
	
	
