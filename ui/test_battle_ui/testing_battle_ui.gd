class_name TestingBattleUI extends CanvasLayer

'''
Test UI used for running battle simulation. Not at all a final product.
'''

@onready var start_button: Button = $StartButton

@onready var selection_wrapper: GridContainer = $Selection
@onready var options_list: UIOptionsList = $Selection/OptionsList
@onready var selection_prompt: Label = $Selection/SelectionPrompt
@onready var enter_button: Button = $Selection/Submit

# the battle manager for the game
@export var battle_manager: BattleManager

# The current player whose stuff is being interacted with
@export var acting_player: PlayerCaster:
	set = set_acting_player

# The current active decision the UI is processing
var active_decision: CasterDecision:
	set = _set_active_decision

# List of every decision by each player
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
	min_selections: int = 1, max_selections: int = INT32_MAX,
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
Params:
- is_decision_time: whether or not it is time to make a decision
'''
func set_decision_mode(is_decision_time: bool):
	if selection_wrapper != null:
		selection_wrapper.visible = is_decision_time

'''
Sets the current acting player for the UI.
- caster: the player who should be the foundation for the UI
'''
func set_acting_player(caster: PlayerCaster):
	acting_player = caster
	_decisions.get_or_add(acting_player, [])
	get_next_decision()

'''
Get the next decision on the queue list relative to the active player.
'''
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

'''
Starts the game. Triggered by button press.
'''
func _start_game():
	if battle_manager != null:
		start_button.hide()
		battle_manager.startMatch()
	else:
		print("No battle manager found.")

'''
Sets the active decision being made. Is a setter
'''
func _set_active_decision(decision: CasterDecision):
	if active_decision != null:
		options_list.item_updated.disconnect(active_decision._handle_toggled_selection)
	
	active_decision = decision
	
	if active_decision == null:
		return
		
	options_list.item_updated.connect(decision._handle_toggled_selection)
	selection_prompt.text = decision.prompt
	
	_set_item_list_items(decision)

'''
Sets the list of items to choose between.
Param:
	- decision: the decision from which options should be gotten
'''
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
		min_choices: int = 1, max_choices: int = INT32_MAX,
		prompt_input: String = "", preselected: Array[int] = []):
		caster = deciding_caster
		options = options_list
		selections = preselected
		
		prompt = prompt_input
		max_selections = max_choices
		min_selections = min_choices
	
	'''
	Makes the final decision for the caster decision
	Params:
		selections: a list of indices from the options that were chosen
	'''
	func make_decision():
		decision_made.emit(options, selections)
	
	'''
	Signal handler. Processes when a choice is toggled.
	'''
	func _handle_toggled_selection(choice: int, selected: bool):
		if selected:
			_add_selection(choice)
		else:
			_remove_selection(choice)
	
	'''
	Adds a choice to the list of selections
	'''
	func _add_selection(choice: int):
		if choice not in selections:
			selections.append(choice)
	
	'''
	Removes a selection from the list of choices
	'''
	func _remove_selection(choice: int):
		selections.erase(choice)
