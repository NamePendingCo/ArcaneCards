class_name CardDict extends Node

'''
Stores the dictionary of all card data to be easily accessed.
'''

const SPELL_DIR_PATH = "res://cards/card_list/spells/"

var fail_card_data: CardData

var card_db: Dictionary[String, CardData] = {}

func _ready():
	
	fail_card_data = CardData.new()
	fail_card_data.event_data = CardEventData.new()
	fail_card_data.card_id = "null"
	fail_card_data.cardName = "No Data Found"
	
	_load_spell_cards()
	
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

'''
Loads all spell cards in the spell folder. Loops through each directory and subdirectory
and then loads each card until they are all loaded.
'''
func _load_spell_cards():
	#Creates a queue for all directories to search through
	var directory_queue: Array[String] = []
	directory_queue.push_back(SPELL_DIR_PATH)
	
	var dir_path: String = ''
	var card_data: CardData
	
	# Loop through the queue until empty
	while not directory_queue.is_empty():
		
		dir_path = directory_queue.pop_back()
		var directory_contents: PackedStringArray = ResourceLoader.list_directory(dir_path)
		
		for filename in directory_contents:
			if filename.ends_with('/'):
				directory_queue.push_back(dir_path + filename)
				#If directory found, add to queue
			elif filename.ends_with('.tres'):
				card_data = load(dir_path + filename)
				card_db[card_data.card_id] = card_data
				#If non-directory found, should be card data
