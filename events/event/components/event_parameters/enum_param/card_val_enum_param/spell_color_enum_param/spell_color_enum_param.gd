class_name SpellColorEnumParamResource extends CardValEnumParamResource
## Defines a [member SpellColorEnumParam] which tracks a spell card's
## color.
## 
##

## The default value for the spell color this enum param holds.
@export var value: Enums.SpellColor

func build_param(actor: Actor, card: Card) -> EventParam:
	return SpellColorEnumParam.new(actor, card, is_chosen)

## An [EnumParam] for tracking a spell card's color.
class SpellColorEnumParam extends CardValEnumParam:
	
	## The default value for the spell color this enum param holds
	var value: Enums.SpellColor:
		get(): return _value
		set(val): _value = val
	
	func _get_value_from_card(card: Card):
		return card.card_data.color
