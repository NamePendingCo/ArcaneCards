class_name Card extends Node3D

const COLOR = Enums.SpellColor

#Core signals to denote state change
signal casted
signal activated
signal invoked

#signals to tell the caster to take actions on this card
signal marked_for_discard
signal marked_for_casting(card, slot: int)
signal marked_for_conc_circle(card, slot: int)

signal payment_declared(type) #Eventually set param type with an enum

#signals for notifying state changes
signal left_hand
signal detatched_from_slot

signal reset_event_data #notify if reloaded to reregister

@export
var card_owner: Caster
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
var card_state: Enums.CardState

#when true, card can be dragged around by player. When false, cannot move
#for now, assume always can while in hand or state is null. Probably fix later
var position_locked: bool:
	get: return card_state <= Enums.CardState.HAND
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
	
	card_owner = null
	card_state = Enums.CardState.NULL
	_reset_casting_data()

#================================================
# Public Methods
#================================================

'''
Prepares to have the card's state changed. Sends any relevant signals, as well as
sets the state to the new state
'''
func ready_state_change(new_state: Enums.CardState):
	match card_state:
		Enums.CardState.HAND:
			left_hand.emit(self)
		Enums.CardState.CASTING_WELL, Enums.CardState.CONCENTRATION_CIRCLE:
			detatched_from_slot.emit()
	
	card_state = new_state

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
Should only be called by caster. 
'''
func cast():
	
	casted.emit()

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
Set all events to active.

Finally, run the activation event.
'''
func activate():
	
	for event_name in events:
		var event = events[event_name]
		event.event_state = Event.EventState.ACTIVE
		
	events[Constants.ACTIVATION_KEY].trigger()
	
	#notifies card was activated
	activated.emit()

### Below are functions for sending signals pre-events occuring

'''
Called by other classes to tell the card it should be discarded. Used to signal
to the caster it should be discarded.
'''
func mark_discard():
	marked_for_discard.emit()

'''
Called by other classes to tell the card to be cast. 
Params:
	- slot: the slot the card should be cast to. -1 means first open
'''
func mark_cast(slot: int=-1):
	marked_for_casting.emit(self, slot)

'''
Called by other classes to tell the card to be moved to concentration circle 
Params:
	- slot: the slot the card should be cast to. -1 means first open
'''
func mark_conc_circle(slot: int=-1):
	marked_for_conc_circle.emit(self, slot)

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
	
	#Set up the events in the event_data
	event_data.setup_events(card_owner, self)
	
	parameters = event_data.parameters
	events = event_data.events
	
	#Subscribe to each invocation event so can declare when invoked
	for key in events:
		var event = events[key]
		if event.is_invocation:
			event.event_running.connect(_declare_invoked)
	
	reset_event_data.emit()

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
Sends a signal that this card was invoked.
'''
func _declare_invoked():
	invoked.emit()

'''
Reloads the viewport for the cardface with new info.
'''
func _reload_cardface():
	viewport.render_target_update_mode = SubViewport.UpdateMode.UPDATE_ONCE
