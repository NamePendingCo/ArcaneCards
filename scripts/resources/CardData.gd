class_name CardData

extends Resource

@export var card_id: String # Unique ID for database stuff

@export var cardName: String
@export var color: Enums.SpellColor
@export var subdomain: Enums.Subdomain
@export var type: Enums.CardType
@export var tier: int

@export var activation_cost: Array[int]
@export var upkeep_cost: int

@export var art:Texture
