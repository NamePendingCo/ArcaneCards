class_name EffectOperator extends Resource

enum OpType {
	ADDITION,
	SUBTRACTION,
	MULTIPLICATION,
	DIVISION
}

@export
var op: OpType

@export
var val: int

'''
Takes a number and returns it modified by the operation.
Params:
	- to_mod: the int value to apply the mod to
Returns:
	- the modified value
'''
func apply_op(to_mod: int):
	match op:
		OpType.ADDITION: return to_mod + val
		OpType.SUBTRACTION: return to_mod - val
		OpType.MULTIPLICATION: return to_mod * val
		OpType.DIVISION: return int(to_mod / val)
