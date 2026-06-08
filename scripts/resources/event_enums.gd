class_name EventEnums extends Node

#BELOW HERE IS BIT BASED BUT ONLY USED AS ENUM BY USER

enum BeingRangeOption {
	NULL = 0, # Use this if there should be a target, but it will be set with an event
	SELF = 1 << 0,
	ALL_OTHERS = 1 << 1, #All other beings on field
	EVERYONE = SELF ^ ALL_OTHERS, #All beings including self
}

#TODO Set to match Card State
enum CardRangeOption {
	NULL = 0,
	HAND = 1 << 0,
	CASTING_WELL = 1 << 1, #From the casting well
	CONCENTRATION_CIRCLE = 1 << 2,
	WHOLE_FIELD = HAND ^ CASTING_WELL ^ CONCENTRATION_CIRCLE, #grabs bits from each location
}

#BELOW HERE IS USED AS FLAGS

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

static func getExportEnumVals(enum_list: Dictionary):
	var key_val = []
	
	var keys = enum_list.keys()
	var vals = enum_list.values()
	for i in enum_list.size():
		key_val.append(str(keys[i]) + ':' + str(vals[i]))
	
	return key_val
