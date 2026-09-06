@abstract
class_name BeingTargetParam extends TargetParam

var targets_range: Array[Being]:
	get = _get_targets_range, set = _set_targets_range

#The actual chosen targets
var targets: Array[Being]:
	get = _get_targets, set = _set_targets

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
	if actor:
		selection_requested.connect(actor._choose_being_from_range)
