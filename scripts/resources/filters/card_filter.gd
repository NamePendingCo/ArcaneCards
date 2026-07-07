'''
This represents a condensed form of card data which can be
used to make comparisons about a card more swiftly than
just using the data. It is a mask so if a variable isn't used
it can be ignored
'''
@tool
class_name CardFilter extends Resource

#Colors to filter, set with flags
var _colors: int:
	set(val):
		_colors = val
		colors = EventEnums.flagIntToEnum(val)
		print(colors)
var colors: Array[Enums.SpellColor]

#Subdomains to filter, set with flags
var _subdomains: int:
	set(val):
		_subdomains = val
		subdomains = EventEnums.flagIntToEnum(val, Enums.Subdomain)
		print(subdomains)
var subdomains: Array[Enums.Subdomain]

#Types to filter, set with flags
var _types: int:
	set(val):
		_types = val
		types = EventEnums.flagIntToEnum(val)
var types: Array[Enums.CardType]

#Tiers to filter, set with flags
var _tiers: int:
	set(val):
		_tiers = val
		tiers = EventEnums.flagIntToEnum(val)
var tiers: Array[int]

#could do activation cost and upkeep but for now we don't
#need it so like. Why bother.

#TODO: Add flags

func _ready():
	colors = []
	subdomains = []
	types = []
	tiers = []

#================================================
# Public functions
#================================================

'''
Checks if a card matches the parameters of the filter.
Params:
	- card: a Card
Returns: true if matches, false if not
'''
func card_valid(card: Card) -> bool:
	var data = card.card_data
	
	#check colors
	if not (colors.is_empty() or data.color in colors):
		return false
	
	#check subdomains
	if not (subdomains.is_empty() or data.subdomain in subdomains):
		return false
	
	#check types
	if not (types.is_empty() or data.type in types):
		return false
	
	#check tiers
	if not (tiers.is_empty() or data.tier in tiers):
		return false
	
	return true

#================================================
# Private functions
#================================================

func _validate_property(property):
	if property.name == "_colors":
		EventEnums.enumFlagProperty(property, \
		EventEnums.enumToFlags(Enums.SpellColor, [Enums.SpellColor.NULL]))
	elif property.name == "_subdomains":
		EventEnums.enumFlagProperty(property, \
		EventEnums.enumToFlags(Enums.Subdomain, [Enums.Subdomain.NULL]))
	elif property.name == "_types":
		EventEnums.enumFlagProperty(property, \
		EventEnums.enumToFlags(Enums.CardType, [Enums.CardType.NULL]))
	elif property.name == "_tiers":
		EventEnums.enumFlagProperty(property, EventEnums.enumToFlags({1:1, 2:2, 3:3}))
