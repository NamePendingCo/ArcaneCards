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

'''
Takes a flag int and converts it into an array of enum values.
'''
static func flagIntToEnum(value: int, enum_list: Dictionary={}):
	var vals: Array[int] = []
	var place_counter: int = 1
	if not enum_list.is_empty() and (enum_list.values()[0] == 0):
		place_counter = 0
	while value > 0:
		if value & 1 == 1: #if has a 1 in this place, add to list
			if enum_list.is_empty():
				vals.append(place_counter)
			else:
				vals.append(enum_list.values()[place_counter])
		value >>= 1 #shift to the right
		place_counter += 1
	return vals

'''
This is a very crazy way to convert a regular enum_list to a flagged enum list.
It basically left shifts every single entry that isn't 0 by the enum value. It
also supports adding values that are combinations of two.
Params:
	-enum_list: an enum type
	-ignore_list: an array of values from the enum to ignore
	-shortcuts: A dictionary of keys of strings with an array of values from the Enum
	being flagified 
Example: 
	enum_list=CardState
	shortcuts: {"FIELD": [CardState.HAND, CardState.CASTING_WELL, CardState.CONCENTRATION_CIRCLE]}
Returns:
	- a dict of flags
'''
static func enumToFlags(enum_list: Dictionary, ignore_list: Array=[], shortcuts: Dictionary[String, Array]={}):
	var new_dict: Dictionary = {}
	var count = 0 #use this to avoid shifting by arbitrary size
	
	for key in enum_list:
		if enum_list[key] in ignore_list:
			continue
		elif enum_list[key] == 0:
			new_dict[key] = 0
		else:
			new_dict[key] = 1 << count
		count += 1
	
	for key in shortcuts:
		new_dict[key] = 0
		for entry in shortcuts[key]:
			new_dict[key] += 1 << entry
	
	return new_dict

#TODO As soon as we upgrade to Godot 4.7, we can replace the default end value with INT32_MAX but until then it doesn't exist
'''
Takes an enum dict and returns a hint string that can be used for an export
for a property. Useful for creating interface for internal design
Params:
	- enum_list: a dictionary, ideally an enum dict
	- asFlags: If true, will instead make the value equal to 1 left shifted
	equal to n - 1 where n is the value of the entry. This allows the enum to
	be used as a flag export, allowing multi-selection
	- start: optional, index to start from
	- end: optional, idnex to end at
Returns:
	- The evals as a hint string
'''
static func getEnumValsHintString(enum_list: Dictionary, start=0, end=2147483647):
	var key_val = []
	
	var keys = enum_list.keys()
	var vals = enum_list.values()
	
	for i in enum_list.size():
		key_val.append(str(keys[i]) + ':' + str(vals[i]))
	
	return ",".join(key_val.slice(start, end))

static func enumFlagProperty(property: Dictionary, enum_list: Dictionary, start=0, end=2147483647):
	property.usage ^= PROPERTY_USAGE_EDITOR
	property.hint = PROPERTY_HINT_FLAGS
	property.hint_string = EventEnums.getEnumValsHintString(enum_list, start, end)
