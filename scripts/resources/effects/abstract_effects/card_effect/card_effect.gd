@abstract
class_name CardEffect extends Effect

'''
Effects that target cards.
'''

var targets_param: CardTargetParam

func _init(val: int, targeting_param: CardTargetParam, min_val: int = 0, max_val: int = INT32_MAX):
	super(val, min_val, max_val)
	targets_param = targeting_param
