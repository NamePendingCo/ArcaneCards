class_name PlayerCaster extends Caster

#VERY VERY TEMPORARY REMOVE BEFORE LONG
@export var ui: TestingBattleUI

#================================================
# Public methods
#================================================

func make_casting_phase_decisions():
	var target_list: Array[String] = []
	
	for card in _casting_selection.targets_range:
		target_list.append(card.card_data.cardName)
	
	var decision_finished_signal: Signal = ui.request_decision(self, target_list)
	
	var decision_return = await decision_finished_signal
	
	#loop through list of selections and put them into the casting list selection
	for index in decision_return[1]:
		_casting_selection.targets.append(_casting_selection.targets_range[index])

#================================================
# Private methods
#================================================

func _chose_being_from_menu(choice_indices: PackedInt32Array, param: BeingTargetParam):
	var choices: Array[Being] = []
	for index in choice_indices:
		choices.append(param.targets_range[index])
	
	param.targets = choices
	

'''
Overrides.
'''
func _choose_being_from_range(param: BeingTargetParam):
	print("Choosing being")
	#Just copy if the range isn't big enough
	if param.targets_range.size() <= param.num_targets_min:
		param.targets = param.targets_range.duplicate()
		return
	
	var being_names = []
	
	for being: Being in param.targets_range:
		being_names.append(being.name)
	
	ui.set_item_list_items(being_names)
	
	var selections: PackedInt32Array = await ui.selection_made
	
	var targets: Array[Being] = []
	
	for selection in selections:
		targets.append(param.targets_range[selection])
	
	param.targets = targets

'''
Overrides.
'''
func _choose_card_from_range(param: CardTargetParam):
	#Just copy if the range isn't big enough
	if param.targets_range.size() <= param.num_targets_min:
		param.targets = param.targets_range.duplicate()
		return
	
	var card_names = []
	
	for card: Card in param.targets_range:
		card_names.append(card.card_data.cardName)
	
	ui.set_item_list_items(card_names)
	
	var selections: PackedInt32Array = await ui.selection_made
	
	var targets: Array[Card] = []
	
	for selection in selections:
		targets.append(param.targets_range[selection])
	
	param.targets = targets

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
