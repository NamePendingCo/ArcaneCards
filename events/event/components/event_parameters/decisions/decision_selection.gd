class_name DecisionSelection extends RefCounted

## A wrapper that is passed to a [Decision] to set its value.
## 
## These should only be created by [DecisionRequest] instances.
## They don't require subclasses, instead simply carrying a single
## Variant value.

## The internal id of the decision this selection is for.
var _decision_id: String
var decision_id: String:
	get(): return _decision_id
	set(val): return

## The selected value that should be 
var _selected_value: Variant

## Constructor
func _init(id: String, selected_val: Variant):
	_decision_id = id
	_selected_value = selected_val

## Gets the value for the selection.
func get_selection():
	return _selected_value
