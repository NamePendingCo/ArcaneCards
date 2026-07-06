class_name UnsignaledEvent extends Event

'''
For all events that do not connect to a direct signal. Usually things
triggered directly by the parent card. This includes Activation, Discard,
Cast, etc. Super useful stuff.
'''

func _init():
	is_invocation = true

func _activate_event():
	pass

func _deactivate_event():
	pass
