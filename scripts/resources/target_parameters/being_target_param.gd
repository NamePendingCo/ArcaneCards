@tool
class_name BeingTargetParam extends Resource

@export
var is_chosen_from: bool = true:
	set(val): 
		is_chosen_from = val
		notify_property_list_changed()

#The range of applicable targets
@export
var range: EventEnums.BeingRangeOption:
	set(val): 
		range = val
		notify_property_list_changed()

#number of targets to select from, only shown if actor chooses target
var num_targets_min: int = 1:
	set(val): 
		num_targets_min = max(val, 1)
		if num_targets_max < num_targets_min: num_targets_max = val

#maximum number of targets to choose, if its a range
var num_targets_max: int = 1:
	set(val): num_targets_max = max(val, num_targets_min)

#the actual chosen targets
var targets: Array[Being]

func _validate_property(property: Dictionary) -> void:
	if property.name == "num_targets_min" \
	or property.name == "num_targets_max":
		if is_chosen_from and \
		((range & EventEnums.BeingRangeOption.ALL_OTHERS) != 0):
			property.usage |= PROPERTY_USAGE_EDITOR 
		else:
			property.usage &= ~PROPERTY_USAGE_EDITOR
