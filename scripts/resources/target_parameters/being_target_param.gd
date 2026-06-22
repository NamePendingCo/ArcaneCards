@tool
class_name BeingTargetParam extends TargetParam

#The range of applicable targets
@export
var range: EventEnums.BeingRangeOption:
	set(val): 
		range = val
		notify_property_list_changed()

@export_category("Selection")
#Whether the range is chosen from by the caster
@export
var is_chosen: bool = false:
	set(val): 
		is_chosen = val
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
var targets: Array[Being]:
	set(val):
		targets = val
		updated_targets.emit() #notify of update

#TODO
func get_targets(actor):
	pass

func _validate_property(property: Dictionary) -> void:
	if property.name == "is_chosen":
		# Chosen only shown if range isn't null or self
		set_property_visibility(property,\
		(range & EventEnums.BeingRangeOption.ALL_OTHERS) != 0)
	elif property.name == "num_targets_min" \
	or property.name == "num_targets_max":
		#target numbers only shown if is chosen is relevant
		set_property_visibility(property,\
		(is_chosen  and (range & EventEnums.BeingRangeOption.ALL_OTHERS) != 0))
