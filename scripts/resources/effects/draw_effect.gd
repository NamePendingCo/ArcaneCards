class_name DrawEffect extends BeingEffect

func run():
	print("Draw effect running...")
	var targets: Array[Being] = targets_param.targets as Array[Being]
	
	for target in targets:
		if target is Caster:
			target.draw(get_final_val())

func _get_effect_id(): return EffectID.DRAW
