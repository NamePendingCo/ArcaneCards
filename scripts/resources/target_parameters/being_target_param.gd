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
var num_targets: int = 1:
	set(val): num_targets = max(val, 1)

#the actual chosen targets
var targets: Array[Being]

func _validate_property(property: Dictionary) -> void:
	if property.name == "num_targets":
		if is_chosen_from and \
		((range & EventEnums.BeingRangeOption.SELF) != EventEnums.BeingRangeOption.SELF):
			property.usage ^= PROPERTY_USAGE_EDITOR
		else:
			property.usage &= ~PROPERTY_USAGE_EDITOR
