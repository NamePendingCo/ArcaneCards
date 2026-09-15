@tool
@abstract
class_name IntParamResource extends EventParamResource

## Default value for the parameter.
@export var default_value: int = 0:
	set(new_val): default_value = clamp(new_val, _min_val, _max_val)

## Minimum value allowed for parameter.
@export var _min_val: int = INT32_MIN:
	set(new_val): _min_val = clamp(new_val, INT32_MIN, _max_val)

## A dictionary containing keyed values, if needed.
@export var _max_val: int = INT32_MAX:
	set(new_val): _max_val = clamp(new_val, _min_val, INT32_MAX)
