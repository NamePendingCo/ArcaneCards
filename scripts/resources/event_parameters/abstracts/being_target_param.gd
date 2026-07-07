@abstract
class_name BeingTargetParam extends TargetParam

var targets_range: Array[Being]:
	get: return targets_range
	set(val): 
		targets_range = val
		_targets_range = val

#The actual chosen targets
var targets: Array[Being]:
	get: return targets
	set(val): 
		targets = val
		_targets = val
