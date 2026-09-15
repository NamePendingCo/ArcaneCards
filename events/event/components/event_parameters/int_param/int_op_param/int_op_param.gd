class_name IntOpParamResource extends IntParamResource

## Stores data for a [member IntOpParam], a basic parameter for tracking int values.

enum Operation {
	ADD, ## A + B
	SUBTRACT, ## A - B
	MULTIPLY, ## A * B
	DIVIDE, ## A / B
	MOD, ## A % B (remainder)
	ABS_SUB ## |A - B| (absolute value difference)
}

## The first parameter in the operation.
@export var param_a_name: String 

## The second parameter in the operation.
@export var param_b_name: String

@export var operation: Operation

func build_param(actor: Actor, card: Card) -> EventParam:
	var param = IntOpParam.new_int_op_param(actor, card, is_chosen, default_value, 
	_min_val, _max_val, operation)
	
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

	@export var operation: Operation

	static func new_int_op_param(actor: Actor, card: Card, chosen: bool, 
	default: int, min: int, max: int, op: Operation) -> IntOpParam:
		var param = IntOpParam.new()
		param._set_int_base_vals(actor, card, chosen, default, min, max)
		param.operation = op
		
		return param
	
	func set_params(parameter_a: IntParam, parameter_b: IntParam):
		param_a = parameter_a
		param_b = parameter_b
	
	func _perform_op():
		var op_func: Callable
		match operation:
			Operation.ADD: op_func = func(a, b): return a + b
			Operation.SUBTRACT: op_func = func(a, b): return a - b
			Operation.MULTIPLY: op_func = func(a, b): return a * b
			Operation.DIVIDE: op_func = func(a, b): return int(floor(a / b))
			Operation.MOD: op_func = func(a, b): return a % b
			Operation.ABS_SUB: op_func = func(a, b): return abs(a - b)
		
		value = int(op_func.call(param_a.value, param_b.value))
		
		var shared_keys: Array[String] = param_a.value_dict.keys().filter(
			func(val): val in param_b.value_dict.keys())
		
		## Set all the shared key values
		for key in shared_keys:
			_set_keyed_value(key, op_func.call(
				param_a.get_keyed_value(key), param_b.get_keyed_value(key)))
