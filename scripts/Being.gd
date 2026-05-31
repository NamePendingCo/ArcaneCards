class_name Being extends Node

var being_name: String
var health: int
var attack_strength: int

func take_damage(dmg: int):
	health -= dmg

func attack_being(target: Being):
	target.take_damage(attack_strength)
