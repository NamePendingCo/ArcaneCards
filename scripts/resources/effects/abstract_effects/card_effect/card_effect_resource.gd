@abstract
class_name CardEffectResource extends EffectResource

const TARGET_PARAM_NAME = "target_param_name"

@export
var target_param_name: String

@abstract
func _build_effect(target_param: CardTargetParam) -> Effect

func build_effect(params: Dictionary[String, EventParam]) -> Effect:
	var target_param = params[target_param_name] if params.has(target_param_name) else null
	return _build_effect(target_param)

func get_effect_parameters() -> Dictionary[String, String]:
	var params: Dictionary[String, String] = {}
	
	params[target_param_name] = TARGET_PARAM_NAME
	
	return params
