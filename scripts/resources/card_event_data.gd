@tool
class_name CardEventData extends EventData

'''
Wrapper for a collection of events and params, specifically for
a card.
'''

#fixed keys for event dict
const ACTIVATION_KEY = "onActivation"
const CAST_KEY = "onCast"
const DISCARD_KEY = "onDiscard"

func _init():
	# if one doesn't exist, create an empty event for activation if 
	# opened in editor, as most cards will need it
	if Engine.is_editor_hint():
		events.get_or_add(ACTIVATION_KEY, UnsignaledEvent.new())
