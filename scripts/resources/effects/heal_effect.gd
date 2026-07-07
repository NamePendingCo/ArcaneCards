class_name HealEffect extends BeingEffect

func run():
	var targets: Array[Being] = targets_param.targets
	
	for target in targets:
		target.heal(get_final_val())

func _get_effect_id(): return EffectID.HEAL
