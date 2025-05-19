extends CanvasLayer

@onready var fish = preload('res://fish.tscn')
@onready var spawn_location = $fish_spawnpoints/fish_spawnlocation

var fishies = []

func _ready() -> void:
	add_new_fish()

func add_new_fish():
	var new_fish = fish.instantiate()
	spawn_location.progress_ratio = randf()
	new_fish.position = spawn_location.position
	new_fish.visible = true
	fishies.append(new_fish)
	new_fish.add_to_group("Fish")
	add_child(new_fish)
