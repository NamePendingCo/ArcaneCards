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
var num_targets_min: int:
	set(val): 
		num_targets_min = max(val, 0)
		if num_targets_max < num_targets_min: num_targets_max = val

#maximum number of targets to choose, if its a range
var num_targets_max: int:
	set(val): num_targets_max = max(val, num_targets_min)

#Whether or not to automatically refresh the target range
var persistent: bool

func _init(my_actor: Actor, my_card: Card, chosen: bool, 
targets_min: int=1, targets_max: int=1, persist=false):
	super(my_actor, my_card, chosen)
	num_targets_min = targets_min
	num_targets_max = targets_max
	persistent = persist

#================================================
# Public methods
#================================================

'''
Updates the range of potential targets for the parameter,
based on whatever mechanism is expected for the param.
'''
func update_range():
	if not is_chosen:
		_targets = _targets_range
	#print("\nRange update for: %s" % self)
	#print("\tRange: %s " % str(_targets_range))
	#print("\ttargets: %s" % str(_targets))

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
@abstract
func _get_targets_range()

'''
Designed to be overriden.
'''
func _set_targets_range(_arr: Array[Variant]):
	updated_range.emit() #notify of update

@abstract
func _get_targets()

'''
Designed to be overriden.
'''
func _set_targets(_arr: Array[Variant]):
	updated_targets.emit() #notify of update

'''
Removes an item from both lists. Mainly useful to connect with object's
self destruct signal to remove references to it.
'''
func _remove_from_lists(item: Variant):
	_targets_range.erase(item)
	_targets.erase(item)
