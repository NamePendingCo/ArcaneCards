class_name Being extends Node

var being_name: String

#backdoor in case we ever need to handle health below zero
var _health: int
#main health variable. Can't go below 0
var health = _health:
	get: _health
	set(val): _health = max(0, val)

var attack_strength: int

func _ready():
	#silly base values, maybe change eventually
	health = 40
	attack_strength = 1

func take_damage(dmg: int):
	health -= dmg

func attack_being(target: Being):
	target.take_damage(attack_strength)
