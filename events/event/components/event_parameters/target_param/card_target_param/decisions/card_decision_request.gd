class_name  CardDecisionRequest extends DecisionRequest

## The list of cards to choose from.
var options: Array[Card]

## The default selections when the decision is presented.
var default: Array[Card]

## Constructor
func _init(id: String, actor: Actor, prompt_str: String, 
options_list: Array[Card], default_list: Array[Card]):
	super(id, actor, prompt_str)
	options = options_list.duplicate()
	default = default_list.duplicate()

func create_selection(choices: Array[Card]):
	return _create_selection(choices)
