@abstract
class_name DecisionRequest extends RefCounted

## The internal id of the decision this request is for.
var _decision_id: String
var decision_id: String:
	get(): return _decision_id
	set(val): return

var _actor: Actor

## The prompt to display to an actor, if applicable.
var prompt: String

## Constructor
func _init(id: String, actor: Actor, prompt_str: String):
	_decision_id = id
	_actor = actor
	prompt = prompt_str

func get_actor():
	return _actor
