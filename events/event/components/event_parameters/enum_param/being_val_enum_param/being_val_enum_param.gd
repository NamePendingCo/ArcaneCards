@abstract
class_name BeingValEnumParam extends EnumParam

var being_param: BeingTargetParam

@abstract
func _get_value_from_being(being: Being)

func _set_from_beings():
	for being in being_param.targets:
		_set_keyed_value(being.name, _get_value_from_being(being))
