class_name TargetOperationHandler extends RefCounted

'''
Perform an operation between one or
two different target params. Uses the targets, not their
ranges.
'''

enum SetOperation {
	IDENTITY,
	INVERT_RANGE, #all options from range not in target
	UNION,
	INTERSECTION,
	DIFFERENCE
}

var operation: SetOperation

var range: Array = []

#The first list of targets to be tracking
var targets_arr_a: Array = []:
	set(val):
		targets_arr_a = val
		update_range_output()

#The second list of targets to be tracking
var targets_arr_b: Array = []:
	set(val):
		targets_arr_b = val
		update_range_output()

func _init(parent: TargetParam, param_a: TargetParam, param_b: TargetParam = null):
	set_params(parent, param_a, param_b)

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
		SetOperation.INVERT_RANGE:
			targets_arr_b = param_a.targets_range
			#If persistent, should update range when param a updates range
			if parent.persistent:
				param_a.updated_range.connect(parent.update_range_output)
		
		#Handle all cases where B should be used
		SetOperation.UNION, SetOperation.INTERSECTION, SetOperation.DIFFERENCE:
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
		SetOperation.IDENTITY:
			range = targets_arr_a.duplicate()
		#in this case, target param b should be the range of a
		SetOperation.INVERT_RANGE:
			range = ToolFuncs.array_difference(\
			targets_arr_b, targets_arr_a)
		#Set range to be the union of targets of A and B
		SetOperation.UNION:
			range = ToolFuncs.array_union(\
			targets_arr_a, targets_arr_b)
		#Set range to be the intersection of targets of A and B
		SetOperation.INTERSECTION:
			range = ToolFuncs.array_intersection(\
			targets_arr_a, targets_arr_b)
		#Set range to be the different between targets of A and B
		SetOperation.DIFFERENCE:
			range = ToolFuncs.array_difference(\
			targets_arr_a, targets_arr_b)
