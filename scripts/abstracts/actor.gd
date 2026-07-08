@abstract
class_name Actor extends Node3D

'''
An abstract class that is a parent to Beings and Casters. This is just
in case we ever need to make non-being actors who can perform events,
such as weather effects.
'''

'''
Used to allow BeingTargetFilterParams to access the node tree to get group list.
Signal call only.
'''
func _pass_all_beings_to_param(param: BeingTargetFilterParam):
	var list = get_tree().get_nodes_in_group(Constants.GROUP_BEING)
	var being_list: Array[Being] = []
	for item in list:
		being_list.append(item as Being)
	param.update_range_from_list(being_list)

'''
Used to allow CardTargetFilterParams to access the node tree to get group list.
Signal call only.
'''
func _pass_all_cards_to_param(param: CardTargetFilterParam):
	var card_list = get_tree().get_nodes_in_group(Constants.GROUP_Card) as Array[Card]
	param.update_range_from_list(card_list)
