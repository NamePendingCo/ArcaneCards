class_name CardDict extends Node

var fail_card_data: CardData

var card_db: Dictionary[String, CardData] = {}

func _ready():
	#TODO autopopulate from csv file
	
	fail_card_data = CardData.new()
	fail_card_data.card_id = "null"
	fail_card_data.cardName = "No Data Found"
	
'''
Gets the card_data for a card based on a string
Params: 
	- card_id: the internal id for a card
Return:
	- card_data: the data for that card
'''
func get_card_data(card_id: String):
	if card_id in card_db:
		return card_db[card_id]
	else:
		return fail_card_data
