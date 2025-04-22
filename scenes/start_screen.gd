extends Node2D

var current_scene = null

func _ready() -> void:
	Tasks.change_visibility(false)

func _on_start_pressed() -> void:
	Tasks.change_visibility(true)
	
	var packed_scene = load("res://scenes/world_mayor.tscn")
	current_scene = packed_scene.instantiate()
	get_tree().get_root().add_child.call_deferred(current_scene)
	
	#get_tree().change_scene_to_file("res://scenes/world_mayor.tscn")
	visible = false

func _load_world_worker():
	if current_scene:
		current_scene.queue_free() # queue_free()
	
	current_scene = load("res://scenes/world_worker.tscn")
	var sceneInstance = current_scene.instantiate()
	get_tree().get_root().add_child.call_deferred(sceneInstance)
