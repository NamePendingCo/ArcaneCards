@tool
@abstract
class_name TargetResource extends EventParamResource

#Whether or not to automatically refresh the target selection
@export
var persistent: bool = false

#number of targets to select from, only shown if actor chooses target
@export
var num_targets_min: int = 1:
	set(val): 
		num_targets_min = max(val, 0)
		if num_targets_max < num_targets_min: num_targets_max = val

#maximum number of targets to choose, if its a range
@export
var num_targets_max: int = 1:
	set(val): num_targets_max = max(val, num_targets_min)

#================================================
# Public methods
#================================================
