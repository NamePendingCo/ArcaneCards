class_name TestingBattleUI extends CanvasLayer

signal selection_made(selections)

@onready var start_button: Button = $StartButton

@onready var selection_wrapper: Control = $Selection
@onready var options_list: UIOptionsList = $Selection/OptionsList
@onready var selection_prompt: Label = $Selection/SelectionPrompt

@export var battle_manager: BattleManager

@export var acting_player: PlayerCaster:
	set(val): set_acting_player(val)

var active_decision: CasterDecision:
	set(val): _set_active_decision(val)

#List of every decision by each player
var _decisions: Dictionary[Caster, Array]

# Called when the node enters the scene tree for the first time.
func _ready():
	start_button.pressed.connect(_start_game)
	_decisions = {}

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
func request_decision(caster: Caster, options: Array[String]) -> Signal:
	var new_decision: CasterDecision = CasterDecision.new(caster, options)
	
	#Add decision to the list
	_decisions[caster].append(new_decision)
	
	if caster == acting_player:
		get_next_decision()
	
	return new_decision.decision_made #returns the signal so caster can wait for it

'''
Set whether or not the options list should be visible, allowing the player
to make selections.
'''
func set_decision_mode(is_decision_time: bool):
	selection_wrapper.visible = is_decision_time

'''
Sets the current acting player for the UI.
'''
func set_acting_player(caster: Caster):
	acting_player = caster
	get_next_decision()

func get_next_decision():
	if _decisions[acting_player].size() > 0:
		set_decision_mode(true)
		active_decision = _decisions[acting_player][0]
	else:
		set_decision_mode(false)

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
		options_list.multi_selected.disconnect(active_decision._handle_toggled_selection)
	
	active_decision = decision
	options_list.multi_selected.connect(decision._handle_toggled_selection)
	selection_prompt.text = decision.prompt
	
	_set_item_list_items(decision._options)

func _set_item_list_items(items: Array[String]):
	for item in items:
		options_list.add_item(item)

'''Class that allows the UI to track multiple caster decisions at once, 
and queue them up as necessary.
'''
class CasterDecision:
	
	signal decision_made
	
	var caster: Caster
	
	#the choices the caster can make
	var _options: Array[String]
	var _selections: Array[int]
	var prompt: String
	
	func _init(deciding_caster: Caster, options: Array[String], 
		prompt_input: String = ""):
		caster = deciding_caster
		_options = options
		_selections = []
		
		prompt = prompt_input
	
	'''
	Makes the final decision for the caster decision
	Params:
		selections: a list of indices from the options that were chosen
	'''
	func make_decision():
		decision_made.emit(_options, _selections)
	
	func _handle_toggled_selection(choice: int, selected: bool):
		if selected:
			_add_selection(choice)
		else:
			_remove_selection(choice)
	
	func _add_selection(choice: int):
		if choice not in _selections:
			_selections.append(choice)
	
	func _remove_selection(choice: int):
		_selections.erase(choice)
