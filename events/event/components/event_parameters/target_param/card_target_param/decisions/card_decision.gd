class_name CardDecision extends Decision

var options: Array[Card] = []

var selected_cards: Array[int]

func _init(id_str: String, actor: Actor, prompt_str: String, 
options_list: Array[Card]):
	super(id_str, actor, prompt_str)
	options = options_list.duplicate()

func generate_request() -> DecisionRequest:
	# Get a list of default values
	var default: Array[Card] = selected_cards.map(func(val): options[val])
	
	var request = CardDecisionRequest.new(_decision_id, _actor, _prompt, options, default)
	return request

func _make_decision(selection: DecisionSelection):
	var choices = selection.get_selection() as Array[int]
	assert(choices) # Make sure a choice was actually gotten
	if choices:
		selected_cards = choices
		decision_made.emit()
	
