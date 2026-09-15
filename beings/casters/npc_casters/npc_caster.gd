class_name NPCCaster extends Caster

'''
Choose what cards to cast during cast phase.
'''
#TODO: Implement selection logic. Currently is random
func make_casting_phase_decisions():
	super()

'''
Chooses a being to target during selection.
'''
#TODO: Implement selection logic. Currently is random
func _choose_being_from_range(param: BeingTargetParam):
	_random_target_selection(param)

'''
Chooses a card to target during selection.
'''
#TODO: Implement selection logic. Currently is random
func _choose_card_from_range(param: CardTargetParam):
	_random_target_selection(param)
