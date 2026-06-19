@abstract
class_name CardListenerEvent extends ListenerEvent

var triggering_cards: CardTargetParam

func _activate_event():
	#Reset the connections every time the target list is updated
	triggering_cards.updated_targets.connect(reset_connections)

#Subscribe to the correct signal for the listener
@abstract
func _connect_to_card(card: Card)

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
