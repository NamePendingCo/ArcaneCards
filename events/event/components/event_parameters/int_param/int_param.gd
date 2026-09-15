@abstract
class_name IntParam extends EventParam

## The primary value of the parameter.
@export var value: int:
	set(new_val): value = clamp(new_val, _min_val, _max_val)

## Minimum value allowed for parameter.
@export var _min_val: int:
	set(new_val): _min_val = clamp(new_val, INT32_MIN, _max_val)

## Maximum value allowed for parameter.
@export var _max_val: int:
	set(new_val): _max_val = clamp(new_val, _min_val, INT32_MAX)

## A dictionary containing keyed values, if needed.
@export var value_dict: Dictionary[String, int]

## Gets a value based on a given key (usually a target's id for an effect.)
## If the key does not have a value, return the base value instead.
func get_keyed_value(key: String):
	return value_dict.get(key, value)

func _set_keyed_value(key: String, val: int):
	value_dict[key] = clamp(val, _min_val, _max_val)
