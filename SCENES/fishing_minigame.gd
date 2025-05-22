extends CanvasLayer

@onready var fish = preload('res://fish.tscn')
@onready var spawn_location = $fish_spawnpoints/fish_spawnlocation
@onready var midpoint = $midpoint
@onready var bounding_boxes = $bounding_boxes
@onready var crosshair = $crosshair
@onready var midpoint_spawn = $midpoint_randomizer/midpoint_path_follow

var points = 0

func destroy_timer(timer):
	timer.queue_free()

func wait(time:float):
	var new_timer = Timer.new()
	new_timer.one_shot = true
	new_timer.wait_time = time
	add_child(new_timer)
	new_timer.start()
	new_timer.timeout.connect(destroy_timer.bind(new_timer))
	return new_timer.timeout

func _ready() -> void:
	for bounding_box in bounding_boxes.get_children():
		bounding_box.body_entered.connect(_bounding_box_entered)
	start_minigame()

func _bounding_box_entered(body:Node2D):
	if body.is_in_group("Fish"):
		body.queue_free()

func add_new_fish():
	midpoint_spawn.progress_ratio = randf()
	midpoint.position = midpoint_spawn.position
	
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

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		_shoot()

func _shoot():
	var mouse_position = get_viewport().get_mouse_position()
	mouse_position = Vector2(clamp(mouse_position.x,375,775),clamp(mouse_position.y,120,520))
	crosshair.position = mouse_position
	for i in range(1,10):
		for body in crosshair.get_overlapping_bodies():
			if body.is_in_group("Fish"):
				body.remove_fish()
				return

func start_minigame():
	for i in range(1,100):
		add_new_fish()
		if randi_range(1,2) == 2:
			await wait(randf())
