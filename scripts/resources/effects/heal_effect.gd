class_name HealEffectResource extends BeingEffectResource

func _new_effect() -> Effect:
	return HealEffect.new()

func _get_effect_id(): return EffectID.HEAL

class HealEffect extends BeingEffect:
	'''
	Has all targets heal equal to the value.
	'''
	func run():
		var targets: Array[Being] = targets_param.targets
		
		for target in targets:
			target.heal(get_final_val())

	func _get_effect_id(): return EffectID.HEAL
