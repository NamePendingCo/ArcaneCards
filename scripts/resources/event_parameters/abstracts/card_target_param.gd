@abstract
class_name CardTargetParam extends TargetParam

var registerd_cards: Dictionary[Card, bool] = {}

var targets_range: Array[Card] = []:
	get = _get_targets_range, set = _set_targets_range

#The actual chosen targets
var targets: Array[Card] = []:
	get = _get_targets, set = _set_targets

func _get_targets():
	return targets

func _get_targets_range():
	return targets_range

func _set_targets(arr: Array[Card]):
	targets.assign(arr)
	for card in targets:
		_register_card(card)
	super(arr)

func _set_targets_range(arr: Array[Card]):
	targets_range.assign(arr)
	for card in targets_range:
		_register_card(card)
	super(arr)

func _register_card(card: Card):
	if not registerd_cards.has(card):
			card.marked_to_destroy.connect(_remove_from_lists.bind(card), CONNECT_ONE_SHOT)
			registerd_cards[card] = true
