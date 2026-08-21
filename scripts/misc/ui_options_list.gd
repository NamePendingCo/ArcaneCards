class_name UIOptionsList extends ItemList

@onready var ui_selected_items: ItemList = $"../SelectedItems"

signal item_updated(index, chosen)

#Two dictionaries for converting indices between each list
var _selected_list: Array[int] = []

var max_selections: int

# Called when the node enters the scene tree for the first time.
func _ready():
	item_activated.connect(_on_item_activated)
	ui_selected_items.item_activated.connect(_unselect_via_selection_list)
	max_selections = Constants.INT_MAX

func clean_up():
	clear()
	ui_selected_items.clear()
	_selected_list.clear()

func append_selected(selected_list: Array[int]):
	for index in selected_list:
		_add_selected_item(index)

'''
Params:
	- Option index: the index from the option list toggled
	- selected: whether it was selected or deselected
'''
func _on_item_activated(index: int):
	if _selected_list.size() >= max_selections:
		return
	else:
		_add_selected_item(index)

'''
Adds an item to the UI for selected items, as well as adds to the 
conversion dictionary
'''
func _add_selected_item(index):
	if index in _selected_list:
		return
	
	ui_selected_items.add_item(get_item_text(index))
	_selected_list.append(index)
	item_updated.emit(index, true)

'''
Allows for handling when the item in the selection list is double clicked
'''
func _unselect_via_selection_list(selection_index: int):
	var option_index = _selected_list.pop_at(selection_index)
	ui_selected_items.remove_item(selection_index)
	
	item_updated.emit(option_index, false)
