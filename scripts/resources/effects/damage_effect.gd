class_name DamageEffectResource extends BeingEffectResource

func _build_effect(target_param: BeingTargetParam) -> Effect:
	return DamageEffect.new(_val, target_param, _min_val, _max_val)

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
