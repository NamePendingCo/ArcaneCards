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
#list of targeting parameters which are used by effects
@export var params: Dictionary[String, EventParam]
#dictionary of events on this card
@export var events: Dictionary[String, Event]

func _ready():
	if not Engine.is_editor_hint():
		#Prepare params when in game, but not in editor
		prepare_params()

'''
Uses the designer name based parameters in events and effects
and sets the actual variables to use them.
'''
func prepare_params():
	for key in events.keys():
		var event: Event = events[key]
		#Populate param list from names
		for param_name in event.choice_param_names:
			assert(param_name in params, \
			"Parameter %s not in params list" % param_name)
			
			event.choice_params.append(params[param_name])
		
		for effect in event.effects:
			#TODO - handle effect params
			continue
	pass
