class_name DamageEffect extends BeingEffect

func run():
	var targets: Array[Being] = targets_param.targets
	
	for target in targets:
		target.take_damage(get_final_val())

func _get_effect_id(): return EffectID.INFLICT_DAMAGE
