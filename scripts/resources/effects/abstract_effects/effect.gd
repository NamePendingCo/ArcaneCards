@tool
@abstract
class_name Effect extends Resource

#The internal id name of the effect 
var effect_id: String

#Minimum allowed value for the effect
#also used for ranges when making comparisons
var _min_val: int:
	set(new_val): _val = max(new_val, 0)

#Maximum allowed value for the effect
#also used for ranges when making comparisons
var _max_val: int:
	set(new_val): _val = max(_min_val, Constants.INT_MAX)

@export var _val: int:
	set(new_val): _val = clamp(new_val, _min_val, _max_val)

var modifiers: Array[EffectOperator]

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
