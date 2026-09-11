@abstract
class_name EnumParam extends EventParam
## A parameter for an [Event] that can be used for setting or comparing
## an enumerated value for an effect.
##
## This is an abstract class. 

var _value: int

## A dictionary of values that are keyed on an id String. This is normally
## a being name or a card name, so it can be based on targets.
var value_dict: Dictionary[String, int]

'''
Gets a value based on a given key (usually a target's id.)
If the key does not have a value, return the base value instead
'''
func get_keyed_value(key: String):
	return value_dict.get(key, _value)

func _set_keyed_value(key: String, val: int):
	value_dict[key] = _value
