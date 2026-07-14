@abstract
class_name CardStack extends CasterElementBase

#An array of card_ids. The top of the stack is the least index
var _stack : Array[String] #TYPE TBD

var size: int:
	get: return _stack.size()
	set(val): pass

#================================================
# Public methods
#================================================

'''
Pops the top card of the stack.
Returns:
	- Top card from stack
'''
func pop_top_card():
	return _stack.pop_back()

'''
Pops an arbitrary number of cards from the stack. Pops remaining cards in stack if
more cards requested than in stack.
Params: 
	- num_cards: the number of cards to pop
Returns:
	- card_list: an array of all popped cards
'''
func pop_top_cards(num_cards: int):
	assert(num_cards >= 0, "Cannot pop negative cards")
	
	if num_cards > _stack.size():
		num_cards = _stack.size()
	
	var card_list = []
	for i in range(num_cards):
		card_list.append(pop_top_card())
	
	return card_list

'''
Gets a subset of the cards from the stack without removing from stack. Can count
from the top of the stack (default) or the bottom
Params:
	- num_cards: Number of cards to count
	- start_at_card: index of card to start counting from (start at 0)
	- from_bottom: count from the bottom instead
Returns: 
	- viewed_cards: a list of cards
'''
func view_cards(num_cards: int, start_at_card = 0, from_bottom: bool = false):
	if from_bottom:
		return _stack.slice(start_at_card, num_cards + start_at_card)
	else:
		var begin = _stack.size() - (start_at_card + 1)
		var end = begin - num_cards
		return _stack.slice(begin, end, -1)

'''
Pops a card_id from the middle of the stack
Params:
	index: the index you want, counting from either top or bottom
	- from_bottom: start counting from bottom of the stack
Return: the card id
'''
func grab_card(index: int, from_bottom: bool = false):
	if from_bottom:
		return _stack.pop_at(index)
	else:
		return _stack.pop_at(size - (index + 1))

'''
Grabs cards based on a list of indices. 

Params:
	- indices: a list of indices in the list. Assumed to have no repeats and to be all
	within the range of the size of the stack
	- from_bottom: start counting from bottom of the stack
'''
func grab_cards(indices: Array[int], from_bottom: bool = false):
	var cardlist = []
	indices.sort()
	#needs to flip order to function if counting from the bottom of the list
	if from_bottom:
		indices.reverse()
	for index in indices:
		cardlist.append(grab_card(index, from_bottom))

	return cardlist

#================================================
# Private methods
#================================================

'''
Places a card on the top or bottom of stack, defaulting to the top, as a card_id
Params:
	- card: The card to push
	- bottom_stack: Boolean for if should place on bottom of stack. Defaults false
'''
func _add_card_to_stack(card: Card, bottom_stack: bool = false):
	var card_id = card.card_data.card_id
	card.location = _get_relevant_location()
	#Wait for it to move before destroying it
	await card.animate_move_card(global_transform.origin)
	if bottom_stack:
		_stack.push_front(card_id)
	else:
		_stack.push_back(card_id)
	card.self_destruct()

'''
Places a list of cards on top or bottom of stack, defaulting to top
Params:
	- cards: The cards to push
	- bottom_stack: Boolean for if should place on bottom of stack. Defaults false
'''
func _add_cards_to_stack(cards: Array[Card], bottom_stack: bool = false):
	for card in cards:
		_add_card_to_stack(card, bottom_stack)
