class_name EventEnums extends Node

# All secondary triggers. Uses bitwise indexing for use as flags
enum BonusTriggers {
	NONE = 0,
	EMPOWER = 1 << 0,
	HEIGHTEN = 1 << 1,
	EXERT = 1 << 2,
	UPCAST = 1 << 3,
	CHAIN = 1 << 4,
	RESONANCE = 1 << 5,
	SYNERGIZE = 1 << 6
}

static func getEnumVals(enum_list: Dictionary):
	var key_val = []
	
	var keys = enum_list.keys()
	var vals = enum_list.values()
	for i in enum_list.size():
		key_val.append(str(keys[i]) + ':' + str(vals[i]))
	
	return key_val
