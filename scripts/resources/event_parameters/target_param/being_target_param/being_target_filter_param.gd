@tool
class_name BeingTargetFilterResource extends BeingTargetResource

#The range of applicable targets
@export
var range_option: EventEnums.BeingRangeOption:
	set(val): 
		range_option = val
		notify_property_list_changed()

@export
var being_filter: BeingFilter

#================================================
# Public methods
#================================================

func build_param(actor: Actor, card: Card):
	var param = BeingTargetFilterParam.new(actor, card, range_option, being_filter, is_chosen, num_targets_min, num_targets_max)
	
	return param

#================================================
# Private methods
#================================================

func _validate_property(property: Dictionary) -> void:
	if property.name == "is_chosen":
		# Chosen only shown if range isn't null or self, or for Operations
		_set_property_visibility(property,\
		(range_option & EventEnums.BeingRangeOption.ALL_OTHERS) != 0)
	elif property.name == "num_targets_min" \
	or property.name == "num_targets_max":
		#target numbers only shown if is chosen is relevant
		_set_property_visibility(property,\
		(is_chosen  and (range_option & EventEnums.BeingRangeOption.ALL_OTHERS) != 0))
	elif property.name == "persistent":
		_set_property_visibility(property, true)

class BeingTargetFilterParam extends BeingTargetParam:

	var range_option: EventEnums.BeingRangeOption

	#The filter to apply
	var being_filter: BeingFilter

	func _init(my_actor: Actor, my_card: Card, my_range_option: EventEnums.BeingRangeOption, filter: BeingFilter, chosen: bool,
	targets_min: int=1, targets_max: int=1):
		super(my_actor, my_card, chosen, targets_min, targets_max)
		range_option = my_range_option
		being_filter = filter

	#================================================
	# Public methods
	#================================================

	'''
	Gets the list of targets
	'''
	func update_range():
		var all_beings: Array[Being] = []
		all_beings.assign(get_tree().get_nodes_in_group(Constants.GROUP_BEING))
		
		if actor != null and is_instance_of(actor, Being):
			match range_option:
				EventEnums.BeingRangeOption.SELF: all_beings = [actor]
				EventEnums.BeingRangeOption.ALL_OTHERS: all_beings.erase(actor)
		
		targets_range = all_beings.filter(_check_being)

	#================================================
	# Private methods
	#================================================

	'''
	Filter function used to see if a specific being matches the parameter filters.
	'''
	func _check_being(being: Being) -> bool:
		if (range_option ^ EventEnums.BeingRangeOption.SELF == 0) \
		and (being != actor):
			return false
		elif (range_option ^ EventEnums.BeingRangeOption.ALL_OTHERS == 0) \
		and (being == actor):
			return false
		if being_filter != null:
			return being_filter.check_being(being)
		else:
			return true
