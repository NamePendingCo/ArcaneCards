class_name ConcentrationCircle extends SlottedCardArray

func _get_relevant_card_state():
	return Enums.CardState.CONCENTRATION_CIRCLE

'''
Alias for add card to array for concentration circle
'''
func add_card_to_conc_circle(card: Card, slot_num: int=-1):
	_add_card_to_array(card, slot_num)

func get_circle_upkeep():
	var upkeep_total = 0
	
	for slot in card_slots:
		upkeep_total += slot.attached_card.upkeep
		
	return upkeep_total

'''
Used to trigger signals before upkeep
'''
func prepare_pay_circle_upkeep():
	for slot in card_slots:
		slot.attached_card.prepare_pay_upkeep()

func pay_circle_upkeep():
	var upkeep_total = 0
	
	for slot in card_slots:
		upkeep_total += slot.attached_card.pay_upkeep()
	
	return upkeep_total
