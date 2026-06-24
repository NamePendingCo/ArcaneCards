@abstract
class_name BeingTargetParam extends TargetParam

var targets_range: Array[Being]:
	get: return _targets_range
	set(val): _targets_range = val

#The actual chosen targets
var targets: Array[Being]:
	get: return _targets
	set(val): _targets = val
