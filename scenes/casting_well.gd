class_name CastingWell extends Node3D

const DEFAULT_SLOTS = 3
const MIN_SLOTS = 1
const MAX_SLOTS = 5

#backdoor num_slot exists to override regular limits on slot min and max
var _num_slots: int
var num_slots = _num_slots:
	set(new_total): _num_slots = clamp(new_total, MIN_SLOTS, MAX_SLOTS)

var cards_in_well: Array[Card]

# Called when the node enters the scene tree for the first time.
func _ready():
	cards_in_well = []
	cards_in_well.resize(DEFAULT_SLOTS) #Sets size of well to default size of 3

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

'''
Adds a card to the casting well in the first available slot
Params:
	- card: Card to be added to the well
Return:
	- True if card could be added, False if it could not
'''
func add_card_to_well(card: Card):
	if null not in cards_in_well:
		return false
	elif card not in cards_in_well:
		#TODO
		return true
	else:
		return false
		
