class_name CardTargetParam extends Resource

#Set the range of the being who should own the available cards
@export
var being_range: EventEnums.BeingRangeOption

@export
var is_chosen_from: bool = true

#The range of applicable targets
@export
var range: EventEnums.CardRangeOption:
	set(val): 
		range = val
		notify_property_list_changed()

#number of targets to select from, only shown if actor chooses target
var num_targets: int = 1:
	set(val): num_targets = max(val, 1)

#The actual chosen targets
var card_targets: Array[Card]

func _validate_property(property: Dictionary) -> void:
	if property.name == "num_targets":
		if is_chosen_from and \
		(range != EventEnums.CardRangeOption.NULL):
			property.usage ^= PROPERTY_USAGE_EDITOR
		else:
			property.usage &= ~PROPERTY_USAGE_EDITOR
