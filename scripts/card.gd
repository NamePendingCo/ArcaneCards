class_name Card extends Node3D

const COLOR = Enums.SpellColor

#Core signals to denote state change
signal changed_location(new_state, old_state)
signal activated
signal invoked

#signals to tell the caster to move this card's location
signal requested_loc_change(new_loc: Location)

signal payment_declared(type) #Eventually set param type with an enum

enum Location {
	NULL,
	HAND,
	CASTING_WELL,
	CONCENTRATION_CIRCLE,
	DECK, #For cards just leaving or reentering the deck
	DISCARD, #For cards entering the discard or being taken out
	ANULLED,
	ATTACHED
}

var card_caster: Caster
#THIS SHOULD BE USED *ONLY* TO COMPARE OWNERS. NEVER CALL THIS

@export var card_data: CardData:
	set(value):
		#set the new data as the data for this card
		card_data = value
		
		# Set local variables from the card total so that data itself remains consistent
		upkeep = card_data.upkeep_cost \
			if card_data.type != Enums.CardType.INSTANT else -1
		activation_cost = card_data.activation_cost
		
		#set name in cardface
		spell_face.get_node("Name").text = card_data.cardName
		
		#TODO Make this more efficient, probably by preloading these guys
		var backdrop_path = ""
		match card_data.color:
			COLOR.NULL:
				backdrop_path = "res://assets/Blank Card.png"
			COLOR.RED:
				backdrop_path = "res://assets/card_bases/red_base_card.png"
			COLOR.ORANGE:
				backdrop_path = "res://assets/card_bases/orange_base_card.png"
			COLOR.YELLOW:
				backdrop_path = "res://assets/card_bases/yellow_base_card.png"
			COLOR.GREEN:
				backdrop_path = "res://assets/card_bases/green_base_card.png"
			COLOR.BLUE:
				backdrop_path = "res://assets/card_bases/blue_base_card.png"
			COLOR.PURPLE:
				backdrop_path = "res://assets/card_bases/purple_base_card.png"
				
		var backdrop: TextureRect = spell_face.get_node("CardBackdrop")
		backdrop.texture = load(backdrop_path)
		
		spell_face.get_node("Tier").text = ''
		for i in range(card_data.tier):
			spell_face.get_node("Tier").text += 'I'
		
		#creates the overview string and sets it on cardface
		spell_face.get_node("Overview").text = '-- ' + Enums.colorString(card_data.color) + ' (' + Enums.subdomainString(card_data.subdomain) + ') -- ' + Enums.typeString(card_data.type) + ' --'
		
		spell_face.get_node("Effects").text = card_data.effects_text
		
		#reset the viewport so it reloads with the new info
		_reload_cardface()
		
		#Store a new set of the events
		_reset_event_data()

var activation_cost: Array[int]:
	set(ac):
		activation_cost = ac
		match card_data.tier:
			1: spell_face.get_node("ActivationCost").text = str(ac[0])
			2: spell_face.get_node("ActivationCost").text = str(ac[0]) + '/' + str(ac[1])
			3: spell_face.get_node("ActivationCost").text = str(ac[0]) + '/' + str(ac[1]) + '/' + str(ac[2])
var upkeep: int:
	set(val):
		#set upkeep cost on cardface
		upkeep = min(val, -1)
		if upkeep == -1:
			spell_face.get_node("UpkeepCost").text = str("")
		else:
			spell_face.get_node("UpkeepCost").text = str(val)

#Dictionary of parameters attached to this card
var parameters: Dictionary[String, EventParam]
#Dictionary of events on this card
var events: Dictionary[String, Event]

#In game states
var location: Location: 
	set(new_loc):
		#This setter should be its own function, but Godot refused to cooperate
		var old_loc = location
	
		if location == new_loc:
			return
		
		location = new_loc
		
		if location not in [Location.CONCENTRATION_CIRCLE, Location.ATTACHED]:
			deactivate()
		
		changed_location.emit(new_loc, old_loc)

# Whether the card is in play or not
var _in_play: bool
var in_play: bool:
	get: return _in_play
	set(val): return

#when true, card can be dragged around by player. When false, cannot move
#for now, assume always can while in hand or state is null. Probably fix later
var position_locked: bool:
	get: return location <= Location.HAND
	set(val): pass

@onready var spell_face: Control = $"Cardfront/SubViewport/CardFace"
@onready var viewport: Viewport = $"Cardfront/SubViewport"

var _rounds_spent_casting: int: 
	set(val): _rounds_spent_casting = max(val, 0)
var _delay_amount: int: 
	set(val): _delay_amount = max(val, 0)
