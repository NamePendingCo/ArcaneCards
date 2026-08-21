@tool
class_name BeingTargetOperationParam extends BeingTargetParam

const SET_OPS = TargetOperationHandler.SetOperations

@export
var operation_handler: TargetOperationHandler = TargetOperationHandler.new()

func update_range():
	targets_range = operation_handler.range

'''
When give params for the operation, set the internal arrays
to match the params.
Params:
	- param a: must be set
	- param b: optionally can be set
'''
func set_params(param_a: BeingTargetParam, param_b: BeingTargetParam = null):
	operation_handler.set_params(self, param_a, param_b)

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
