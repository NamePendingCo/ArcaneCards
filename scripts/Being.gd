@abstract
class_name Being extends Actor

signal health_updated(new_val)

signal health_depleted

var being_name: String

#backdoor in case we ever need to handle health below zero
var _health: int
#main health variable. Can't go below 0
var health = _health:
	get: return _health
	set(val):
		print("old health: %d" % _health) 
		print("change val: %d" % val)
		_health = max(0, val)
		health_updated.emit(_health)
		print("new health: %d" % _health)
		health_depleted.emit()

var attack_strength: int

func _ready():
	add_to_group(Constants.GROUP_BEING)
	
	#silly base values, maybe change eventually
	health = 40
	attack_strength = 1

@abstract
func on_game_start()

func take_damage(dmg: int):
	health -= dmg

func heal(health_regen: int):
	health += health_regen

#TODO convert to an event
func attack_being(target: Being):
	target.take_damage(attack_strength)

'''
Might unabstract later. But this is to allow for any being to make decisions
in this phase, so non-casters can choose to attack and such.
'''
@abstract
func make_casting_phase_decisions()

'''
Reveals all decisions made during casting phase, such as who the being is 
attacking or, if a caster, what they cast.
'''
@abstract
func reveal_casting_phase_decisions()
