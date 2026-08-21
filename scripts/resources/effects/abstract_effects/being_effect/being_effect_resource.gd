@abstract
class_name BeingEffectResource extends EffectResource

@export
var target_param_name: String

@abstract
func build_effect(target_param: BeingTargetParam) -> Effect
