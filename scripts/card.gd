class_name Card extends Node3D

signal marked_for_discard
signal marked_for_casting(card, slot: int)
signal marked_for_conc_circle(card, slot: int)

signal left_hand
signal detatched_from_slot

@export
var card_owner: Caster
#THIS SHOULD BE USED *ONLY* TO COMPARE OWNERS. NEVER CALL THIS

@export var card_data: CardData:
	set(value):
		#Get the cardface object to modify
		var spell_face = $"Cardfront/SubViewport/CardFace"
		var viewport = $"Cardfront/SubViewport"
		
		#set the new data as the data for this card
		card_data = value
		
		#set name in cardface
		spell_face.get_node("Name").text = card_data.cardName
		
		#set tier and activation cost on cardface
		var ac = card_data.activation_cost
		match card_data.tier:
			1:
				spell_face.get_node("Tier").text = 'I'
				spell_face.get_node("ActivationCost").text = str(ac[0])
			2:
				spell_face.get_node("Tier").text = 'II'
				spell_face.get_node("ActivationCost").text = str(ac[0]) + '/' + str(ac[1])
			3:
				spell_face.get_node("Tier").text = 'III'
				spell_face.get_node("ActivationCost").text = str(ac[0]) + '/' + str(ac[1]) + '/' + str(ac[2])
				
		#set upkeep cost on cardface
		spell_face.get_node("UpkeepCost").text = str(card_data.upkeep_cost)
		
		#creates the overview string and sets it on cardface
		spell_face.get_node("Overview").text = '-- ' + Enums.colorString(card_data.color) + ' (' + Enums.subdomainString(card_data.subdomain) + ') -- ' + Enums.typeString(card_data.type) + ' --'
		
		#reset the viewport so it reloads with the new info
		viewport.render_target_update_mode = SubViewport.UpdateMode.UPDATE_ONCE

var card_state: Enums.CardState

var roundsSpentCasting: int: 
	set(val): 
		roundsSpentCasting = max(val, 0)
var delayAmount: int:
	set(val): 
			delayAmount = max(val, 0)
var quickenAmount: int:
	set(val): 
			quickenAmount = max(val, 0)

#when true, card can be dragged around by player. When false, cannot move
#for now, assume always can while in hand or state is null. Probably fix later
var position_locked: bool:
	get: return card_state <= Enums.CardState.IN_HAND
	set(val): pass

func _ready():
	card_owner = null
	card_state = Enums.CardState.NULL
	_reset_casting_data()
	
func _reset_casting_data():
	roundsSpentCasting = 0
	delayAmount = 0
	quickenAmount = 0

'''
Prepares to have the card's state changed. Sends any relevant signals, as well as
sets the state to the new state
'''
func ready_state_change(new_state: Enums.CardState):
	match card_state:
		Enums.CardState.IN_HAND:
			left_hand.emit(self)
		Enums.CardState.CASTING, Enums.CardState.IN_CIRCLE:
			detatched_from_slot.emit()
	
	card_state = new_state
	

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
