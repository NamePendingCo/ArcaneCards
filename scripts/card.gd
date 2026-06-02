class_name Card extends Node3D

var card_owner: Caster

var card_state: Enums.CardState

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

func _ready():
	card_owner = null
	card_state = Enums.CardState.NULL

#TODO: Add flipping support here perhaps?
'''
Runs a tween to move the card to a new location
Params:
	- new_pos: the new location for the card
'''
func animate_move_card(new_pos: Vector3):
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", new_pos, 0.2)

#TODO
'''
Moves card to owner's discard pile. On success, return true. If no owner, returns false.
'''
func discard():
	pass
