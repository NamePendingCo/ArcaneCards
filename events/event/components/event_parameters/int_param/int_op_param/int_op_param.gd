class_name IntOpParamResource extends IntParamResource

## Stores data for a [member IntOpParam], a basic parameter for tracking int values.

## The first parameter in the operation.
@export var param_a_name: String 

## The second parameter in the operation.
@export var param_b_name: String

func build_param(actor: Actor, card: Card) -> EventParam:
	var param = IntOpParam.new_int_op_param(actor, card, is_chosen, default_value, _min_val, _max_val)
	
	return param

#OVERRIDES
func complete_unfinished_params(params_dict: Dictionary[String, EventParam]):
	while not unfinished_params.is_empty():
		var param = unfinished_params.pop_back() as IntParam
		
		param.set_params(params_dict[param_a_name], params_dict[param_b_name])

## A basic parameter for tracking int values.
class IntOpParam extends IntParam:
	
	## The first parameter in the operation.
	@export var param_a: IntParam 
	
	## The second parameter in the operation.
	@export var param_b: IntParam

	static func new_int_op_param(actor: Actor, card: Card, chosen: bool, 
	default: int, min: int, max: int) -> IntOpParam:
		var param = IntOpParam.new()
		param._set_int_base_vals(actor, card, chosen, default, min, max)
		
		return param
	
	func set_params(parameter_a: IntParam, parameter_b: IntParam):
		param_a = parameter_a
		param_b = parameter_b
