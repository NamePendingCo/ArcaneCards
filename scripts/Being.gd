class_name Being extends Actor

signal health_depleted

var being_name: String

#backdoor in case we ever need to handle health below zero
var _health: int
#main health variable. Can't go below 0
var health = _health:
	set(val): 
		_health = max(0, val)
		health_depleted.emit()

var attack_strength: int

func _ready():
	add_to_group(Constants.GROUP_BEING)
	
	#silly base values, maybe change eventually
	health = 40
	attack_strength = 1

func take_damage(dmg: int):
	health -= dmg

#TODO convert to an event
func attack_being(target: Being):
	target.take_damage(attack_strength)
