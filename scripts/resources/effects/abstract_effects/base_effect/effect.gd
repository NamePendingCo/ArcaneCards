@abstract
class_name Effect extends Node

#signal effect_running #Notify when this effect is about to run

const EffectID = EffectsEnum.EffectID

#The internal id name of the effect type. Effectively a constant
var effect_id: EffectID:
	get: return _get_effect_id()
	set(val): return

var modifiers: Array[EffectOperator]

#================================================
# Private vars
#================================================

@export var _val: int:
	set(new_val): _val = clamp(new_val, _min_val, _max_val)

#Minimum allowed value for the effect
#also used for ranges when making comparisons
@export var _min_val: int = 0:
	set(new_val): _min_val = max(new_val, 0)

#Maximum allowed value for the effect
#also used for ranges when making comparisons
@export var _max_val: int = INT32_MAX:
	set(new_val): _max_val = max(_min_val, INT32_MAX)

#================================================
# General methods
#================================================

#func _init(val: int, min_val: int = 0, max_val: int = INT32_MAX):
	#_min_val = min_val
	#_max_val = max_val
	#_val = val

#================================================
# Public methods
#================================================

func set_values(val: int, min_val: int = 0, max_val: int = INT32_MAX):
	_min_val = min_val
	_max_val = max_val
	_val = val

func get_base_val():
	return _val

'''
Gets all the parameters for an effect as a dictionary
'''
func get_params() -> Dictionary[String, EventParam]:
	return {}

'''
Sets all the params for an effect based on a dictionary
'''
func set_params(params: Dictionary[String, EventParam]):
	pass

'''
Takes the val, applies all modifiers to it, then return it.
'''
func get_final_val():
	var final_val = _val
	
	for mod in modifiers:
		final_val = max(mod.apply_op(final_val), 0)
	
	return final_val

@abstract
func run()

#================================================
# Private methods
#================================================

#Should return a constant for each
@abstract
func _get_effect_id() -> EffectID
