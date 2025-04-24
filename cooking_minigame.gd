extends CanvasLayer

@onready var spawn_location = $spawn_path/spawn_location

func start():
	show()
	print("Cooking minigame is now starting")
	var random_progress = randf_range(0,1)
	spawn_location.progress = random_progress
	print(spawn_location.progress)
	

func _ready() -> void:
	hide()
