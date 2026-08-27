@abstract
class_name Actor extends Node3D

'''
An abstract class that is a parent to Beings and Casters. This is just
in case we ever need to make non-being actors who can perform events,
such as weather effects.
'''

'''
Used to allow CardTargetFilterParams to access the node tree to get group list.
Signal call only.
'''
func _pass_all_cards_to_param(param: CardTargetFilterParam):
	var card_list = get_tree().get_nodes_in_group(Constants.GROUP_CARD) as Array[Card]
	
	var card_array: Array[Card] = []
	
	for card in card_list:
		card_array.append(card as Card)
	
	param.update_range_from_list(card_array)

#================================================
# Private methods
#================================================

@abstract
func _choose_being_from_range(param: BeingTargetParam)

@abstract
func _choose_card_from_range(param: CardTargetParam)
