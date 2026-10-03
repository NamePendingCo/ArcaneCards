class_name EnumDecision extends Decision

var options: Array[String] = []

var selected_enum_val: int

func _init(id_str: String, actor: Actor, prompt_str: String, 
options_list: Array[String]):
	super(id_str, actor, prompt_str)
	options = options_list.duplicate()

func generate_request() -> DecisionRequest:
	# Get a list of default values
	var default: int = 0
	
	var request = EnumDecisionRequest.new(_decision_id, _actor, _prompt, options, default)
	return request

func _make_decision(selection: DecisionSelection):
	var choice = selection.get_selection() as int
	assert(choice) # Make sure a choice was actually gotten
	if choice:
		selected_enum_val = choice
		decision_made.emit()
	
