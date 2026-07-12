class_name AwaitGroup extends RefCounted

signal _all_completed

var _counter: int = 0

var in_progress: bool = false

func multi_signal(signals: Array[Signal]) -> void:
	if in_progress: return
	
	in_progress = true
	_counter = signals.size()
	
	for sig in signals:
		sig.connect(_on_signal_completed, CONNECT_ONE_SHOT)
	
	await _all_completed

'''
Allows for awaiting multiple functions at a time.
Params:
	- list of functions
'''
func multi_function(functions: Array[Callable]) -> void:
	if in_progress: return
	
	in_progress = true
	_counter = functions.size()
	
	var func_wrappers = []
	
	for func_item in functions:
		var wrapper = FunctionWrapper.new(func_item)
		wrapper.func_finished.connect(_on_signal_completed, CONNECT_ONE_SHOT)
		wrapper.call_func()
	
	await _all_completed

func _on_signal_completed() -> void:
	_counter -= 1
	if _counter == 0:
		_all_completed.emit()
		in_progress = false

class FunctionWrapper extends RefCounted:
	signal func_finished
	
	var wrapped_func: Callable
	
	func _init(new_func: Callable):
		wrapped_func = new_func
	
	func call_func():
		await wrapped_func
		func_finished.emit()
