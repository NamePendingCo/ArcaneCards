class_name  EnumDecisionRequest extends DecisionRequest

## The list of enums to choose from.
var options: Array[String]

## The default selections when the decision is presented.
var default: int

## Constructor
func _init(id: String, actor: Actor, prompt_str: String, 
options_list: Array[String], default_val: int):
	super(id, actor, prompt_str)
	options = options_list.duplicate()
	default = default_val

func create_selection(choice: int):
	return _create_selection(choice)
