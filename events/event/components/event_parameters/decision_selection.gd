class_name DecisionSelection extends RefCounted

## The internal id of the decision this selection is for.
var _decision_id: String

## The selected value that should be 
var _selected_value: Variant

## Constructor
func _init(id: String, selected_val: Variant):
	_decision_id = id
	_selected_value = selected_val

func get_selection():
	return _selected_value
