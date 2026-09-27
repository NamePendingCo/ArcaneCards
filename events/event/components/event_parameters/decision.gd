@abstract
class_name Decision extends RefCounted

## Sends the results of the decision back
signal decision_made

## The internal id of the decision being made.
var _decision_id: String

## if true, decision has been made and can't be changed
var _decision_made: bool = false:
	set(val):
		#Only can be set to true
		_decision_made = val if val == true else _decision_made

## The prompt to display to an actor, if applicable.
var _prompt: String

func _init(id_str: String, prompt_str: String):
	_decision_id = id_str
	_prompt = prompt_str

@abstract
func generate_request() -> DecisionRequest;

## When given a DecisionSelection, sets the selection value to its contents.
@abstract func make_decision(selection: DecisionSelection)
	
