@tool
class_name Effect extends Resource

#Set by parent--number of effects in the effect array of the parent
var _num_parent_effects: int = 0

#If this effect only occurs based on a bonus trigger
@export
var bonus_triggers: int = EventEnums.BonusTriggers.NONE

#If true, allows bonus triggers to be selected as flags
@export
var multi_bonus_trigger: bool:
	set(val):
		if multi_bonus_trigger != val:
			multi_bonus_trigger = val
			notify_property_list_changed()

func _validate_property(property: Dictionary) -> void:
	if property.name == "bonus_triggers":
		if multi_bonus_trigger:
			property.hint = PROPERTY_HINT_FLAGS
			property.hint_string = EventEnums.getEnumValsHintString(\
			EventEnums.enumToFlags(EventEnums.BonusTriggers, [EventEnums.BonusTriggers.NONE]))
		else:
			property.hint = PROPERTY_HINT_ENUM
			property.hint_string = EventEnums.getEnumValsHintString(EventEnums.BonusTriggers)

func invoke() -> bool: 
	return true
