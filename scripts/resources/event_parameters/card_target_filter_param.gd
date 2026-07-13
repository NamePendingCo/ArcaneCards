@tool
class_name CardTargetFilterParam extends CardTargetParam

signal requested_cards_list #Sent when requiring all cards in cards group

#Used to get name of range to select from
@export var being_range_name: String

#Set the range of the being who should own the available cards
var _being_range: BeingTargetParam

#The range of applicable targets
var _location_range: int:
	set(val): 
		_location_range = val
		location_range = EventEnums.flagIntToEnum(val)
		notify_property_list_changed()

#The real one that mattters for code
var location_range: Array[Card.Location]

@export
var exclude_self: bool = true

@export
var card_filter: CardFilter

'''
When passed a list of beings, updates from these
'''
func update_range_from_list(all_cards: Array[Card]):
	targets_range.clear()
	targets_range.append_array(all_cards.filter(_check_card))

'''
Sends a signal which should tell the actor to update its range using
update_range_from_list
'''
func update_range():
	requested_cards_list.emit(self)

'''
Check if a card is acceptable and meets parameters.
'''
func _check_card(card: Card) -> bool:
	if exclude_self and (card == _card_parent):
		return false
	elif card.card_caster not in _being_range.targets_range:
		return false
	elif card.location not in location_range:
		return false
	elif (card_filter != null) and (not card_filter.card_valid(card)):
		return false
	else:
		return true

func _validate_property(property: Dictionary) -> void:
	if property.name == "_card_state_range":	
		#card range should be a flag list based on CardStates, but
		#cannot be Null, Deck, or Discard Pile. Also creates a field flag
		EventEnums.enumFlagProperty(property, EventEnums.enumToFlags(Card.Location,\
		[Card.Location.NULL, Card.Location.DECK, Card.Location.DISCARD],\
		{"FIELD": [Card.Location.HAND, Card.Location.CASTING_WELL, Card.Location.CONCENTRATION_CIRCLE]}))
		
	elif property.name == "is_chosen":
		# chosen should not be visible if card_state_range is null
		_set_property_visibility(property, \
		_location_range != Card.Location.NULL)

	elif property.name == "num_targets_min"\
	or property.name == "num_targets_max":
		# If chosen is true, reveal the number of cards options
		_set_property_visibility(property, is_chosen and \
		(_location_range != Card.Location.NULL))
	
	elif property.name == "persistent":
		_set_property_visibility(property, true)
