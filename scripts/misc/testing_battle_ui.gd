class_name TestingBattleUI extends CanvasLayer

signal selection_made(selections)

@onready var item_list: ItemList = $ItemList
@onready var start_button: Button = $StartButton

@export var battle_manager: BattleManager

@export var acting_caster: PlayerCaster

#Whichever player is the one being controlled
var acting_player: Caster

#List of every decision by each player
var _decisions: Dictionary[Caster, CasterDecision]

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
func request_decision(caster: Caster, options: Array[String]):
	var new_decision: CasterDecision = CasterDecision.new(caster, options)
	
	#Add decision to the list
	_decisions[caster] = new_decision
	
	return new_decision.decision_made #returns the signal so caster can wait for it

#================================================
# Private methods
#================================================

func _start_game():
	if battle_manager != null:
		start_button.hide()
		battle_manager.startMatch()
	else:
		print("No battle manager found.")

func _set_item_list_items(items: Array[String]):
	for item in items:
		item_list.add_item(item)

'''Class that allows the UI to track multiple caster decisions at once, 
and queue them up as necessary.
'''
class CasterDecision:
	
	signal decision_made
	
	var caster: Caster
	
	#the choices the caster can make
	var options: Array[String]
	
	func _init(deciding_caster: Caster, options_list: Array[String]):
		caster = deciding_caster
		options = options
	
	'''
	Makes the final decision for the caster decision
	Params:
		selections: a list of indices from the options that were chosen
	'''
	func make_decision(selections: Array[int]):
		decision_made.emit(options, selections)
