@abstract
class_name EffectResource extends Resource

#signal effect_running #Notify when this effect is about to run

const EffectID = EffectsEnum.EffectID

@export var _val: int:
	set(new_val): _val = clamp(new_val, _min_val, _max_val)

#The internal id name of the effect type. Effectively a constant
var effect_id: EffectID:
	get: return _get_effect_id()
	set(val): return

#================================================
# Private vars
#================================================

#Minimum allowed value for the effect
#also used for ranges when making comparisons
@export
var _min_val: int = 0:
	set(new_val): _min_val = max(new_val, 0)

#Maximum allowed value for the effect
#also used for ranges when making comparisons
@export
var _max_val: int = INT32_MAX:
	set(new_val): _max_val = max(_min_val, INT32_MAX)

#================================================
# Public methods
#================================================

'''
Builds the effect associated with this resource.
Params:
	- param: A dictionary of parameters to match with the effect's needed
	parameter values
Returns:
	- a new effect
'''
func build_effect(params: Dictionary[String, EventParam]) -> Effect:
	var effect = _new_effect()
	_populate_effect_vals(effect)
	populate_params(effect, params)
	
	return effect

'''
Abstract helper function that populates the effects' needed parameters
from a dictionary. Can be called outside to populate a matching effect
that was built outside this resource, if needed.
- param: A dictionary of parameters to match with the effect's needed
	parameter values
'''
@abstract
func populate_params(effect: Effect, params: Dictionary[String, EventParam]);

'''
Abstract function to get the list of parameter names of a specific effect
that map to the internal variable names.
Returns:
	- The list parameters in a dictionary mapped to the set names
'''
@abstract
func get_effect_parameters() -> Dictionary[String, String];

#================================================
# Private methods
#================================================

'''
Abstract function to create a new effect. Overriden by each individual
effect in order to allow for each resource to built the right effect
'''
@abstract
func _new_effect() -> Effect;

'''
Helper function. When given an effect, sets its values to the defaults
on the resource.
'''
func _populate_effect_vals(effect: Effect):
	effect.set_values(_val, _min_val, _max_val)

#Should return a constant for each
@abstract
func _get_effect_id() -> EffectID
