class_name CustomEnumParamResource extends EnumParamResource

@export
var options: Array[String]

func build_param(actor: Actor, card: Card) -> EventParam:
	
	return CustomEnumParam.new(actor, card, options)

func _validate_property(property: Dictionary) -> void:
	if property.name == "is_chosen":
		_set_property_visibility(property, false)

class CustomEnumParam extends EnumParam:
	
	var options: Array[String]
	
	func _init(actor: Actor, card: Card, values: Array[String]):
		super(actor, card, true)
		options = values
