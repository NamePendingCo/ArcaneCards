class_name TestingBattleUI extends CanvasLayer

@onready var start_button: Button = $StartButton

@onready var selection_wrapper: GridContainer = $Selection
@onready var options_list: UIOptionsList = $Selection/OptionsList
@onready var selection_prompt: Label = $Selection/SelectionPrompt
@onready var enter_button: Button = $Selection/Submit

@export var battle_manager: BattleManager

@export var acting_player: PlayerCaster:
	set = set_acting_player

var active_decision: CasterDecision:
	set = _set_active_decision

#List of every decision by each player
var _decisions: Dictionary[PlayerCaster, Array]

# Called when the node enters the scene tree for the first time.
func _ready():
	start_button.pressed.connect(_start_game)
	_decisions = {}
	enter_button.pressed.connect(submit_decision)

#================================================
# Public methods
#================================================

'''
Registers when a caster wants to be able to make a new decision,
then creates one and adds it to the dictionary.
Params:
	- caster: the caster requesting the decision
	- options: list of options to be displayed to player
Returns:
	- the decision's decision_made signal
'''
func request_decision(caster: Caster, options: Array[String],
	min_selections: int = 1, max_selections: int = Constants.INT_MAX,
	prompt: String = "", preselected: Array[int] = []) -> Signal:
	var new_decision: CasterDecision = CasterDecision.new(
		caster, options, min_selections, max_selections, prompt, preselected)
	
	#Add decision to the list
	_decisions.get_or_add(caster, []).append(new_decision)
	
	if caster == acting_player:
		get_next_decision()
	
	return new_decision.decision_made #returns the signal so caster can wait for it

'''
Set whether or not the options list should be visible, allowing the player
to make selections.
'''
func set_decision_mode(is_decision_time: bool):
	if selection_wrapper != null:
		selection_wrapper.visible = is_decision_time

'''
Sets the current acting player for the UI.
'''
func set_acting_player(caster: PlayerCaster):
	acting_player = caster
	_decisions.get_or_add(acting_player, [])
	get_next_decision()

func get_next_decision():
	if _decisions[acting_player].size() > 0:
		set_decision_mode(true)
		active_decision = _decisions[acting_player][0]
	else:
		set_decision_mode(false)

'''
Submits current decision, if allowed
'''
func submit_decision():
	if active_decision.selections.size() >= active_decision.min_selections:
		active_decision.make_decision()
		
		options_list.clean_up()
		#reset the current decision
		active_decision = null
		_decisions[acting_player].pop_front()
		get_next_decision()
	else:
		var text = enter_button.text
		enter_button.text = "Too few items selected"
		enter_button.disabled = true
		await get_tree().create_timer(0.05).timeout
		enter_button.text = text
		enter_button.disabled = false

#================================================
# Private methods
#================================================

func _start_game():
	if battle_manager != null:
		start_button.hide()
		battle_manager.startMatch()
	else:
		print("No battle manager found.")

func _set_active_decision(decision: CasterDecision):
	if active_decision != null:
		options_list.item_updated.disconnect(active_decision._handle_toggled_selection)
	
	active_decision = decision
	
	if active_decision == null:
		return
		
	options_list.item_updated.connect(decision._handle_toggled_selection)
	selection_prompt.text = decision.prompt
	
	_set_item_list_items(decision)

func _set_item_list_items(decision: CasterDecision):
	options_list.clean_up()
	options_list.max_selections = decision.max_selections
	
	for item in decision.options:
		options_list.add_item(item)
	
	options_list.append_selected(decision.selections)

'''Class that allows the UI to track multiple caster decisions at once, 
and queue them up as necessary.
'''
class CasterDecision:
	
	signal decision_made
	
	var caster: Caster
	
	var max_selections: int
	var min_selections: int
	
	#the choices the caster can make
	var options: Array[String]
	var selections: Array[int]
	var prompt: String
	
	func _init(deciding_caster: Caster, options_list: Array[String], 
		min_choices: int = 1, max_choices: int = Constants.INT_MAX,
		prompt_input: String = "", preselected: Array[int] = []):
		caster = deciding_caster
		options = options_list
		selections = preselected
		
		prompt = prompt_input
		max_selections = max_choices
		min_selections = min_choices
		
		print("Created decision %s for %s for %d-%d choices with options %s" % 
		[prompt_input, caster, min_choices, max_choices, options_list])
	
	'''
	Makes the final decision for the caster decision
	Params:
		selections: a list of indices from the options that were chosen
	'''
	func make_decision():
		decision_made.emit(options, selections)
	
	func _handle_toggled_selection(choice: int, selected: bool):
		if selected:
			_add_selection(choice)
		else:
			_remove_selection(choice)
	
	func _add_selection(choice: int):
		if choice not in selections:
			selections.append(choice)
	
	func _remove_selection(choice: int):
		selections.erase(choice)
