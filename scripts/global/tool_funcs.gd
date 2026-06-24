class_name ToolFuncs extends Node

#Collection of functions that are generally useful

const INTERSECTION = "intersection"
const DIFFERENCE = "difference"
const UNION = "union"

static func _arr_comp_all(arr1, arr2):
	var arr2_dict = {}
	for val in arr2:
		arr2_dict[val] = true
		
	var intersection = []
	var difference = []
	var union = []
	for val in arr1:
		if arr2_dict.get(val, false):
			intersection.append(val)
		else:
			difference.append(val)
	
	union = arr1 + difference
	
	var collection = {
		INTERSECTION: intersection,\
		DIFFERENCE: difference,\
		UNION: union}
	
	return collection

static func array_intersection(arr1, arr2):
	return _arr_comp_all(arr1, arr2)[INTERSECTION]

static func array_difference(arr1, arr2):
	return _arr_comp_all(arr1, arr2)[DIFFERENCE]

static func array_union(arr1, arr2):
	return _arr_comp_all(arr1, arr2)[UNION]
