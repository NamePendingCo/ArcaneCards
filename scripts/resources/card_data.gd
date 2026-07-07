@tool
class_name CardData

extends Resource

@export var card_id: String # Unique ID for database stuff

@export var cardName: String
@export var color: Enums.SpellColor
@export var subdomain: Enums.Subdomain
@export var type: Enums.CardType
@export var tier: int

@export_group("Costs")
@export var activation_cost: Array[int]:
	set(val):
		activation_cost = val
		if activation_cost.size() > 3: activation_cost.resize(3)
@export var upkeep_cost: int

@export_group("Details")
@export_multiline() var effects_text: String

@export var art: Texture

@export var event_data: CardEventData

func _init():
	if Engine.is_editor_hint() and event_data == null:
		event_data = CardEventData.new()

func _ready():
	if not Engine.is_editor_hint():
		#Prepare params when in game, but not in editor
		event_data.prepare_params()
