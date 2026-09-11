@abstract
class_name CardValEnumParamResource extends EnumParamResource

var card_param_name: String

#Sets the being param for all unfinished
func complete_unfinished_params(params_dict: Dictionary[String, EventParam]):
	var card_param = params_dict.get(card_param_name)
	
	if not card_param is CardTargetParam:
		return
		
	for param in unfinished_params:
		param = param as CardValEnumParam
		param.card_param = card_param
