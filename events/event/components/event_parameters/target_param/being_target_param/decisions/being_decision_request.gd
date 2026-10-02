class_name  BeingDecisionRequest extends DecisionRequest

## The list of beings to choose from.
var options: Array[Being]

## The default selections when the decision is presented.
var default: Array[Being]

## Constructor
func _init(id: String, actor: Actor, prompt_str: String, 
options_list: Array[Being], default_list: Array[Being]):
	super(id, actor, prompt_str)
	options = options_list.duplicate()
	default = default_list.duplicate()

func create_selection(choices: Array[Being]):
	return DecisionSelection.new(decision_id, choices)
