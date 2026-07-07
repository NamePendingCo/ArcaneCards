class_name TestingBattleUI extends CanvasLayer

signal selection_made(selections)

@onready var item_list: ItemList = $ItemList

@export
var acting_caster: PlayerCaster

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_item_list_items(items: Array[String]):
	for item in items:
		item_list.add_item(item)
