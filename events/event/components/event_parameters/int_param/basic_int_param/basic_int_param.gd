class_name BasicIntResource extends IntParamResource

## Stores data for a [member BasicIntParam], a basic parameter for tracking int values.

func build_param(actor: Actor, card: Card) -> EventParam:
	var param = BasicIntParam.new_basic_int_param(actor, card, is_chosen, default_value, _min_val, _max_val)
	
	return param

class BasicIntParam extends IntParam:
	
	## A basic parameter for tracking int values.
	
	static func new_basic_int_param(actor: Actor, card: Card, chosen: bool, 
	default: int, min: int, max: int) -> BasicIntParam:
		var param = BasicIntParam.new()
		param._set_int_base_vals(actor, card, chosen, default, min, max)
		
		return param
