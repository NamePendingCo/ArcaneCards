@tool
class_name BeingTargetFilterParam extends BeingTargetParam

#The range of applicable targets
@export
var range_option: EventEnums.BeingRangeOption:
	set(val): 
		range_option = val
		notify_property_list_changed()

#TODO override
func update_range():
	pass

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
