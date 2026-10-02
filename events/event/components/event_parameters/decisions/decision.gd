@abstract
class_name Decision extends RefCounted

## Holds the decision for an actor's choices. 
## 
## Usually created by an [EventParam], which should connect to
## [signal decision_made] once to update its final value accordingly.
## Actors should get a [DecisionRequest] object from [method generate_request]
## and then pass it to whatever makes their decisions (UI, an AI, etc.)
## and then waits until it receives a [DecisionSelection] it can pass
## back to the decision. Once a decision is made, it is locked and
## cannot be remade. 

## Sends the results of the decision back
signal decision_made

## The internal id of the decision being made.
var _decision_id: String

var _actor: Actor

## if true, decision has been made and can't be changed
var _decision_made: bool = false:
	set(val):
		#Only can be set to true
		_decision_made = val if val == true else _decision_made

## The prompt to display to an actor, if applicable.
var _prompt: String

func _init(id_str: String, actor: Actor, prompt_str: String):
	_decision_id = id_str
	_actor = actor
	_prompt = prompt_str

#================================================
# Public methods
#================================================

@abstract
func generate_request() -> DecisionRequest;

## When given a DecisionSelection, sets the selection value to its contents.
func make_decision(selection: DecisionSelection) -> void:
	#Exclude a selection that doesn't match the ID
	if selection.decision_id != _decision_id:
		return
	
	_make_decision(selection)

#================================================
# Private methods
#================================================

## Internal abstract.
## When given a DecisionSelection, sets the selection value to its contents.
@abstract func _make_decision(selection: DecisionSelection) -> void;
