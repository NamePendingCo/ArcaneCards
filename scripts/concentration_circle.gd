class_name ConcentrationCircle extends SlottedCardArray

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _get_relevant_card_state():
	return Enums.CardState.IN_CIRCLE

'''
Alias for add card to array for concentration circle
'''
func add_card_to_conc_circle(card: Card, slot_num: int=-1):
	_add_card_to_array(card, slot_num)
