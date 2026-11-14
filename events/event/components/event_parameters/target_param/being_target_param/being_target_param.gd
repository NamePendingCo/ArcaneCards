@abstract
class_name BeingTargetParam extends TargetParam

var targets_range: Array[Being]:
	get = _get_targets_range, set = _set_targets_range

## The actual chosen targets
var targets: Array[Being]:
	get = _get_targets, set = _set_targets

#================================================
# Public methods
#================================================

func update_value() -> void:
	if not is_chosen:
		targets = targets_range
		return
	
	# If there aren't even enough targets to begin with, take what's there
	if num_targets_min >= targets_range.size():
		targets = targets_range
		return
	
	BeingDecision

#================================================
# Private methods
#================================================

#OVERRIDES
func _get_targets():
	return targets

#OVERRIDES
func _get_targets_range():
	return targets_range

#OVERRIDES
func _set_targets(arr: Array[Being]):
	targets.assign(arr)
	super(arr)

#OVERRIDES
func _set_targets_range(arr: Array[Being]):
	targets_range.assign(arr)
	super(arr)

func _set_actor(val: Actor):
	super(val)
