@abstract
class_name Effect extends Resource

#signal effect_running #Notify when this effect is about to run

const EffectID = EffectsEnum.EffectID

@export var _val: int:
	set(new_val): _val = clamp(new_val, _min_val, _max_val)

#The internal id name of the effect type. Effectively a constant
var effect_id: EffectID:
	get: return _get_effect_id()
	set(val): return

var modifiers: Array[EffectOperator]

#================================================
# Private vars
#================================================

var _num_parent_effects: int = 0

#Minimum allowed value for the effect
#also used for ranges when making comparisons
var _min_val: int:
	set(new_val): _val = max(new_val, 0)

#Maximum allowed value for the effect
#also used for ranges when making comparisons
var _max_val: int:
	set(new_val): _val = max(_min_val, Constants.INT_MAX)

#================================================
# Public methods
#================================================

func get_base_val():
	return _val

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
