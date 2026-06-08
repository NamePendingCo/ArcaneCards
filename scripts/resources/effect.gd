@tool
class_name Effect extends Resource

#Set by parent--number of effects in the effect array of the parent
var _num_parent_effects: int = 0

@export
var event_num: int

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
	if property.name == "event_num" and _num_parent_effects > 0:
		# Sets the range of event_num to be limited to elements in effects array
		property.hint = PROPERTY_HINT_RANGE
		property.hint_string = "0," + str(_num_parent_effects - 1) + ",1"
	if property.name == "bonus_triggers":
		if multi_bonus_trigger:
			property.hint = PROPERTY_HINT_FLAGS
			property.hint_string = ",".join(EventEnums.getExportEnumVals(EventEnums.BonusTriggers).slice(1))
		else:
			property.hint = PROPERTY_HINT_ENUM
			property.hint_string = ",".join(EventEnums.getExportEnumVals(EventEnums.BonusTriggers))

func invoke() -> bool: 
	return true
