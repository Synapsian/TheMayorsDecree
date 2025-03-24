extends Node2D

var current_scene = null
func _ready() -> void:
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)
	var new_scene = ResourceLoader.load("res://scenes/tasks.tscn")
	current_scene = new_scene.instantiate()
	root.add_child(current_scene)
