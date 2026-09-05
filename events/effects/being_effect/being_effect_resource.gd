@abstract
class_name BeingEffectResource extends EffectResource

const TARGET_PARAM_NAME = BeingEffect.TARGET_PARAM_NAME

@export
var target_param_name: String

func populate_params(effect: Effect, params: Dictionary[String, EventParam]):
	effect.targets_param = params[target_param_name] if params.has(target_param_name) else null

func get_effect_parameters() -> Dictionary[String, String]:
	var params: Dictionary[String, String] = {}
	
	params[target_param_name] = TARGET_PARAM_NAME
	
	return params
