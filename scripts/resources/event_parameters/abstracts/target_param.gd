@abstract
class_name TargetParam extends EventParam

signal updated_range #updated the range of potential targets
signal updated_targets #updated the selected targets

#All possible values that can be chosen as targets
var _targets_range: Array[Variant]:
	get = _get_targets_range, set = _set_targets_range

#Actual chosen targets. Should be a subset of targets_range
var _targets: Array[Variant]:
	get = _get_targets, set = _set_targets

#number of targets to select from, only shown if actor chooses target
var num_targets_min: int = 1:
	set(val): 
		num_targets_min = max(val, 0)
		if num_targets_max < num_targets_min: num_targets_max = val

#maximum number of targets to choose, if its a range
var num_targets_max: int = 1:
	set(val): num_targets_max = max(val, num_targets_min)

#Whether or not to automatically refresh the target selection
var persistent: bool = false

#================================================
# Public methods
#================================================

'''
Updates the range of potential targets for the parameter,
based on whatever mechanism is expected for the param.
'''
@abstract
func update_range()

'''
Overrides function. Calls super, then clears the targets list.
'''
func disable():
	super()
	_targets.clear()

#================================================
# Private methods
#================================================

#Setters and getters for range and target variables
func _get_targets_range():
	return _targets_range

func _set_targets_range(arr: Array[Variant]):
	_targets_range.clear()
	_targets_range.append_array(arr)
	updated_range.emit() #notify of update

func _get_targets():
	return _targets

func _set_targets(arr: Array[Variant]):
	_targets.clear()
	_targets.append_array(arr)
	updated_targets.emit() #notify of update

func _remove_from_lists(item: Variant):
	print("Removing %s" % item)
	_targets_range.erase(item)
	print(_targets_range)
	_targets.erase(item)
	print(_targets)
