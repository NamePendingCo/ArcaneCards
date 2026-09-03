@tool
class_name CardTargetFilterResource extends CardTargetResource

enum HandleSelf {
	EXCLUDE_SELF,
	INCLUDE_SELF,
	ONLY_SELF
}

# If there should be a being range that should limit the cards
@export var being_range_name: String

@export
var self_handling: HandleSelf

@export
var card_filter: CardFilter

#The range of applicable targets enumed
@export var _location_range: int:
	set(val): 
		_location_range = val
		notify_property_list_changed()

#================================================
# Public methods
#================================================

func build_param(actor: Actor, card: Card) -> EventParam:
	var param = CardTargetFilterParam.new(actor, card, self_handling, _location_range, card_filter, is_chosen,
	num_targets_min, num_targets_max)
	unfinished_params.append(param)
	
	return param

#OVERRIDES
func complete_unfinished_params(params_dict: Dictionary[String, EventParam]):
	while not unfinished_params.is_empty():
		var param = unfinished_params.pop_back() as CardTargetFilterParam
		
		if being_range_name != "" and\
		params_dict[being_range_name] is BeingTargetParam:
			param.being_range = params_dict[being_range_name]

#================================================
# Private methods
#================================================

func _validate_property(property: Dictionary) -> void:
	if property.name == "_location_range":
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

class CardTargetFilterParam extends CardTargetParam:

	#Set the range of the being who should own the available cards
	var being_range: BeingTargetParam

	#List of locations
	var location_range: Array[Card.Location]
	
	var self_handling: HandleSelf
	
	var card_filter: CardFilter
	
	func _init(my_actor: Actor, my_card: Card, self_strategy: HandleSelf, loc_range: int, filter: CardFilter, 
	chosen: bool, targets_min: int=1, targets_max: int=1, persist=false):
		self_handling = self_strategy
		card_filter = filter
		location_range = EventEnums.flagIntToEnum(loc_range)
		
		if self_handling == HandleSelf.ONLY_SELF:
			chosen = false
			
		super(my_actor, my_card, chosen, targets_min, targets_max, persist)

	#================================================
	# Public methods
	#================================================

	'''
	Sends a signal which should tell the actor to update its range using
	update_range_from_list
	'''
	func update_range():
		var all_cards: Array[Card] = []
		all_cards.assign(get_tree().get_nodes_in_group(Constants.GROUP_CARD))
		
		targets_range = all_cards.filter(_check_card)
		
		if being_range != null:
			being_range.update_range()
		super()

	#================================================
	# Private methods
	#================================================

	'''
	Check if a card is acceptable and meets parameters.
	'''
	func _check_card(card: Card) -> bool:
		if (self_handling == HandleSelf.EXCLUDE_SELF) and (card == parent_card):
			print("Excluding card self")
			return false
		elif (self_handling == HandleSelf.ONLY_SELF) and (card != parent_card):
			print("Not card self")
			return false
		elif being_range and (card.card_caster not in being_range.targets_range):
			print("Not in being range")
			return false
		elif card.location not in location_range:
			print("Not in right location")
			return false
		elif (card_filter != null) and (not card_filter.card_valid(card)):
			print("Not in filter")
			return false
		else:
			return true
