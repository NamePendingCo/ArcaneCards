@abstract
class_name CardEffect extends Effect

'''
Effects that target cards.
'''

const TARGET_PARAM_NAME = "target_param_name"

var targets_param: CardTargetParam

'''
Gets all the parameters for an effect as a dictionary
'''
func get_params() -> Dictionary[String, EventParam]:
	var params = super()
	params[TARGET_PARAM_NAME] = targets_param
	return params

'''
Sets all the params for an effect based on a dictionary
'''
func set_params(params: Dictionary[String, EventParam]):
	super(params)
	targets_param = params[TARGET_PARAM_NAME]
