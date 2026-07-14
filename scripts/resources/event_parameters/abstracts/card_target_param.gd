@abstract
class_name CardTargetParam extends TargetParam

var registerd_cards: Dictionary[Card, bool] = {}

var targets_range: Array[Card]:
	get: return targets_range
	set(val):
		targets_range = val
		_targets_range = val
		for card in targets_range:
			_register_card(card)

#The actual chosen targets
var targets: Array[Card]:
	get: return targets
	set(val):
		targets = val
		_targets = val
		for card in targets:
			_register_card(card)

func _register_card(card: Card):
	if not registerd_cards.has(card):
			card.marked_to_destroy.connect(_remove_from_lists.bind(card), CONNECT_ONE_SHOT)
			registerd_cards[card] = true
