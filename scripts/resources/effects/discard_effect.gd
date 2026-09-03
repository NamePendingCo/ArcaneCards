class_name DiscardEffectResource extends CardEffectResource

func _new_effect() -> Effect:
	return DiscardEffect.new()

func _get_effect_id(): return EffectID.DISCARD


class DiscardEffect extends CardEffect:
	'''
	Discards the selected card. Value N/A
	'''
	func run():
		var targets: Array[Card] = targets_param.targets
		
		print("Discard effect")
		
		for target in targets:
			target.mark_to_discard()

	func _get_effect_id(): return EffectID.DISCARD
