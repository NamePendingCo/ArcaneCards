class_name Caster

extends Being

#List of important children to track
var card_manager: CardManager
var my_deck: Deck
var my_hand: Hand
#var my_discard: Discard
#var my_casting_well: CastingWell
#var my_conc_circle: ConcentrationCircle

var mana: int

func _ready():
	super()
	card_manager = $"CardManager"
	my_hand = $"Hand"
	my_deck = $"Deck"

#Enum for determining destinations for drawn cards. Maybe should be moved
enum DrawDest {
	HAND, #draw right to hand
	SELECTION, #send cards to a selection page to choose from them
	DISCARD #send directly to discard
}

#TODO: Handle dest value
'''
Takes in a number of cards to draw from the deck. Draws them, then sends them to
a destination, defaulting to the hand.
Params:
	num_drawn: Number of cards drawn, defaults to 1
	dest: Enum specifying destination of where the cards should go. 
	Defaults to the hand (0). 
'''
func draw(num_drawn: int = 1, dest: DrawDest = DrawDest.HAND):
	if num_drawn <= 0:
		print("Cannot draw " + str(num_drawn) + " Cards")
		return
	
	if dest > 0:
		print("Non-implemented draw destination: " + str(dest))
		return
	else:
		#get list of cards from the deck
		var card_ids = my_deck.pop_top_cards(num_drawn)
		#loop through card ids, get data, make a card, then add it to hand
		for id in card_ids:
			var card_data = CardDatabase.get_card_data(id)
			var drawn_card = card_manager.instatiate_card(card_data, my_deck.position)
			
			#rotates card to be flat and readable
			drawn_card.rotate_object_local(Vector3.RIGHT, PI/-2) 
			my_hand.add_card_to_hand(drawn_card)
		
func _input(event):
	if event.is_action("debug_draw"):
		draw(1)
