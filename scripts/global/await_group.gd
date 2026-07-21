class_name AwaitGroup extends RefCounted

'''
A utility class that allows for running multiple signals
or multiple functions at once. 

Might eventually split this into two, one for signals and one for functions,
so that it can use the _init() constructor to define the things to wait on.
But not for now.
'''

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
	
	var fired_coroutines: Array[CoroutineWrapper]
	
	for func_item: Callable in functions:
		var wrapper: CoroutineWrapper = CoroutineWrapper.new(func_item)
		fired_coroutines.append(wrapper)
		
	for item: CoroutineWrapper in fired_coroutines:
		await item.is_complete()

func _on_signal_completed() -> void:
	_counter -= 1
	if _counter == 0:
		_all_completed.emit()
		in_progress = false

class CoroutineWrapper extends RefCounted:
	signal func_finished
	
	var coroutine: Callable
	var _is_done: bool = false
	var result: Variant
	
	func _init(passed_func: Callable):
		coroutine = passed_func
		call_func()
	
	func call_func():
		result = await coroutine.call()
		_is_done = true
		func_finished.emit()
	
	func is_complete():
		if not _is_done:
			await func_finished
		return result
