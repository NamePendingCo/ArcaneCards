class_name  BoolDecisionRequest extends DecisionRequest

## The default selection when the decision is presented.
var default: bool

## Constructor
func _init(id: String, actor: Actor, prompt_str: String, 
default_val: bool):
	super(id, actor, prompt_str)
	default = default_val

func create_selection(choice: bool):
	return _create_selection(choice)
