extends CanvasLayer

@onready var spawn_location = $spawn_path/spawn_location
@onready var pan = $pan
var food = preload("res://food.tscn")

func _launch_food():
	var new_food = food.instantiate()
	spawn_location.progress_ratio = randf()
	new_food.position = spawn_location.position
	new_food.visible = true
	new_food.add_to_group("Food")
	add_child(new_food)
	

func start():
	show()
	print("Cooking minigame is now starting")
	_launch_food()
	
var MAX_PAN_POSITION = 675
var MIN_PAN_POSITION = 426
func _process(_delta: float) -> void:
	var mouse_position = get_viewport().get_mouse_position()
	pan.position.x = mouse_position.x
	pan.position.x = clamp(pan.position.x,MIN_PAN_POSITION,MAX_PAN_POSITION)
	

func _ready() -> void:
	hide()

# Something enters fire
func _on_hitbox_body_entered(body: Node2D) -> void:
	print("Entered")
	if not body.is_in_group("Food"): 
		print("Body entered, not food: " + body.name)
		return
	body.queue_free()
	print("-1 Point")
