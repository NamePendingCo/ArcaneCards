@tool
class_name BeingTargetOperationResource extends BeingTargetResource

const SetOperation = TargetOperationHandler.SetOperation

@export
var operation: SetOperation:
	set(val):
		operation = val
		notify_property_list_changed()

@export
var param_a_name: String 

@export
var param_b_name: String

func build_param():
	var param = BeingTargetOperationParam.new(operation, is_chosen, 
	num_targets_min, num_targets_max, persistent)
	
	#Saves param so it can be populated later
	unfinished_params.append(param)
	return param

#OVERRIDES
func complete_unfinished_params(params_dict: Dictionary[String, EventParam]):
	while not unfinished_params.is_empty():
		var param = unfinished_params.pop_back() as BeingTargetOperationParam
		
		param.set_params(params_dict[param_a_name], params_dict[param_b_name])

func _validate_property(property: Dictionary) -> void:
	if property.name == "is_chosen":
		# Chosen only shown if range isn't null or self, or for Operations
		_set_property_visibility(property, true)
	elif property.name == "num_targets_min" \
	or property.name == "num_targets_max":
		_set_property_visibility(property, is_chosen)
	elif property.name == "persistent":
		_set_property_visibility(property, true)
	elif property.name == "param_b_name":
		_set_property_visibility(property, \
		(operation not in [SetOperation.IDENTITY, SetOperation.INVERT_RANGE]))

class BeingTargetOperationParam extends BeingTargetParam:

	const SetOperation = TargetOperationHandler.SetOperation

	var operation_handler: TargetOperationHandler

	'''
	When give params for the operation, set the internal arrays
	to match the params.
	Params:
		- param a: must be set
		- param b: optionally can be set
	'''
	func _init(set_op: SetOperation, chosen: bool, 
	targets_min: int = 1, targets_max: int = 1, persist=false):
		super(chosen, targets_min, targets_max, persist)

	func set_params(param_a: BeingTargetParam, param_b: BeingTargetParam = null):
		operation_handler.set_params(self, param_a, param_b)

	func update_range():
		targets_range = operation_handler.range
