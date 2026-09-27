class_name DecisionRequest extends RefCounted

## The internal id of the decision this request is for.
var _decision_id: String

## The prompt to display to an actor, if applicable.
var prompt: String

## Constructor
func _init(id: String, selected_val: Variant):
	_decision_id = id
