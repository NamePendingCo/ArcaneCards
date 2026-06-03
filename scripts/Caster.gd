class_name Caster

extends Being

#List of important children to track
@onready var card_manager: CardManager = $CardManager
@onready var my_deck: Deck = $Deck
@onready var my_hand: Hand = $Hand
@onready var my_casting_well: CastingWell = $CastingWell
#var my_discard: Discard
#var my_casting_well: CastingWell
@onready var my_conc_circle: ConcentrationCircle = $ConcentrationCircle

var mana: int

func _ready():
	super()
	card_manager.created_card.connect(_register_card)

#Enum for determining destinations for drawn cards. Maybe should be moved
enum DrawDest {
	HAND, #draw right to hand
	SELECTION, #send cards to a selection page to choose from them
	DISCARD #send directly to discard
}

'''
Connects a card's signals to the caster and also sets its owner to this caster
Params:
	- card: The card to connect with
'''
func _register_card(card: Card):
	#card.marked_for_discard.connect() TODO
	card.marked_for_casting.connect(cast_card) #connects casting to card's signal
	card.marked_for_conc_circle.connect(move_to_conc_circle_card) #connects conc circle to card's signal

#TODO: Handle dest value
'''
Takes in a number of cards to draw from the deck. Draws them, then sends them to
a destination, defaulting to the hand.
Params:
	num_drawn: Number of cards drawn, defaults to 1
	dest: Enum specifying destination of where the cards should go. 
	Defaults to the hand (0). 
Returns:
	True on successful draw. False if failed
'''
func draw(num_drawn: int = 1, dest: DrawDest = DrawDest.HAND):
	if num_drawn <= 0:
		print("Cannot draw " + str(num_drawn) + " Cards")
		return false
	
	if dest > 0:
		print("Non-implemented draw destination: " + str(dest))
		return false
	else:
		#get list of cards from the deck
		var card_ids = my_deck.pop_top_cards(num_drawn)
		#loop through card ids, get data, make a card, then add it to hand
		for id in card_ids:
			var card_data = CardDatabase.get_card_data(id)
			var drawn_card = card_manager.instatiate_card(card_data, my_deck.position)
			
			move_to_hand_card(drawn_card)
		return true

'''
Adds a card to the hand
Params:
	- card: the card to move
'''
func move_to_hand_card(card):
	my_hand.add_card_to_hand(card)

'''
Send a spell into the casting well. 
Params:
	- card: the card to cast
	- slot: the slot to cast it to. If -1, does the first open slot. 
Return:
	- True if successful. False if not
'''
func cast_card(card: Card, slot: int=-1):
	my_casting_well.add_card_to_well(card, slot)

'''
Adds a card to the hand
Params:
	- card: the card to move
	- slot: the slot to move it to. If -1, does the first open move. 
'''
func move_to_conc_circle_card(card: Card, slot: int=-1):
	my_conc_circle.add_card_to_conc_circle(card, slot)

func _input(event):
	if event.is_action("debug_draw", true):
		draw(1)
		print("Drew a card")
		print("Hand: " + my_hand.list_cards_in_hand())
	elif event.is_action("debug_cast", true):
		if my_hand.hand.size() > 0:
			cast_card(my_hand.hand[0], -1)
			print("Cast card from hand")
			print("Hand: " + my_hand.list_cards_in_hand())
	elif event.is_action("debug_conc_from_well", true):
		if my_casting_well.card_slots[0].has_card_attached:
			move_to_conc_circle_card(my_casting_well.card_slots[0]._attached_card, -1)
			print("Concentration circle from well")
			print("Hand: " + my_hand.list_cards_in_hand())
	elif event.is_action("debug_conc", true):
		if my_hand.hand.size() > 0:
			move_to_conc_circle_card(my_hand.hand[0], -1)
			print("Concentration circle from hand")
	elif event.is_action("debug_return_conc", true):
		var grabbed_card = my_conc_circle.get_first_card_in_array()
		if grabbed_card != null:
			move_to_hand_card(grabbed_card)
		print("Returned from Circle")
		print("Hand: " + my_hand.list_cards_in_hand())
	elif event.is_action("debug_return", true):
		var grabbed_card = my_casting_well.get_first_card_in_array() 
		if grabbed_card != null:
			move_to_hand_card(grabbed_card)
		print("Returned from well", true)
		print("Hand: " + my_hand.list_cards_in_hand())
