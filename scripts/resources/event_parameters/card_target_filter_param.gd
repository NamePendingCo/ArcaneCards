@tool
class_name CardTargetFilterParam extends CardTargetParam

#Set the range of the being who should own the available cards
var being_range: EventEnums.BeingRangeOption

#The range of applicable targets
var _card_state_range: int:
	set(val): 
		_card_state_range = val
		card_state_range = EventEnums.flagIntToEnum(val)
		notify_property_list_changed()
	
#The real one that mattters for code
var card_state_range: Array[Enums.CardState]

@export
var card_filter: CardFilter

#TODO
func update_range():
	pass

func _validate_property(property: Dictionary) -> void:
	if property.name == "_card_state_range":
		
		#card range should be a flag list based on CardStates, but
		#cannot be Null, Deck, or Discard Pile. Also creates a field flag
		EventEnums.enumFlagProperty(property, EventEnums.enumToFlags(Enums.CardState,\
		[Enums.CardState.NULL, Enums.CardState.DECK, Enums.CardState.DISCARD],\
		{"FIELD": [Enums.CardState.HAND, Enums.CardState.CASTING_WELL, Enums.CardState.CONCENTRATION_CIRCLE]}))
	
	elif property.name == "being_range":
		#the being range should be a dropdown of all non-null options
		EventEnums.enumFlagProperty(property, EventEnums.BeingRangeOption, 1)

	elif property.name == "is_chosen":
		# chosen should not be visible if card_state_range is null
		_set_property_visibility(property, \
		_card_state_range != Enums.CardState.NULL)

	elif property.name == "num_targets_min"\
	or property.name == "num_targets_max":
		# If chosen is true, reveal the number of cards options
		_set_property_visibility(property, is_chosen and \
		(_card_state_range != Enums.CardState.NULL))
	
	elif property.name == "persistent":
		_set_property_visibility(property, true)
		
