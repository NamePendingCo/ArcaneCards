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

@export var _event_scene: Event #Event scene to duplicate
var packed_event: PackedScene #A packed scene used to load the event

@export var params_to_update: Array[EventParam] #Params updated when event runs

#An array and dictionary used to repopulate effect params, which are lost
#during instantiation
var effect_params: Array[Dictionary]

#Owners of the events
var actor: Actor = null
var parent_card: Card = null

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

func _init(event: Event, params: Array[EventParam], my_actor: Actor = null, card: Card = null):
	actor = my_actor
	parent_card = card
	_event_scene = event
	params_to_update = params
	add_child(event)

func _ready():
	
	effect_params = []
	
	for effect in _event_scene.effects:
		effect_params.append(effect.get_params())
	
	packed_event = PackedScene.new()
	
	var res = packed_event.pack(_event_scene)
	
	_event_scene.queue_free()
	print("Launcher ready")
	

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
	
	var event = packed_event.instantiate() as Event
	event.params_to_update = params_to_update
	_repopulate_params(event)
	add_child(event)
	active_events.append(event)
	event_triggered.emit(event)
	
	print("Event is active")
	
	print(event.effects)
	print(event.params_to_update)

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

'''
Very silly helper function that is used by an effect launcher
'''
func _repopulate_params(event: Event):
	var event_effects = event.effects
	
	for i in range(mini(effect_params.size(), event_effects.size())):
		var param_list: Dictionary[String, EventParam] = effect_params[i]
		var effect = event_effects[i]
		
		effect.set_params(param_list)
