@tool
@abstract
class_name CardValEnumParamResource extends EnumParamResource

## This is a string that is used to set the parameter after complete.
## If set, this Enum param can get the value from each card when updated. 
## If left blank, value won't ever be grabbed.
@export var card_param_name: String

## Sets the card param for all unfinished parameters in unfinished params list.
func complete_unfinished_params(params_dict: Dictionary[String, EventParam]):
	var card_param = params_dict.get(card_param_name)
	
	if not card_param is CardTargetParam:
		return
		
	for param in unfinished_params:
		param = param as CardValEnumParam
		param.card_param = card_param
