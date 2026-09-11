@tool
@abstract
class_name BeingValEnumParamResource extends EnumParamResource

## This is a string that is used to set the parameter after complete.
## If set, this Enum param can get the value from each card when updated. 
## If left blank, value won't ever be grabbed.
@export var being_param_name: String

#Sets the being param for all unfinished
func complete_unfinished_params(params_dict: Dictionary[String, EventParam]):
	var being_param = params_dict.get(being_param_name)
	
	if not being_param is BeingTargetParam:
		return
		
	for param in unfinished_params:
		param = param as BeingValEnumParam
		param.being_param = being_param
