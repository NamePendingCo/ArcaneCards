@tool
class_name BeingTargetFilterParam extends BeingTargetParam

#The range of applicable targets
@export
var range_option: EventEnums.BeingRangeOption:
	set(val): 
		range_option = val
		notify_property_list_changed()

@export
var being_filter: BeingFilter

'''
Gets the list of targets
'''
func update_range():
	var all_beings: Array[Being] = get_tree().get_nodes_in_group(Constants.GROUP_BEING).map(func(a): a as Being)
	
	if _actor != null and is_instance_of(_actor, Being):
		match range_option:
			EventEnums.BeingRangeOption.SELF: all_beings = [_actor]
			EventEnums.BeingRangeOption.ALL_OTHERS: all_beings.erase(_actor)
	
	targets_range = all_beings.filter(_check_being)

'''
Filter function used to see if a specific being matches the parameter filters.
'''
func _check_being(being: Being) -> bool:
	if (range_option ^ EventEnums.BeingRangeOption.SELF == 0) \
	and (being != _actor):
		return false
	elif (range_option ^ EventEnums.BeingRangeOption.ALL_OTHERS == 0) \
	and (being == _actor):
		return false
	if being_filter != null:
		return being_filter.check_being(being)
	else:
		return true

func _validate_property(property: Dictionary) -> void:
	if property.name == "is_chosen":
		# Chosen only shown if range isn't null or self
		_set_property_visibility(property,\
		(range_option & EventEnums.BeingRangeOption.ALL_OTHERS) != 0)
	elif property.name == "num_targets_min" \
	or property.name == "num_targets_max":
		#target numbers only shown if is chosen is relevant
		_set_property_visibility(property,\
		(is_chosen  and (range_option & EventEnums.BeingRangeOption.ALL_OTHERS) != 0))
	elif property.name == "persistent":
		_set_property_visibility(property, true)
