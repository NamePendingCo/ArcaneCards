class_name CardData

extends Resource

@export var card_id: String # Unique ID for database stuff

@export var cardName: String
@export var color: Enums.SpellColor
@export var subdomain: Enums.Subdomain
@export var type: Enums.CardType
@export var tier: int

@export_group("Costs")
@export var activation_cost: Array[int]
@export var upkeep_cost: int

@export_group("Details")
@export_multiline() var effects_text: String

@export var art: Texture

@export_category("Events and Effects")
@export var events: Array[Event]
