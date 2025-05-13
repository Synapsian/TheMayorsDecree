extends Node2D

func _ready() -> void:
	var children = get_children()
	for child in children:
		child.play()
