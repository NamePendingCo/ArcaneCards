class_name NPCCaster extends Caster

func make_casting_phase_decisions():
	super()

func _choose_being_from_range(param: BeingTargetParam):
	_random_target_selection(param)
	

func _choose_card_from_range(param: CardTargetParam):
	_random_target_selection(param)
