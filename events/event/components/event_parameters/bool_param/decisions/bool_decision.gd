class_name BoolDecision extends Decision

var selected_val: bool

func _init(id_str: String, actor: Actor, prompt_str: String):
	super(id_str, actor, prompt_str)

func generate_request() -> DecisionRequest:
	# Get a list of default values
	var default: bool = false
	
	var request = BoolDecisionRequest.new(_decision_id, _actor, _prompt, default)
	return request

func _make_decision(selection: DecisionSelection):
	var choice = selection.get_selection() as bool
	assert(choice) # Make sure a choice was actually gotten
	if choice:
		selected_val = choice
		decision_made.emit()
	
