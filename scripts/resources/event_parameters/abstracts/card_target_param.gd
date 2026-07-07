@abstract
class_name CardTargetParam extends TargetParam

var targets_range: Array[Card]:
	get: return targets_range
	set(val):
		targets_range = val
		_targets_range = val

#The actual chosen targets
var targets: Array[Card]:
	get: return targets
	set(val): 
		targets = val
		_targets = val
