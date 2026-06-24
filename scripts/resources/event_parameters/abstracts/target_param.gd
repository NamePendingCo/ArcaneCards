@abstract
class_name TargetParam extends EventParam

signal updated_range #updated the range of potential targets
signal updated_targets #updated the selected targets

#All possible values that can be chosen as targets
var _targets_range: Array:
	get = _get_targets_range, set = _set_targets_range

#Actual chosen targets. Should be a subset of targets_range
var _targets: Array:
	get = _get_targets, set = _set_targets
	
#Whether the target is chosen by the player
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

#Whether or not to automatically refresh the target selection
var persistent: bool = false

'''
Updates the range of potential targets for the parameter,
based on whatever mechanism is expected for the param.
'''
@abstract
func update_range()

#Setters and getters for range and target variables
func _get_targets_range():
	return _targets_range

func _set_targets_range(arr: Array):
	_targets_range = arr
	updated_range.emit() #notify of update

func _get_targets():
	return _targets

func _set_targets(arr: Array):
	_targets = arr
	updated_targets.emit() #notify of update
