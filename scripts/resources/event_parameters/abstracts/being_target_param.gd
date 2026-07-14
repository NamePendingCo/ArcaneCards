@abstract
class_name BeingTargetParam extends TargetParam

var targets_range: Array[Being]:
	get = _get_targets_range, set = _set_targets_range

#The actual chosen targets
var targets: Array[Being]:
	get = _get_targets, set = _set_targets

func _get_targets():
	return targets

func _get_targets_range():
	return targets_range

func _set_targets(arr: Array[Being]):
	targets.assign(arr)
	super(arr)

func _set_targets_range(arr: Array[Being]):
	targets_range.assign(arr)
	super(arr)
