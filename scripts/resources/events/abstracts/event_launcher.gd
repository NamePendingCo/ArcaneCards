class_name EventLauncher extends Node

'''
EventLaunchers are factories that create Events to be added to the
stack. They each hold template information that creates the event
and then "launch" it when the time comes.
'''

signal event_activated #When the event is enabled
signal event_triggered(event) #emited when the event is successfully triggered

enum EventLauncherState {
	INACTIVE = 0,
	ACTIVE = 1,
	SUPRESSED = 2
}

#The entity making the event occur
var actor: Actor = null

#A packed scene used to load the event
var packed_event: PackedScene

# list of events from this launcher in play.
# right now, these are not deleted when event is freed. TODO
var active_events: Array[Event] = []

# When true, this event is treated as a regular game
# driven event and not an action triggered during play.
var is_system_event: bool = false
# Whether this event should count as an invocation for its card
var is_invocation: bool = true

#Tracks the current state of the event launcher
var launcher_state: EventLauncherState:
	set(val):
		if launcher_state == val:
			#return if event doesn't change
			return
			
		launcher_state = val
		
		match launcher_state:
			EventLauncherState.INACTIVE:
				_deactivate_event()
			EventLauncherState.ACTIVE:
				_activate_event()
			EventLauncherState.SUPRESSED:
				_suppress_event()

func _init(event: Event):
	packed_event = PackedScene.new()
	
	packed_event.pack(event)

#================================================
# Public methods
#================================================

'''
Usually connected with a signal. When called, signals to the battle_manager
to be added to the event stack.
'''
func trigger():
	print("Triggered Event %s for %s which is %s" % [self, actor.name, EventLauncherState.keys()[launcher_state]])
	#Only can trigger if active
	
	if launcher_state != EventLauncherState.ACTIVE:
		#Does nothing if event is not active
		return
		
	print("Event is active")
	
	var event: Event = packed_event.instantiate()
	active_events.append(event)
	event_triggered.emit(event)

#================================================
# Private methods
#================================================

#In case its necessary--run when set to active
func _activate_event():
	event_activated.emit()

#In case its necessary--run when set to inactive (but not suppressed)
func _deactivate_event():
	pass

#In case its necessary--run when set to suppressed
func _suppress_event():
	pass
