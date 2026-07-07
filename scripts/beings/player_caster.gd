class_name PlayerCaster extends Caster


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

#================================================
# Public methods
#================================================

#================================================
# Private methods
#================================================

func _choose_being_from_range(param: BeingTargetParam):
	#Just copy if the range isn't big enough
	if param.targets_range.size() <= param.num_targets_min:
		param.targets = param.targets_range.duplicate()
		return

func _choose_card_from_range(param: CardTargetParam):
	#Just copy if the range isn't big enough
	if param.targets_range.size() <= param.num_targets_min:
		param.targets = param.targets_range.duplicate()
		return

#TODO Remove this in place of actual input action
# This is not a permanent function, it's merely to test things out
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
		var grabbed_card = my_casting_well.get_first_card_in_array() 
		if grabbed_card != null:
			move_to_conc_circle_card(grabbed_card, -1)
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
		print("Returned from well", true	)
		print("Hand: " + my_hand.list_cards_in_hand())
	elif event.is_action("debug_discard", true):
		if my_hand.hand.size() > 0:
			discard_card(my_hand.hand[0])
			print("Discarded card")
			print("discard: " + str(my_discard.stack))
	elif event.is_action("debug_undiscard", true):
		if my_discard.size > 0:
			move_card_from_discard_pile(0)
			print("Reclaimed discarded card")
			print("discard: " + str(my_discard.stack))
