@tool
class_name TargetOperationHandler extends Resource

'''
Perform an operation between one or
two different target params. Uses the targets, not their
ranges.
'''

enum SetOperations {
	IDENTITY,
	INVERT_RANGE, #all options from range not in target
	UNION,
	INTERSECTION,
	DIFFERENCE
}
@export
var operation: SetOperations:
	set(val):
		operation = val
		notify_property_list_changed()

@export
var param_a_name: String 

@export
var param_b_name: String

var range: Array = []

var targets_arr_a: Array = []:
	set(val):
		targets_arr_a = val
		update_range_output()

var targets_arr_b: Array = []:
	set(val):
		targets_arr_b = val
		update_range_output()

'''
Sets the arrays to match the given parameters for the operation.
Subscribes the parent operation parameter to the range updates if the
parent is persistent.
Params:
	- parent: the operation TargetParam which is running this function
	- param_a: The first parameter to be used for the operation
	- param_b: optional, the second parameter to be used for operation, if necessary
'''
func set_params(parent: TargetParam, param_a: TargetParam, param_b: TargetParam = null):
	#Set the targets_arr_a to match the targets of a
	targets_arr_a = param_a.targets
	
	#If persistent, should update range when param a updates targets
	if parent.persistent:
		param_a.updated_targets.connect(parent.update_range_output)
	
	match operation:
		#Special case to set param_b to be based on range of a
		SetOperations.INVERT_RANGE:
			targets_arr_b = param_a.targets_range
			#If persistent, should update range when param a updates range
			if parent.persistent:
				param_a.updated_range.connect(parent.update_range_output)
		
		#Handle all cases where B should be used
		SetOperations.UNION, SetOperations.INTERSECTION, SetOperations.DIFFERENCE:
			if param_b != null:
				targets_arr_b = param_b.targets
				#If persistent, should update range when param b updates targets
				if parent.persistent:
					param_b.updated_targets.connect(parent.update_range_output)

'''
Regenerates the output range array based on the existing arrays
such that it can be accessed by the parent.
'''
func update_range_output():
	match operation:
		#Set range to match targets of param A
		SetOperations.IDENTITY:
			range = targets_arr_a.duplicate()
		#in this case, target param b should be the range of a
		SetOperations.INVERT_RANGE:
			range = ToolFuncs.array_difference(\
			targets_arr_b, targets_arr_a)
		#Set range to be the union of targets of A and B
		SetOperations.UNION:
			range = ToolFuncs.array_union(\
			targets_arr_a, targets_arr_b)
		#Set range to be the intersection of targets of A and B
		SetOperations.INTERSECTION:
			range = ToolFuncs.array_intersection(\
			targets_arr_a, targets_arr_b)
		#Set range to be the different between targets of A and B
		SetOperations.DIFFERENCE:
			range = ToolFuncs.array_difference(\
			targets_arr_a, targets_arr_b)


func _validate_property(property: Dictionary) -> void:
	if property.name == "param_b_name":
		_set_property_visibility(property, \
		(operation not in [SetOperations.IDENTITY, SetOperations.INVERT_RANGE]))
'''
Toggles visibility of a property depending on a given condition
'''
func _set_property_visibility(property: Dictionary, condition: bool):
	if condition:
		property.usage |= PROPERTY_USAGE_EDITOR
	else:
		property.usage &= ~PROPERTY_USAGE_EDITOR
