@tool
class_name OnPhaseEvent extends ListenerEvent

@export
var phase: BattleManager.RoundPhase = BattleManager.RoundPhase.DRAW

func __init__():
	isRunAfter = false

'''
Used for improved use of resource on backend side. Sets which properties are
visible and what params they take.
'''
func _validate_property(property: Dictionary) -> void:
	if property.name == "phase":
		#Set range to only allow for phase values that aren't the base
		property.hint_string = EventEnums.getEnumValsHintString(\
		BattleManager.RoundPhase, BattleManager.RoundPhase.DRAW)
	elif property.name == "isRunAfter":
		property.usage &= ~PROPERTY_USAGE_EDITOR
