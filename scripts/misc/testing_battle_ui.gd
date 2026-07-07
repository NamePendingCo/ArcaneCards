class_name TestingBattleUI extends CanvasLayer

signal selection_made(selections)

@onready var item_list: ItemList = $ItemList
@onready var start_button: Button = $StartButton

@export var battle_manager: BattleManager

@export var acting_caster: PlayerCaster

# Called when the node enters the scene tree for the first time.
func _ready():
	start_button.pressed.connect(_start_game)

func _start_game():
	start_button.hide()
	battle_manager.startMatch()

func set_item_list_items(items: Array[String]):
	for item in items:
		item_list.add_item(item)
