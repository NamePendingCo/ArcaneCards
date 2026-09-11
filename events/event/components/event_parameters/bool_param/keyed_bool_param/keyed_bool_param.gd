@abstract
class_name KeyedBoolParam extends BoolParam

'''
A boolean parameter that can be keyed based on a set of values.

Most useful for per-target operations.
'''

var value_dict: Dictionary[String, bool]

'''
Gets a value based on a given key (usually a target's id for an effect.)
If the key does not have a value, return the base value instead
'''
func get_keyed_value(key: String):
	return value_dict.get(key, value)

func _set_keyed_value(key: String, val: bool):
	value_dict[key] = val
