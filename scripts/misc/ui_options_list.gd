class_name UIOptionsList extends ItemList

signal option_chosen(index)
signal option_unchosen(index)

@onready var ui_selected_items: ItemList = $"../SelectedItems"

#Two dictionaries for converting indices between each list
var _selected_to_option: Dictionary[int, int] = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	multi_selected.connect(_on_item_toggled)
	ui_selected_items.item_activated.connect(_unselect_via_selection_list)

'''
Params:
	- Option index: the index from the option list toggled
	- selected: whether it was selected or deselected
'''
func _on_item_toggled(option_index: int, selected: bool):	
	if selected:
		_add_ui_selected_item(option_index)
	else:
		_reset_ui_selected_list_items()

'''
Adds an item to the UI for selected items, as well as adds to the 
conversion dictionary
'''
func _add_ui_selected_item(index):
	ui_selected_items.add_item(get_item_text(index))
	_selected_to_option[ui_selected_items.item_count]

'''
Reset the items in the selection_list
'''
func _reset_ui_selected_list_items():
	var selections = get_selected_items()
	
	#reset list so it can be repopulated
	ui_selected_items.clear()
	
	#reset mapping dictionary
	_selected_to_option.clear()
	
	for index in selections:
		_add_ui_selected_item(index)

'''
Allows for handling when the item in the selection list is double clicked
'''
func _unselect_via_selection_list(selection_index: int):
	var option_index = _selected_to_option[selection_index]
	
	deselect(option_index)
	multi_selected.emit(option_index, false)
