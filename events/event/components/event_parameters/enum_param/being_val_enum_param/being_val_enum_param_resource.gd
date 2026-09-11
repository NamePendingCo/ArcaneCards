@abstract
class_name BeingValEnumParamResource extends EnumParamResource

var being_param_name: String

#Sets the being param for all unfinished
func complete_unfinished_params(params_dict: Dictionary[String, EventParam]):
	var being_param = params_dict.get(being_param_name)
	
	if not being_param is BeingTargetParam:
		return
		
	for param in unfinished_params:
		param = param as BeingValEnumParam
		param.being_param = being_param
