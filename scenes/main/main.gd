class_name Main extends Node

'''
The main scene that governs changes between all scenes
'''

signal scene_loaded
signal scene_load_progress(progress)
signal scene_populate_progress(progress)
signal scene_entered

const BATTLE_SCENE_KEY = "battle"
const MAIN_MENU_KEY = "main_menu"

const LOAD_SCREEN_PATH = "res://menus/load_screen/load_screen.tscn"

const MENU_PATHS: Dictionary[String, String] = {
	"main_menu": "res://menus/main_menu/main_menu.tscn"
}

const SCENE_PATHS: Dictionary[String, String] = {
	"battle": "res://scenes/battle/battle.tscn"
}

#The node currently loaded
var loaded_scene: Node

var load_screen_resource: PackedScene

var has_scene_loading: bool = false
var loading_scene_path: String = ""

func _ready():
	load_main_menu()
	
	load_screen_resource = preload(LOAD_SCREEN_PATH)

func _process(delta):
	if has_scene_loading:
		_check_loading_status()

#================================================
# Public methods
#================================================

func load_main_menu():
	var main_menu_resource: PackedScene = load(MENU_PATHS[MAIN_MENU_KEY])
	var main_menu: MainMenu = main_menu_resource.instantiate()
	
	add_child(main_menu)
	loaded_scene = main_menu
	main_menu.start_game.connect(load_battle, CONNECT_ONE_SHOT)

'''
Params:
	- menu key: the menu to load
	- do_exit_scene: if true, exit the scene. If false, load over scene
'''
func load_menu(menu_key: String, do_exit_scene: bool=true):
	#TODO
	pass

'''
Loads the battle scene. Eventually this should get some parameters in here
which should set things like the casters/beings and ruleset.
'''
func load_battle():
	_raise_load_screen(0.5)
	remove_scene(loaded_scene)
	var battle_resource = await _load_scene_async(SCENE_PATHS[BATTLE_SCENE_KEY])
	await get_tree().create_timer(1).timeout #THIS LINE IS FOR DEMO ONLY. DELETE LATER
	scene_populate_progress.emit(0.5)
	await get_tree().create_timer(1).timeout #THIS LINE IS FOR DEMO ONLY. DELETE LATER
	scene_populate_progress.emit(1)
	
	var battle = battle_resource.instantiate()
	add_child(battle)
	loaded_scene = battle
	scene_entered.emit()

#================================================
# Private methods
#================================================

'''
Loads a scene file asynchronously in the background.
'''
func _load_scene_async(scene_path: String) -> PackedScene:
	has_scene_loading = true
	loading_scene_path = scene_path
	ResourceLoader.load_threaded_request(scene_path)
	
	await scene_loaded
	var scene_resource: PackedScene = ResourceLoader.load_threaded_get(scene_path)
	
	return scene_resource

'''
Run every tick by process if there is a scene loading. Will signal when the scene
finishes, or signal the amount of progress in loading if not.
'''
func _check_loading_status():
	var progress: Array = []
	var status = ResourceLoader.load_threaded_get_status(loading_scene_path, progress)
	
	if status == ResourceLoader.ThreadLoadStatus.THREAD_LOAD_LOADED:
		scene_load_progress.emit(progress[0])
		has_scene_loading = false
		loading_scene_path = ""
		scene_loaded.emit()
	elif status == ResourceLoader.ThreadLoadStatus.THREAD_LOAD_IN_PROGRESS:
		#If still in progress, announce scene
		scene_load_progress.emit(progress[0])

'''
Param:
	- load_populate_ratio: the ratio of the total load screen bar that
	should be filled from loading the scene vs populating it.
'''
func _raise_load_screen(load_populate_ratio: float = 0):
	var load_screen: LoadScreen = load_screen_resource.instantiate()
	load_screen.progress_ratio = load_populate_ratio
	
	scene_load_progress.connect(load_screen.update_progress)
	scene_populate_progress.connect(load_screen.update_progress.bind(LoadScreen.ProgressType.POPULATE))
	
	scene_entered.connect(remove_scene.bind(load_screen), CONNECT_ONE_SHOT)
	add_child(load_screen)

func remove_scene(node: Node):
	if node == loaded_scene:
		loaded_scene = null
	
	remove_child(node)
	node.queue_free()
