class_name Deck extends CardStack

func _ready():
	stack = ["chilly_breeze", "echoing_roar", "echoing_roar", "chilly_breeze"] #TYPE TBD

func _get_relevant_card_state():
	return Enums.CardState.DECK

'''
Alias function specialized for _add_card_to_stack
'''
func add_card_to_deck(card: Card, bottom_stack: bool = false):
	_add_card_to_stack(card, bottom_stack)

'''
Alias function specialized for _add_cards_to_stack
'''
func add_cards_to_deck(cards: Array[Card], bottom_stack: bool = false):
	_add_cards_to_stack(cards, bottom_stack)
