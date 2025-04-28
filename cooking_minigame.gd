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
	pan.position.x = mouse_position.x - 25.0 # offset by half sprite size to make it at middle
	pan.position.x = clamp(pan.position.x,MIN_PAN_POSITION,MAX_PAN_POSITION)

func flip_pan():
	var bodies = pan.get_child(0).get_overlapping_bodies()
	var body = null
	for index in len(bodies):
		body = bodies[index]
		if not body.is_in_group("Food"): 
			body = null
		else: break
	if not body == null:
		body.set_meta("no_gravity",true)
		var body_fall_timer = Timer.new()
		body_fall_timer.one_shot = true
		body_fall_timer.wait_time = randf_range(0.75,1.25)
		body_fall_timer.start()
		#body.velocity = -body.velocity
		print("Found body in pan")

func body_fall_timer_timeout(body:CharacterBody2D):
	body.set_meta("no_gravity",false)

func _input(event):
	# Mouse in viewport coordinates.
	if event is InputEventMouseButton:
		if not event.button_index == MOUSE_BUTTON_LEFT: return
		flip_pan()
	

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
