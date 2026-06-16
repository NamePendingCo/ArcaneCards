@tool
class_name CardTargetParam extends Resource

#Set the range of the being who should own the available cards
var being_range: EventEnums.BeingRangeOption

#The range of applicable targets
var _card_range: int:
	set(val): 
		_card_range = val
		card_range = EventEnums.flagIntToEnum(val)
		notify_property_list_changed()

#The real one that mattters for code
var card_range: Array[Enums.CardState]

@export_category("Selection")

@export
var card_filter: CardFilter

@export
var is_chosen: bool = true:
	set(val): 
		is_chosen = val
		notify_property_list_changed()

#number of targets to select from, only shown if actor chooses target
var num_cards_min: int = 1:
	set(val): 
		num_cards_min = max(val, 1)
		if num_cards_max < num_cards_min: num_cards_max = val
var num_cards_max: int = num_cards_min:
	set(val): num_cards_max = max(val, num_cards_min)

#The actual chosen targets
var card_targets: Array[Card]

func _validate_property(property: Dictionary) -> void:
	if property.name == "_card_range":
		
		#card range should be a flag list based on CardStates, but
		#cannot be Null, Deck, or Discard Pile. Also creates a field flag
		EventEnums.enumFlagProperty(property, EventEnums.enumToFlags(Enums.CardState,\
		[Enums.CardState.NULL, Enums.CardState.DECK, Enums.CardState.DISCARD],\
		{"FIELD": [Enums.CardState.HAND, Enums.CardState.CASTING_WELL, Enums.CardState.CONCENTRATION_CIRCLE]}))
	
	elif property.name == "being_range":
		#the being range should be a dropdown of all non-null options
		EventEnums.enumFlagProperty(property, EventEnums.BeingRangeOption, 1)

	elif property.name == "is_chosen":
		# chosen should not be visible if card_range is null
		if (_card_range != Enums.CardState.NULL):
			property.usage |= PROPERTY_USAGE_EDITOR
		else:
			property.usage &= ~PROPERTY_USAGE_EDITOR

	elif property.name == "num_cards_min"\
	or property.name == "num_cards_max":
		# If chosen is true, reveal the number of cards options
		if is_chosen and \
		(_card_range != Enums.CardState.NULL):
			property.usage |= PROPERTY_USAGE_EDITOR
		else:
			property.usage &= ~PROPERTY_USAGE_EDITOR
