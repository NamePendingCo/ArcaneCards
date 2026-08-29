@tool
class_name CardTargetOperationResource extends CardTargetResource

const SET_OPS = TargetOperationHandler.SetOperation

@export
var param_a_name: String 

@export
var param_b_name: String

#================================================
# Public methods
#================================================

func build_param() -> EventParam:
	var param = CardTargetOperationParam.new(is_chosen, num_targets_min, num_targets_max, persistent)
	
	#Saves param so it can be populated later
	unfinished_params.append(param)
	
	return param

#OVERRIDES
func complete_unfinished_params(params_dict: Dictionary[String, EventParam]):
	while not unfinished_params.is_empty():
		var param = unfinished_params.pop_back() as CardTargetOperationParam
		
		param.set_params(params_dict[param_a_name], params_dict[param_b_name])

#================================================
# Private methods
#================================================

func _validate_property(property: Dictionary) -> void:
	if property.name == "is_chosen":
		# Chosen only shown if range isn't null or self
		_set_property_visibility(property, true)
	elif property.name == "num_targets_min" \
	or property.name == "num_targets_max":
		#target numbers only shown if is chosen is relevant
		_set_property_visibility(property, is_chosen)
	elif property.name == "persistent":
		_set_property_visibility(property, true)

class CardTargetOperationParam extends CardTargetParam:
	
	var operation_handler: TargetOperationHandler

	func _init(chosen: bool, targets_min: int=1, targets_max: int=1, persist=false):
		super(chosen, targets_min, targets_max, persist)

	func update_range():
		targets_range = operation_handler.range

	'''
	When give params for the operation, set the internal arrays
	to match the params.
	Params:
		- param a: must be set
		- param b: optionally can be set
	'''
	func set_params(param_a: CardTargetParam, param_b: CardTargetParam = null):
		operation_handler.set_params(self, param_a, param_b)
