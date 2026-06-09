'''
This represents a condensed form of card data which can be
used to make comparisons about a card more swiftly than
just using the data. It is a mask so if a variable isn't used
it can be ignored
'''

class_name CardFilter extends Resource

var colors: Array[Enums.SpellColor]
var subdomains: Array[Enums.Subdomain]
var types: Array[Enums.CardType]
var tiers: Array[int]

#could do activation cost and upkeep but for now we don't
#need it so like. Why bother.

#TODO: Add flags

func _ready():
	colors = []
	subdomains = []
	types = []
	tiers = []

'''
Checks if a card matches the parameters of the filter.
Params:
	- card: a Card
Returns: true if matches, false if not
'''
func check_card(card: Card) -> bool:
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
