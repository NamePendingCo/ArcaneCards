class_name LoadScreen extends CanvasLayer

const TOOLTIPS_PATH: String = "res://menus/load_screen/tooltips.txt"

enum ProgressType {
	LOAD,
	POPULATE
}

@export var progress_bar: ProgressBar

@export var tool_tip_label: Label
var current_tooltip: int

var progress_ratio: float = 1

var tooltips: PackedStringArray

var timer: Timer

# Called when the node enters the scene tree for the first time.
func _ready():
	var file = FileAccess.open(TOOLTIPS_PATH, FileAccess.READ)
	var content: String = file.get_as_text()
	
	tooltips = content.split("\n")
	
	_update_tool_tip()
	
	timer = Timer.new()
	add_child(timer)
	timer.timeout.connect(_update_tool_tip)
	
	timer.start(10.0)

func update_progress(val: float, type: ProgressType = ProgressType.LOAD):
	if type == ProgressType.LOAD:
		progress_bar.value = val * progress_ratio * 100
	elif type == ProgressType.POPULATE:
		progress_bar.value = (progress_ratio + (val *  (1 - progress_ratio))) * 100

func _update_tool_tip():
	#Get random tool tip, make sure not to repeat
	var index: int = randi() % tooltips.size()
	while index == current_tooltip:
		index = randi() % tooltips.size()
	
	current_tooltip = index
	tool_tip_label.text = tooltips[index]
