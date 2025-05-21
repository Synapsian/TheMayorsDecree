extends CanvasLayer

@onready var fish = preload('res://fish.tscn')
@onready var spawn_location = $fish_spawnpoints/fish_spawnlocation
@onready var midpoint = $midpoint
@onready var bounding_boxes = $bounding_boxes

var points = 0

func _ready() -> void:
	
	for bounding_box in bounding_boxes.get_children():
		bounding_box.body_entered.connect(_bounding_box_entered)

	add_new_fish()

func _bounding_box_entered(body:Node2D):
	if body.is_in_group("Fish"):
		body.remove_fish()

func add_new_fish():
	var new_fish = fish.instantiate()
	spawn_location.progress_ratio = randf()
	new_fish.position = spawn_location.position
	new_fish.visible = true
	new_fish.add_to_group("Fish")
	new_fish.set_target(midpoint.position)
	add_child(new_fish)

func add_points(amount:int):
	print("Adding " + str(amount) + " points")
	points+= amount
