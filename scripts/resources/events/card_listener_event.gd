class_name CardListenerEvent extends ListenerEvent

enum CardTriggers {
	INVOKE,
	ACTIVATE,
	CAST
}

@export var triggerEvent: CardTriggers

var triggering_cards: CardTargetParam

func _activate_event():
	#Reset the connections every time the target list is updated
	triggering_cards.updated_targets.connect(reset_connections)

func _deactivate_event():
	pass

#Subscribe to the correct signal for the listener
func _connect_to_card(card: Card):
	match triggerEvent:
		CardTriggers.INVOKE:
			card.invoked.connect(trigger)
		CardTriggers.ACTIVATE:
			card.activated.connect(trigger)
		CardTriggers.CAST:
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

func _validate_property(property: Dictionary) -> void:
	if property.name == "is_run_after":
		#is run after should be shown if activate or invoke is true
		if triggerEvent in [CardTriggers.INVOKE, CardTriggers.ACTIVATE]:
			property.usage |= PROPERTY_USAGE_EDITOR
		else:
			property.usage &= ~PROPERTY_USAGE_EDITOR
