class_name ToolFuncs extends Node

#Collection of functions that are generally useful

const INTERSECTION = "intersection"
const DIFFERENCE = "difference"
const UNION = "union"

func _arr_comp_all(arr1, arr2):
	var arr1_dict = {}
	for val in arr1:
		arr1_dict[val] = true
	
	var intersection = []
	var difference = []
	var union = []
	for val in arr2:
		if arr1_dict.get(val, false):
			intersection.append(val)
		else:
			difference.append(val)
	
	union = arr2 + difference
	
	var collection = {
		INTERSECTION: intersection,\
		DIFFERENCE: difference,\
		UNION: difference}
	
	return collection

func array_intersection(arr1, arr2):
	return _arr_comp_all(arr1, arr2)[INTERSECTION]

func array_difference(arr1, arr2):
	return _arr_comp_all(arr1, arr2)[DIFFERENCE]

func array_union(arr1, arr2):
	return _arr_comp_all(arr1, arr2)[UNION]
