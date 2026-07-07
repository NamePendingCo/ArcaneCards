class_name BeingFilter extends Resource

@export
var min_health: int = 0:
	set(val): max(val, 0)

@export
var max_health: int = 0:
	set(val): clamp(val, min_health, Constants.INT_MAX)

#TODO
func check_being(being: Being) -> bool:
	if (being.health < min_health) or (being.health > max_health):
		return false
	
	return true
