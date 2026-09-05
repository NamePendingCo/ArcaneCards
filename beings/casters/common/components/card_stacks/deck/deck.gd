class_name Deck extends CardStack

func _ready():
	_stack = ["chilly_breeze", "echoing_roar", "echoing_roar", "chilly_breeze", "leech",
	"heat_cycle", "echoing_roar", "echoing_roar", "heat_cycle", "leech",
	"chilly_breeze", "heat_cycle", "echoing_roar", "chilly_breeze", "leech"] #TYPE TBD

func _get_relevant_location() -> Card.Location:
	return Card.Location.DECK

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
