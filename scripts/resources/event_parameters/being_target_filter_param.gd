@tool
class_name BeingTargetFilterParam extends BeingTargetParam

signal requested_beings_list

#The range of applicable targets
@export
var range_option: EventEnums.BeingRangeOption:
	set(val): 
		range_option = val
		notify_property_list_changed()

@export
var being_filter: BeingFilter

'''
When passed a list of beings, updates from these
'''
func update_range_from_list(all_beings: Array[Being]):
	targets_range.clear()
	targets_range.append(all_beings.filter(_check_being))

'''
Sends a signal which should tell the actor to update its range using
update_range_from_list
'''
func update_range():
	requested_beings_list.emit()

'''
Filter function used to see if a specific being matches the parameter filters.
'''
func _check_being(being: Being) -> bool:
	return being_filter.check_being(being)

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
