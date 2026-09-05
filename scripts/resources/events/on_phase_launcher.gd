@tool
class_name OnPhaseEventResource extends ListeningEventResource

#The phase the event occurs on
@export var phase: BattleManager.RoundPhase = BattleManager.RoundPhase.DRAW

func set_up_event_launcher(param_dict: Dictionary[String, EventParam], 
actor: Actor = null, card: Card = null, event_name: String = "") -> EventLauncher:
	#Create the actual event to duplicate
	var event_template: Event = _build_event_template(param_dict, event_name)
	
	var launcher = OnPhaseLauncher.new(event_template, actor, card)
	launcher.name = event_name + "_launcher"
	
	launcher.is_system_event = is_system_event
	launcher.phase = phase
	
	return launcher

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

class OnPhaseLauncher extends ListeningLauncher:

	var phase: BattleManager.RoundPhase = BattleManager.RoundPhase.DRAW

	func _init(event: Event, my_actor: Actor = null, card: Card = null):
		super(event, my_actor, card)
		isRunAfter = false
