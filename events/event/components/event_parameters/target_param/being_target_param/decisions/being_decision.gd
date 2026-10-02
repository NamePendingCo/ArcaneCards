class_name BeingDecision extends Decision

var options: Array[Being] = []

var selected_beings: Array[int]

func _init(id_str: String, actor: Actor, prompt_str: String, 
options_list: Array[Being]):
	super(id_str, actor, prompt_str)
	options = options_list.duplicate()

func generate_request() -> DecisionRequest:
	# Get a list of default values
	var default: Array[Being] = selected_beings.map(func(val): options[val])
	
	var request = BeingDecisionRequest.new(_decision_id, _actor, _prompt, options, default)
	return request

func _make_decision(selection: DecisionSelection):
	var choices = selection.get_selection() as Array[int]
	assert(choices) # Make sure a choice was actually gotten
	if choices:
		selected_beings = choices
		decision_made.emit()
	
