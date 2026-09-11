class_name RangeParamResource extends IntParamResource

@export
var min_val: int

@export
var max_val: int

func build_param(actor: Actor, card: Card) -> EventParam:
	var param = RangeParam.new(actor, card, is_chosen, min_val, max_val)
	
	return param

class RangeParam extends IntParam:
	
	var min_val: int
	var max_val: int

	func _init(actor: Actor, card: Card, chosen: bool, 
	min: int, max: int):
		super(actor, card, chosen)
		min_val = min
		max_val = max
