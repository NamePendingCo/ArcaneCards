class_name EventsWrapper extends Node

## Wrapper for a collection of events and parameters. Useful for
## attaching to cards and beings.

## The list of event launchers in this event set.
@export var event_launchers: Dictionary[String, EventLauncher]

## The list of parameters in this event set.
@export var parameters: Dictionary[String, EventParam]

static func new_events_wrapper(launchers: Dictionary[String, EventLauncher], params: Dictionary[String, EventParam])\
 -> EventsWrapper:
	var wrapper = EventsWrapper.new()
	wrapper.event_launchers = launchers
	wrapper.parameters = params
	
	for key in wrapper.event_launchers:
		var launcher = wrapper.event_launchers[key]
		wrapper.add_child(launcher)
		
	for key in wrapper.parameters:
		var param = wrapper.parameters[key]
		wrapper.add_child(param)
	
	return wrapper

## Sets the actor that owns the events.
func set_actor(actor: Actor):
	for key in event_launchers:
		var launcher = event_launchers[key]
		launcher.actor = actor
		
	for key in parameters:
		var param = parameters[key]
		param.actor = actor

## Sets the card that owns these
func set_card(card: Card):
	for key in event_launchers:
		var launcher = event_launchers[key]
		launcher.actor = card.card_caster
		launcher.parent_card = card
		
	for key in parameters:
		var param = parameters[key]
		param.actor = card.card_caster
		param.parent_card = card

## Activates all effect launchers attached to the wrapper.
func activate_all():
	for event_name in event_launchers:
		event_launchers[event_name].launcher_state = EventLauncher.EventLauncherState.ACTIVE


## Deactivates all effect launchers attached to the wrapper.
func deactivate_all():
	for event_name in event_launchers:
		event_launchers[event_name].launcher_state = EventLauncher.EventLauncherState.INACTIVE
