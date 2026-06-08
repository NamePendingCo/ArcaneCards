class_name Discard extends CardStack

# Called when the node enters the scene tree for the first time.
func _ready():
	stack = []

func _get_relevant_card_state():
	return Enums.CardState.DISCARD

'''
Alias function specialized for _add_card_to_stack
'''
func add_card_to_discard(card: Card, bottom_stack: bool = false):
	_add_card_to_stack(card, bottom_stack)

'''
Alias function specialized for _add_cards_to_stack
'''
func add_cards_to_discard(cards: Array[Card], bottom_stack: bool = false):
	_add_cards_to_stack(cards, bottom_stack)
