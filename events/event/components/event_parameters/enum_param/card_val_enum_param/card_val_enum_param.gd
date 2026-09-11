@abstract
class_name CardValEnumParam extends EnumParam

var card_param: CardTargetParam

@abstract
func _get_value_from_card(card: Card) -> int

func _set_from_cards():
	for card in card_param.targets:
		_set_keyed_value(card.name, _get_value_from_card(card))
