@abstract
class_name BeingEffect extends Effect

'''
Effects that target beings and casters.
'''

var targets_param: BeingTargetParam

func _init(val: int, targeting_param: BeingTargetParam, min_val: int = 0, max_val: int = INT32_MAX):
	super(val, min_val, max_val)
	targets_param = targeting_param
