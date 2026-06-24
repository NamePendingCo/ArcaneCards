@abstract
class_name CardTargetParam extends TargetParam

var targets_range: Array[Card]:
	get: return _targets_range
	set(val): _targets_range = val

#The actual chosen targets
var targets: Array[Card]:
	get: return _targets
	set(val): _targets = val
