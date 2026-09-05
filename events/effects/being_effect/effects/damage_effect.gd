class_name DamageEffectResource extends BeingEffectResource

func _new_effect() -> Effect:
	return DamageEffect.new()

func _get_effect_id(): return EffectID.INFLICT_DAMAGE

class DamageEffect extends BeingEffect:
	'''
	Has all targets take damage equal to the value.
	'''
	func run():
		var targets: Array[Being] = targets_param.targets
		
		for target in targets:
			target.take_damage(get_final_val())

	func _get_effect_id(): return EffectID.INFLICT_DAMAGE
