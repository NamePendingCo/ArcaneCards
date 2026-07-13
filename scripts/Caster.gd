@abstract
class_name Caster

extends Being

signal paying_upkeep #send out before paying upkeep

signal created_event(event)

const INITIAL_DRAW_KEY = "initial_draw"
const STANDARD_DRAW_KEY = "standard_draw"

#List of important children to track
@onready var card_manager: CardManager = $CardManager
@onready var my_hand: Hand = $Hand
@onready var my_deck: Deck = $Deck
@onready var my_discard: Discard = $Discard
@onready var my_casting_well: CastingWell = $CastingWell
@onready var my_conc_circle: ConcentrationCircle = $ConcentrationCircle

@onready var basic_events: EventData = load("res://system_events/caster_basic_events.tres").duplicate_deep()

var mana: int

var _casting_selection: CardTargetFilterParam

func _ready():
	super()
	add_to_group(Constants.GROUP_CASTER)
	
	#Connect all newly created cards with the register function
	card_manager.created_card.connect(_register_card)
	#Register to set self as owner of card when card object is first made
	card_manager.requested_card_owner.connect(_set_owner_of_card)
	
	_create_casting_selection_range()
	
	basic_events.setup_events(self)

#Enum for determining destinations for drawn cards. Maybe should be moved
enum DrawDest {
	HAND, #draw right to hand
	SELECTION, #send cards to a selection page to choose from them
	DISCARD #send directly to discard
}

#================================================
# Public methods
#================================================

func on_game_start():
	print("Running game start events for %s" % name)
	
	#Activate all basic event
	for event_name in basic_events.events:
		basic_events.events[event_name].event_state = Event.EventState.ACTIVE
	
	#Do standard draw
	basic_events.events[INITIAL_DRAW_KEY].trigger()

'''
Notify all actors that caster is paying upkeep
'''
func declare_paying_upkeep():
	paying_upkeep.emit() #notify battle manager
	my_conc_circle.prepare_pay_circle_upkeep() #notify cards in circle

'''
Adds a card to the hand
Params:
	- card: the card to move
'''
func move_to_hand_card(card: Card):
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
	if card.in_play:
		my_conc_circle.add_card_to_conc_circle(card, slot)

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
	print("%s drawing %d cards" % [self, num_drawn])
	
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
			var drawn_card = card_manager.instantiate_card_from_id(id, my_deck.global_transform.origin)
			
			move_to_hand_card(drawn_card)
		return true

'''
Sends passed card to the deck pile. 
Params:
	- card: card to add to the deck
	- bottom_deck: if true, will place card on bottom of deck
'''
func move_to_deck_card(card: Card, bottom_deck: bool=false):
	my_deck.add_card_to_deck(card, bottom_deck)

'''
Sends passed card to the discard pile
'''
func discard_card(card: Card):
	my_discard.add_card_to_discard(card)

func move_card_from_discard_pile(index: int, dest: DrawDest = DrawDest.HAND):
	if index >= my_discard.size:
		return false
	
	var grabbed_id = my_discard.grab_card(index)
	
	if dest > 0:
		print("Non-implemented draw destination: " + str(dest))
		return false
	else:
		var card = card_manager.instantiate_card_from_id(grabbed_id, my_discard.global_transform.origin)
		move_to_hand_card(card)
		return true

'''
OVERRIDES
For casters, the most important casting phase decision is to choose the cards.
Make a selection for what cards should be cast during the casting phase.

The default behavior is to choose randomly, but should always be overriden
in every subclass of caster.
'''
func make_casting_phase_decisions():
	_casting_selection._being_range.update_range()
	
	_random_target_selection(_casting_selection)

'''
OVERRIDES
Takes the cards selected for the casting phase and actually casts them.
'''
func reveal_casting_phase_decisions():
	my_casting_well.set_casting_cards(_casting_selection.targets)

#================================================
# Private methods
#================================================

'''
Connects a card's signals to the caster
Params:
	- card: The card to connect with
'''
func _register_card(card: Card):
	card.requested_loc_change.connect(_process_card_loc_change_request.bind(card))

'''
This function is a hotfix for an order of operations issue regarding creating events.
I think it will be removed if we can rework events not to need their owners listed.
'''
func _set_owner_of_card(card: Card):
	card.card_caster = self

'''
Creates a range that covers all the cards owned by the player. Used for
the casting selection.
'''
func _create_casting_selection_range():
	var self_range = BeingTargetFilterParam.new()
	self_range.range_option = EventEnums.BeingRangeOption.SELF
	self_range._being_parent = self
	self_range.requested_beings_list.connect(_pass_all_beings_to_param)
	
	_casting_selection = CardTargetFilterParam.new()
	_casting_selection._being_range = self_range
	_casting_selection._being_parent = self
	_casting_selection.location_range = [Card.Location.HAND, Card.Location.CASTING_WELL]
	
	_casting_selection.num_targets_min = 0
	#Max casting should always match number of slots
	_casting_selection.num_targets_max = my_casting_well.num_slots
	my_casting_well.num_slots_updated.connect(func(num): _casting_selection.num_targets_max = num)
	
	_casting_selection.requested_cards_list.connect(_pass_all_cards_to_param)

'''
Only ever called by signal. Takes in a request from a card to have its
location change and passes to the appropriate method.
Params:
	- location: the new location to change to
	- args: optional. can be anything, usually an array. If usable, will be passed to appropriate func
	- card: the card emitting the signal
'''
func _process_card_loc_change_request(location: Card.Location, args, card: Card):
	match location: 
		Card.Location.HAND:
			move_to_hand_card(card)
			
		Card.Location.CASTING_WELL:
			'''For casting well, args should be an int'''
			var slot = args if args is int else -1
			cast_card(card, slot)
			
		Card.Location.CONCENTRATION_CIRCLE:
			'''For concentrtion circle, args should be an int'''
			var slot = args if args is int else -1
			move_to_conc_circle_card(card, slot)
			
		Card.Location.DECK:
			'''For concentrtion circle, args should be a bool'''
			var bottom_deck = args if args is bool else false
			move_to_deck_card(card, bottom_deck)
			
		Card.Location.DISCARD:
			discard_card(card)

'''
Only should activate via signal from battle manager. Actually pays upkeep cost
'''
func _pay_total_upkeep():
	mana -= my_conc_circle.pay_circle_upkeep()

'''
Make a random selection of targets.
Param:
	
'''
func _random_target_selection(target_param: TargetParam):
	target_param.update_range()
	
	if target_param.targets_range.size() < target_param.num_targets_max:
		target_param.targets = target_param.targets_range
		return
	
	#Creates a random unique seed just for this moment
	var random = RandomNumberGenerator.new()
	random.randomize()
	
	var index_array: Array[int] = []
	
	for i in range(target_param.targets_range.size()):
		if target_param.targets_range[i] in target_param.targets:
			continue
		index_array.append(i)
	
	var final_selections = []
	
	#For some really stupid reason this works for the typing issue
	#to make it so we can handle any type of array here
	if target_param is BeingTargetParam:
		var setup_arr: Array[Being] = []
		final_selections = setup_arr
	elif target_param is CardTargetParam:
		var setup_arr: Array[Card] = []
		final_selections = setup_arr
	
	final_selections.append_array(target_param.targets)
	
	for i in range(target_param.num_targets_max - final_selections.size()):
		var rand_choice = random.randi_range(0, index_array.size() - 1)
		
		var rand_index = index_array.pop_at(rand_choice)
		
		final_selections.append(target_param.targets_range[rand_index])

	
	target_param.targets = final_selections
