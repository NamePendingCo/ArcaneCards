@tool
class_name OnPhaseEvent extends ListenerEvent

@export
var phase: Enums.RoundPhase = Enums.RoundPhase.DRAW

func __init__():
	isRunAfter = false

func _validate_property(property: Dictionary) -> void:
	if property.name == "phase":
		#Set range to only allow for phase values that aren't the base
		property.hint_string = EventEnums.getEnumValsHintString(\
		Enums.RoundPhase, Enums.RoundPhase.DRAW)
	elif property.name == "isRunAfter":
		property.usage &= ~PROPERTY_USAGE_EDITOR
