@tool
class_name CardListenerEventLauncher extends ListeningEventResource

enum CardTriggers {
	INVOKE,
	ACTIVATE,
	CAST
}

@export var triggerEvent: CardTriggers

func set_up_event_launcher(param_dict: Dictionary[String, EventParam], 
actor: Actor = null, card: Card = null, event_name: String = "") -> EventLauncher:
	var launcher: CardListenerLauncher = super(param_dict, actor, card, event_name)
	launcher.triggerEvent = CardTriggers
	
	return launcher

'''
Used for improved use of resource on backend side. Sets which properties are
visible and what params they take.
'''
func _validate_property(property: Dictionary) -> void:
	if property.name == "is_run_after":
		#is run after should be shown if activate or invoke is true
		if triggerEvent in [CardTriggers.INVOKE, CardTriggers.ACTIVATE]:
			property.usage |= PROPERTY_USAGE_EDITOR
		else:
			property.usage &= ~PROPERTY_USAGE_EDITOR

class CardListenerLauncher extends ListeningLauncher:

	var triggerEvent: CardTriggers

	var triggering_cards: CardTargetParam

	func _activate_event():
		super()
		#Reset the connections every time the target list is updated
		triggering_cards.updated_targets.connect(reset_connections)

	#Subscribe to the correct signal for the listener
	func _connect_to_card(card: Card):
		match triggerEvent:
			CardTriggers.INVOKE:
				isRunAfter = true
				card.invoked.connect(trigger)
			CardTriggers.ACTIVATE:
				isRunAfter = false
				card.activated.connect(trigger)
			CardTriggers.CAST:
				isRunAfter = false
				card.casted.connect(trigger)

	'''
	Disconnects from all existing connections. Then connect
	to the relevant signal for each card in the target list.
	'''
	func reset_connections():
		#first disconnect all current triggers
		disconnect_all_triggers()
		
		#connect to all triggers on card list
		for card in triggering_cards.card_targets:
			_connect_to_card(card)
