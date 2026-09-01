class_name Card extends Node3D

const COLOR = Enums.SpellColor
const BASIC_EVENTS: EventData = preload("res://system_events/basic_card_functions.tres")

#Core signals to denote state change
signal changed_location(new_state, old_state)
signal activated
signal invoked

signal marked_to_destroy

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

#THIS SHOULD BE USED *ONLY* TO COMPARE OWNERS. NEVER CALL THIS
var card_caster: Caster:
	set(val):
		card_caster = val
		basic_events.set_actor(val)
		events_wrapper.set_actor(val)

@export var card_data: CardData:
	set(value):
		#set the new data as the data for this card
		card_data = value
		
		print("new_card: %s" % card_data.cardName)
		
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

#A wrapper for all universal card events
var basic_events: EventsWrapper

#A wrapper for all event and parameter info unique to this card
var events_wrapper: EventsWrapper = null:
	set = _set_events

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
	
	basic_events = BASIC_EVENTS.get_new_events_wrapper(card_caster, self)

#================================================
# Public Methods
#================================================

'''
Has the card object destroy itself.
'''
func self_destruct():
	marked_to_destroy.emit()
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
	await tween.finished

'''
Increases the casting stage. If it is ready to activate,
activate the card.
'''
func progress_casting(progress_increment: int):
	_rounds_spent_casting += progress_increment
	
	var progress_total = _rounds_spent_casting + _quicken_amount
	var wait_total = card_data.tier + _delay_amount
	
	print("Casting for card %s progressed to %d" % [card_data.cardName, progress_total])
	
	if progress_total >= wait_total:
		print("Activating!")
		activate()

'''
In play to true. Set all events to active. Then run the activation event. 
Finally move to conc circle if concentration card.
'''
func activate():
	_in_play = true
	
	var events = events_wrapper.event_launchers
	
	for event_name in events:
		var event_launcher = events[event_name]
		event_launcher.launcher_state = EventLauncher.EventLauncherState.ACTIVE
		
	events[CardEventData.ACTIVATION_KEY].trigger()
	
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
	
	var events = events_wrapper.event_launchers
	
	for event_name in events:
		var event_launcher = events[event_name]
		event_launcher.launcher_state = EventLauncher.EventLauncherState.INACTIVE

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
	events_wrapper = card_data.event_data.get_new_events_wrapper(card_caster, self)

func _set_events(wrapper: EventsWrapper):
	events_wrapper = wrapper
	
	var launchers: Array[EventLauncher] = wrapper.event_launchers.values()
	var parameters: Array[EventParam] = wrapper.parameters.values()
	
	for launcher in launchers:
		add_child(launcher)
		launcher.event_triggered.connect(_on_event_triggered)
	
	for param in parameters:
		add_child(param)

#func _create_discard_self_effect():
	#var target_card_self: CardTargetFilterParam = CardTargetFilterParam.new()
	#target_card_self.targets = [self]
	#var discard_effect: DiscardEffect = DiscardEffect.new()
	#discard_effect.targets_param = target_card_self
	#
	#return discard_effect

'''
Run when an event is created by an event launcher when triggered.
'''
func _on_event_triggered(event: Event):
	#Should only handle an event getting run once
	event.event_running.connect(_on_event_run, CONNECT_ONE_SHOT)

'''
Run when an event attached to this card signals it was run.
'''
func _on_event_run(isInvocation: bool):
	if isInvocation:
		invoked.emit()

'''
Reloads the viewport for the cardface with new info.
'''
func _reload_cardface():
	viewport.render_target_update_mode = SubViewport.UpdateMode.UPDATE_ONCE
