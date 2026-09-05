@tool
@abstract
class_name ListeningEventResource extends EventResource

'''
This is an abstract class to cover all events that occur
upon a signal instead of a direct internal trigger.
'''

#If true, this event runs after the event that triggered it
@export var isRunAfter: bool = false:
	set(val):
		isRunAfter = val
		notify_property_list_changed()
