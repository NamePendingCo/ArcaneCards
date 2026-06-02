class_name Deck extends Node3D

#An array of card_ids. The top of the deck is the least index
var deck : Array[String] = [] #TYPE TBD

'''
Pops the top card of the deck.
Returns:
	- Top card from deck
'''
func pop_top_card():
	return deck.pop_back()

'''
Pops an arbitrary number of cards from the deck. Pops remaining cards in deck if
more cards requested than in deck.
Params: 
	- num_cards: the number of cards to pop
Returns:
	- card_list: an array of all popped cards
'''
func pop_top_cards(num_cards: int):
	assert(num_cards >= 0, "Cannot pop negative cards")
	
	if num_cards > deck.size():
		num_cards = deck.size()
	
	var card_list = []
	for i in range(num_cards):
		card_list += pop_top_card()
	
	return card_list

'''
Places a card on the top or bottom of deck, defaulting to the top, as a card_id
Params:
	- card: The card to push
	- bottom_deck: Boolean for if should place on bottom of deck. Defaults false
'''
func add_card_to_deck(card: Card, bottom_deck: bool = false):
	var card_id = card.card_data.card_id
	if bottom_deck:
		deck.push_front(card_id)
	else:
		deck.push_back(card_id)

'''
Places a list of cards on top or bottom of deck, defaulting to top
Params:
	- cards: The cards to push
	- bottom_deck: Boolean for if should place on bottom of deck. Defaults false
'''
func add_cards_to_deck(cards: Array[Card], bottom_deck: bool = false):
	for card in cards:
		add_card_to_deck(card, bottom_deck)

'''
Gets a subset of the cards from the deck without removing from deck. Can count
from the top of the deck (default) or the bottom
Params:
	- num_cards: Number of cards to count
	- start_at_card: index of card to start counting from (start at 0)
	- from_bottom: count from the bottom instead
Returns: 
	- viewed_cards: a list of cards
'''
func view_cards(num_cards: int, start_at_card = 0, from_bottom: bool = false):
	if from_bottom:
		return deck.slice(start_at_card, num_cards + start_at_card)
	else:
		var begin = deck.size() - (start_at_card + 1)
		var end = begin - num_cards
		return deck.slice(begin, end, -1)
