class_name HealEffect extends BeingEffect

'''
Has all targets heal equal to the value.
'''

func run():
	var targets: Array[Being] = targets_param.targets
	
	for target in targets:
		target.heal(get_final_val())

func _get_effect_id(): return EffectID.HEAL
