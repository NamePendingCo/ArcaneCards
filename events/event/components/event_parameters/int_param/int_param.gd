@abstract
class_name IntParam extends EventParam

var value: int

var value_dict: Dictionary[String, int]

'''
Gets a value based on a given key (usually a target's id for an effect.)
If the key does not have a value, return the base value instead
'''
func get_keyed_value(key: String):
	return value_dict.get(key, value)

func _set_keyed_value(key: String, val: int):
	value_dict[key] = value
