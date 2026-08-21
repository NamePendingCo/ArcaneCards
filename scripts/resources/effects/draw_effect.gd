class_name DrawEffectResource extends BeingEffectResource

func build_effect(target_param: BeingTargetParam) -> Effect:
	return DrawEffect.new(_val, target_param, _min_val, _max_val)

func _get_effect_id(): return EffectID.DRAW

class DrawEffect extends BeingEffect:
	'''
	Has all targets draw cards equal to the value.
	'''
	func run():
		var targets: Array[Being] = targets_param.targets as Array[Being]
		
		for target in targets:
			if target is Caster:
				target.draw(get_final_val())

	func _get_effect_id(): return EffectID.DRAW
