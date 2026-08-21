@abstract
class_name CardEffectResource extends EffectResource

@export
var target_param_name: String

@abstract
func build_effect(target_param: CardTargetParam) -> Effect
