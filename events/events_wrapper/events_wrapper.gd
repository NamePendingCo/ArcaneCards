class_name EventsWrapper extends Node

'''
Wrapper for a collection of events and parameters. Useful for
attaching to cards and beings.
'''

var event_launchers: Dictionary[String, EventLauncher]
var parameters: Dictionary[String, EventParam]

func _init(launchers: Dictionary[String, EventLauncher], params: Dictionary[String, EventParam]):
	event_launchers = launchers
	parameters = params
	
	for key in event_launchers:
		var launcher = event_launchers[key]
		add_child(launcher)
		
	for key in parameters:
		var param = parameters[key]
		add_child(param)

'''
Sets the actor that owns these
'''
func set_actor(actor: Actor):
	for key in event_launchers:
		var launcher = event_launchers[key]
		launcher.actor = actor
		
	for key in parameters:
		var param = parameters[key]
		param.actor = actor

'''
Sets the card that owns these
'''
func set_card(card: Card):
	for key in event_launchers:
		var launcher = event_launchers[key]
		launcher.actor = card.card_caster
		launcher.parent_card = card
		
	for key in parameters:
		var param = parameters[key]
		param.actor = card.card_caster
		param.parent_card = card

'''
Activates all effect launchers attached to the wrapper.
'''
func activate_all():
	for event_name in event_launchers:
		event_launchers[event_name].launcher_state = EventLauncher.EventLauncherState.ACTIVE

'''
Deactivates all effect launchers attached to the wrapper.
'''
func deactivate_all():
	for event_name in event_launchers:
		event_launchers[event_name].launcher_state = EventLauncher.EventLauncherState.INACTIVE
