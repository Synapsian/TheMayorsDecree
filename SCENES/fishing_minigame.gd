extends CanvasLayer

@export var debug_start:bool

@onready var fish = preload('res://SCENES/fish.tscn')
@onready var spawn_location = $fish_spawnpoints/fish_spawnlocation
@onready var midpoint = $midpoint
@onready var bounding_boxes = $bounding_boxes
@onready var crosshair = $crosshair
@onready var midpoint_spawn = $midpoint_randomizer/midpoint_path_follow

signal fishing_minigame_ended
var ENABLED = false
var points = 0
var fishies = []
var final_fish_spawned = false

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
	if debug_start:
		start_minigame()

func _bounding_box_entered(body:Node2D):
	if body.is_in_group("Fish"):
		fishies.pop_front()
		body.queue_free()

func add_new_fish():
	if not ENABLED: return
	midpoint_spawn.progress_ratio = randf()
	midpoint.position = midpoint_spawn.position
	
	var new_fish = fish.instantiate()
	spawn_location.progress_ratio = randf()
	new_fish.position = spawn_location.position
	new_fish.visible = true
	fishies.append(new_fish)
	new_fish.add_to_group("Fish")
	new_fish.set_target(midpoint.position)
	add_child(new_fish)

func add_points(amount:int):
	if not ENABLED: return
	print("Adding " + str(amount) + " points")
	points+= amount

func _input(event: InputEvent) -> void:
	if not ENABLED: return
	if event is InputEventMouseButton and event.is_pressed():
		_shoot()

func _shoot():
	var mouse_position = get_viewport().get_mouse_position()
	mouse_position = Vector2(clamp(mouse_position.x,375,775),clamp(mouse_position.y,120,520))
	crosshair.position = mouse_position
	for i in range(1,10):
		for body in crosshair.get_overlapping_bodies():
			if body.is_in_group("Fish"):
				fishies.pop_front()
				body.remove_fish()
				return

func start_minigame():
	final_fish_spawned = false
	ENABLED = true
	visible = true
	for i in range(1,100):
		add_new_fish()
		if randi_range(1,2) == 2:
			await wait(randf())
	final_fish_spawned = true

func end_minigame():
	print("Minigame Ending")
	var wage = MoneyHandler.get_wage()
	var moneyToEarn = wage * points
	moneyToEarn = ceil(moneyToEarn / 100)
	print("Money Earned: " + str(moneyToEarn))
	MoneyHandler.increase_income("Worker",moneyToEarn,"Add")
	visible = false
	ENABLED = false
	fishing_minigame_ended.emit()

func _process(delta: float) -> void:
	if not ENABLED: return
	if not final_fish_spawned: return
	if len(fishies) <= 0:
		end_minigame()