var _quicken_amount: int: 
	set(val): _quicken_amount = max(val, 0)

func _ready():
	#Add to the card group
	add_to_group(Constants.GROUP_CARD)
	
	card_caster = null
	location = Location.NULL
	in_play = false
	_reset_casting_data()

#================================================
# Public Methods
#================================================

'''
Has the card object destroy itself. First disables all parameters and events.
'''
func self_destruct():
	_disable_params_and_events()
	self.queue_free()

#TODO: Add flipping support here perhaps?
'''
Runs a tween to move the card to a new location
Params:
	- new_pos: the new location for the card
'''
func animate_move_card(new_pos: Vector3):
	var tween = get_tree().create_tween()
	tween.tween_property(self, "global_position", new_pos, 0.2)

'''
Increases the casting stage. If it is ready to activate,
activate the card.
'''
func progress_casting(progress_increment: int):
	_rounds_spent_casting += progress_increment
	
	var progress_total = _rounds_spent_casting + _quicken_amount
	var wait_total = card_data.tier + _delay_amount
	
	if progress_total >= wait_total:
		activate()

'''
In play to true. Set all events to active. Then run the activation event. 
Finally move to conc circle if concentration card.
'''
func activate():
	_in_play = true
	
	for event_name in events:
		var event = events[event_name]
		event.event_state = Event.EventState.ACTIVE
		
	events[Constants.ACTIVATION_KEY].trigger()
	
	#notifies card was activated
	activated.emit()
	
	#If a concentration card, also mark to move to concentration circle
	if card_data.type in Enums.CONC_TYPES:
		_request_loc_change(Location.CONCENTRATION_CIRCLE)

'''
Sets in play to false and deactivates all events.
'''
func deactivate():
	_in_play = false
	
	for event_name in events:
		var event = events[event_name]
		event.event_state = Event.EventState.INACTIVE

### Below are functions for sending signals pre-events occuring

'''
Called by other classes to tell the card it should be discarded. Used to signal
to the caster it should be discarded.
'''
func mark_to_discard():
	_request_loc_change(Location.DISCARD)

'''
Called by other classes to tell the card to be cast. 
Params:
	- slot: the slot the card should be cast to. -1 means first open
'''
func mark_to_cast():
	_request_loc_change(Location.CASTING_WELL)

#TODO merge with pay upkeep. Use awaits instead
'''
Emits a signal saying its upkeep is about to be paid.
'''
func prepare_pay_upkeep():
	payment_declared.emit("upkeep") #TODO swap with Enum

'''
Actually pays the upkeep. Handles any effects that are set up on card for this.
'''
func pay_upkeep():
	#TODO Add handling for cost counters
	return upkeep

#================================================
# Private Methods
#================================================

'''
Args allows for optional parameters to be passed if necessary,
such as slot number, or whether to place in bottom of deck. By
default will emit something empty the caster can ignore.
'''
func _request_loc_change(new_loc: Location, args=[]):
	requested_loc_change.emit(new_loc, args)

'''
Set all casting data back to 0.
'''
func _reset_casting_data():
	_rounds_spent_casting = 0
	_delay_amount = 0
	_quicken_amount = 0

'''
Resets the event data of this card to be based on the card data.
'''
func _reset_event_data():
	#Disable old data
	_disable_params_and_events()
	
	#Create a copy of the base resource from card_data.
	var event_data: CardEventData = card_data.event_data.duplicate_deep(Resource.DEEP_DUPLICATE_ALL)
	
	print("Card owner in card: %s" % card_caster)
	
	#Set up the events in the event_data
	event_data.setup_events(card_caster, self)
	
	parameters = event_data.parameters
	events = event_data.events
	
	print("Key key loop")
	
	#Subscribe to each invocation event so can declare when invoked
	for key in events:
		var event = events[key]
		if event.is_invocation:
			event.event_running.connect(_declare_invoked)

'''
Disables all parameters and events so they don't interact with
the rest of the game. Allows for them to easily be deleted by
garbage collection.
'''
func _disable_params_and_events():
	if parameters != null:
		#Disable all paremeters
		for param_name in parameters:
			parameters[param_name].disable()
	
	if events != null:
		#Disable all events
		for event_name in events:
			events[event_name].event_state = Event.EventState.INACTIVE

'''
Sends a signal that this card was invoked. Only will occur if
an invocation event on the card is triggered.
'''
func _declare_invoked():
	invoked.emit()

'''
Reloads the viewport for the cardface with new info.
'''
func _reload_cardface():
	viewport.render_target_update_mode = SubViewport.UpdateMode.UPDATE_ONCE
