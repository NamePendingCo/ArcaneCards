class_name PlayerCaster extends Caster

#VERY VERY TEMPORARY REMOVE BEFORE LONG
@export var ui: TestingBattleUI

#================================================
# Public methods
#================================================

'''
Has the player make the card selection during casting phase.

Utilizes the UI to make the selection. VERY TEMPORARY UI system,
so all of this should be replaced once we have a more proper functionality.
'''
func make_casting_phase_decisions():
	if ui == null:
		#Choose randomly if no UI is set
		super()
	
	var target_list: Array[String] = []
	
	_casting_selection.update_range()
	
	'''
	Inner lambda to use to compare two cards for sorting the list more easily.
	'''
	var comp_casting_cards = func(card_a: Card, card_b: Card):
		if card_b.location == Card.Location.CASTING_WELL:
			if card_a.location != Card.Location.CASTING_WELL:
				return false
			else:
				return my_casting_well.get_cards_slot(card_a) < \
				my_casting_well.get_cards_slot(card_b)
		return true
	
	#Sort the list such that cards in the casting well are listed first
	_casting_selection.targets_range.sort_custom(comp_casting_cards)
	
	var in_well_indices: Array[int] = []
	
	var hand_counter = 0
	var well_counter = 0
	var prefix: String
	
	#Mark cards as in hand or in the casting well
	for card in _casting_selection.targets_range:
		if card.location == card.Location.HAND:
			hand_counter += 1
			prefix = "H%d" % hand_counter
		else:
			in_well_indices.append(well_counter)
			well_counter += 1
			prefix = "W%d" % well_counter
		
		#Add to target list to be passed to UI
		target_list.append("%s. %s" % [prefix, card.card_data.cardName])
	
	#Creates a decision from the UI
	var decision_finished_signal: Signal = ui.request_decision(
		self, target_list, _casting_selection.num_targets_min, 
		_casting_selection.num_targets_max, "Choose cards to cast", in_well_indices)
	
	#Waits for the decision to be made
	var decision_return = await decision_finished_signal
	
	var new_targets: Array[Card] = []
	
	#loop through list of selections and put them into the casting list selection
	for index in decision_return[1]:
		new_targets.append(_casting_selection.targets_range[index])

	#Sets the actual targets
	_casting_selection.targets = new_targets

#================================================
# Private methods
#================================================

#TODO, actually interface with the selection screen
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
#TODO: Actually interface with current UI
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
