extends CanvasLayer

var fish = preload('res://fish.tscn')

func add_new_fish():
	var new_fish = fish.instantiate()
