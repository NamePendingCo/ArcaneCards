class_name DiscardEffect extends CardEffect

func run():
	var targets: Array[Card] = targets_param.targets
	
	print("Discard effect")
	
	for target in targets:
		target.mark_to_discard()

func _get_effect_id(): return EffectID.DISCARD
