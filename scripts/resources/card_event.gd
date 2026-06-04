class_name CardEvent extends Resource

@export
var effects: Array[CardEffect]

func trigger():
	for effect in effects:
		effect.invoke()
