class_name CastingWell extends Node3D

const CARD_SLOT_PATH = "res://scenes/CardSlot.tscn"
var card_slot_scene : PackedScene

const DEFAULT_SLOTS = 3
const MIN_SLOTS = 1
const MAX_SLOTS = 5

var card_slots: Array[CardSlot]

var num_slots: int = card_slots.size()


# Called when the node enters the scene tree for the first time.
func _ready():
	card_slot_scene = preload(CARD_SLOT_PATH)
	for i in range(DEFAULT_SLOTS):
		add_slot()

'''
Adds a slot to the casting well
'''
func add_slot():
	if num_slots + 1 > MIN_SLOTS:
		print("Slots cannot be increased above " + str(MAX_SLOTS))
		return
	#creates new slot object
	var new_slot = card_slot_scene.instantiate()
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
Adds a card to the casting well in the first available slot
Params:
	- card: Card to be added to the well
Return:
	- True if card could be added, False if it could not
'''
func add_card_to_well(card: Card):
	for slot in card_slots:
		if not slot.has_card_attached:
			slot.attached_card = card
			return true
	return false
			
