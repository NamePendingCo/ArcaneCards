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
	set(new_val): _val = max(new_val, 0)

#Maximum allowed value for the effect
#also used for ranges when making comparisons
@export
var _max_val: int = INT32_MAX:
	set(new_val): _val = max(_min_val, INT32_MAX)

#================================================
# Public methods
#================================================

func build_effect(params: Dictionary[String, EventParam]) -> Effect:
	var effect = _new_effect()
	_populate_effect_vals(effect)
	populate_params(effect, params)
	
	return effect

@abstract
func populate_params(effect: Effect, params: Dictionary[String, EventParam]);

@abstract
func get_effect_parameters() -> Dictionary[String, String];

#================================================
# Private methods
#================================================

@abstract
func _new_effect() -> Effect;

func _populate_effect_vals(effect: Effect):
	effect.set_values(_val, _min_val, _max_val)

#Should return a constant for each
@abstract
func _get_effect_id() -> EffectID
