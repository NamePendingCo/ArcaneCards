@tool
class_name CardTargetParam extends Resource

#Set the range of the being who should own the available cards
var being_range: EventEnums.BeingRangeOption

@export
var is_chosen_from: bool = true

#The range of applicable targets
var _card_range: int:
	set(val): 
		_card_range = val
		card_range = EventEnums.flagIntToEnum(val)
		print(card_range)
		notify_property_list_changed()

#The real one that mattters for code
var card_range: Array[Enums.CardState]

#number of targets to select from, only shown if actor chooses target
var num_targets: int = 1:
	set(val): num_targets = max(val, 1)

#The actual chosen targets
var card_targets: Array[Card]

func _validate_property(property: Dictionary) -> void:
	if property.name == "_card_range":
		property.usage ^= PROPERTY_USAGE_EDITOR
		property.hint = PROPERTY_HINT_FLAGS
		property.hint_string = EventEnums.getEnumValsHintString(\
		EventEnums.enumToFlags(Enums.CardState,\
		[Enums.CardState.NULL, Enums.CardState.DECK, Enums.CardState.DISCARD],\
		{"FIELD": [Enums.CardState.HAND, Enums.CardState.CASTING_WELL, Enums.CardState.CONCENTRATION_CIRCLE]}))
	if property.name == "being_range":
		property.usage ^= PROPERTY_USAGE_EDITOR
		property.hint = PROPERTY_HINT_FLAGS
		property.hint_string = EventEnums.getEnumValsHintString(EventEnums.BeingRangeOption, 1)
	if property.name == "num_targets":
		if is_chosen_from and \
		(_card_range != Enums.CardState.NULL):
			property.usage ^= PROPERTY_USAGE_EDITOR
		else:
			property.usage &= ~PROPERTY_USAGE_EDITOR
