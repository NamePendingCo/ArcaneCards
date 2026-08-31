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
