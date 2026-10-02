@abstract
class_name DecisionRequest extends RefCounted

## A wrapper a caster passes to a UI or AI to ask for a selection 
## for a decsion.
## 
## Only ever should be created by a decision object. When a decision is
## created, it should create a selection object which can be passed to
## the actor so it can be set in the decision. Every single subclass
## should have a create_selection method that is a wrapper for 
## [method _create_selection] which defines the type of the selection
## values for this decision.

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

## Takes in a variant for the decision and returns a [DecisionSelection] object.
func _create_selection(choice_obj: Variant) -> DecisionSelection:
	return DecisionSelection.new(decision_id, choice_obj)
