class_name Enums extends Node

enum SpellColor {
	NULL = 0,
	RED = 1,
	ORANGE = 2,
	YELLOW = 3,
	GREEN = 4,
	BLUE = 5,
	PURPLE = 6
}

#Convert color to a string format
static func colorString(color: SpellColor):
	return String(SpellColor.keys()[color]).to_pascal_case()

enum Subdomain {
	NULL = 0, 
	
	#Red
	HEAT = 11, 
	FREEZE = 12,
	LIGHTNING = 13,
	CHEMICAL = 21, 
	
	#Orange
	TRANSMUTATION = 22,
	CONJURATION = 23,
	IMPACT = 31, 
	
	#Yellow
	THRUST = 32,
	VIBRATION = 33,
	GRIP = 34,
	GROWTH = 41, 
	
	#Green
	DRAINING = 42,
	RELEASE = 43,
	ANIMATION = 44,
	TELEPATHY = 51, 
	
	#Blue
	SANITY = 52,
	DOMINATION = 53,
	ILUSION = 54,
	
	#Purple
	SOUL = 61, 
	DIVINATION = 62,
	CHANNELING = 63
}

#Convert subdomain to a string format
static func subdomainString(subdomain: Subdomain):
	return String(Subdomain.keys()[subdomain]).to_pascal_case()

enum CardType {
	NULL,
	INSTANT,
	ENCHANTMENT,
	WARD,
	CURSE,
	COMPONENT
}

#Convert type to a string format
static func typeString(type: CardType):
	return String(CardType.keys()[type]).to_pascal_case()
