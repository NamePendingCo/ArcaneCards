class_name Enums extends Node

enum SpellColor { ## Defines a spell card's color/domain.
	NULL = 0, ## No color is set
	RED = 1, ## Red spells.
	ORANGE = 2, ## Orange spells.
	YELLOW = 3, ## Yellow spells.
	GREEN = 4, ## Green spells.
	BLUE = 5, ## Blue spells.
	PURPLE = 6 ## Purple spells.
}

#Convert color to a string format
static func colorString(color: SpellColor):
	return String(SpellColor.keys()[color]).to_pascal_case()

enum Subdomain { ## A spell card's subdomain.
	NULL = 0, ## Unset subdomain. 
	
	#Red
	HEAT = 11, ## Fire themed red spells.
	FREEZE = 12, ## Ice themed red spells.
	LIGHTNING = 13, ## Lightning themed red spells.
	
	#Orange
	CHEMICAL = 21, ## Chemical themed orange spells.
	TRANSMUTATION = 22, ## Matter changing themed orange spells.
	CONJURATION = 23, ## Summoning/creation themed orange spells.
	
	#Yellow
	IMPACT = 31, ## TBD themed yellow spells.
	THRUST = 32, ## TBD themed yellow spells.
	VIBRATION = 33, ## TBD themed yellow spells.
	GRIP = 34, ## TBD themed yellow spells.
	
	#Green
	GROWTH = 41, ## Size increasing themed green spells.
	DRAINING = 42, ## Energy sapping themed green spells.
	RELEASE = 43, ## Energy expulsion themed green spells.
	ANIMATION = 44, ## Living being movement themed green spells.
	
	#Blue
	TELEPATHY = 51, ## Mind reading themed blue spells.
	SANITY = 52, ## Direct damaging blue spells.
	DOMINATION = 53, ## Mind controlling themed blue spells.
	ILLUSION = 54, ## Deception/card trick themed blue spells.
	
	#Purple
	SOUL = 61, ## Manipulating own mana themed purple spells.
	DIVINATION = 62, ## Future sight themed purple spells.
	CHANNELING = 63 ## Divine/otherly being themed purple spells.
}

#Convert subdomain to a string format
static func subdomainString(subdomain: Subdomain):
	return String(Subdomain.keys()[Subdomain.keys().find(subdomain)]).to_pascal_case()

enum CardType { ## The type of card this is.
	NULL, ## Card Type is unset.
	INSTANT, ## Non-concentration spells.
	ENCHANTMENT, ## Buffing concentration spells.
	WARD, ## Defensive concentration spells.
	CURSE, ## Hostile concentratio spells.
	COMPONENT ## Components cards.
}

## Array of all concentration card types.
const CONC_TYPES = [CardType.ENCHANTMENT, CardType.WARD, CardType.CURSE]

#Convert type to a string format
static func typeString(type: CardType):
	return String(CardType.keys()[CardType.keys().find(type)]).to_pascal_case()
