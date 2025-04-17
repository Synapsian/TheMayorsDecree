extends Node2D

var current_scene = null

func _ready() -> void:
	Tasks.change_visibility(false)

func _on_start_pressed() -> void:
	Tasks.change_visibility(true)
	get_tree().change_scene_to_file("res://scenes/world_mayor.tscn")
	visible = false
