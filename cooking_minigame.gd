extends CanvasLayer

@onready var spawn_location = $spawn_path/spawn_location
@onready var pan = $pan
var food = preload("res://food.tscn")
var click_debounce = false
var points = 0
var food_amount = 10
var all_food = []

var MINIGAME_ENABLED = false

func _launch_food():
	var new_food = food.instantiate()
	spawn_location.progress_ratio = randf()
	new_food.position = spawn_location.position
	new_food.visible = true
	all_food.append(new_food)
	new_food.add_to_group("Food")
	add_child(new_food)
	

func start():
	MINIGAME_ENABLED = true
	food_amount = 10
	points = 0
	show()
	print("Cooking minigame is now starting")
	while food_amount > 0:
		food_amount -= 1
		_launch_food()
		var wait_timer = Timer.new()
		wait_timer.one_shot = true
		wait_timer.wait_time = randf_range(1,3)
		add_child(wait_timer)
		wait_timer.start()
		await wait_timer.timeout
		wait_timer.queue_free()
	
func _end_minigame():
	print("Ending cooking minigame")
	MINIGAME_ENABLED = false
	visible = false
	

var MAX_PAN_POSITION = 701
var MIN_PAN_POSITION = 451
func _process(_delta: float) -> void:
	if not MINIGAME_ENABLED: return
	var mouse_position = get_viewport().get_mouse_position()
	pan.position.x = mouse_position.x - 25.0 # offset by half sprite size to make it at middle
	pan.position.x = clamp(pan.position.x,MIN_PAN_POSITION,MAX_PAN_POSITION)
	if len(all_food) == 0 and food_amount == 0:
		_end_minigame()

func _click_debounce_end(timer:Timer):
	timer.queue_free()
	pan.play("default")
	#pan.color = Color.AQUAMARINE
	click_debounce = false

func _flip_pan():
	if click_debounce: return
	click_debounce = true
	
	var click_debounce_timer = Timer.new()
	click_debounce_timer.one_shot = true
	click_debounce_timer.wait_time = 0.25
	add_child(click_debounce_timer)
	pan.play("flip")
	#pan.color = Color.DARK_SEA_GREEN
	click_debounce_timer.start()
	click_debounce_timer.timeout.connect(_click_debounce_end.bind(click_debounce_timer))
	
	var bodies = pan.get_child(0).get_overlapping_bodies()
	var body = null
	for index in len(bodies):
		body = bodies[index]
		if not body.is_in_group("Food"): 
			body = null
		else: break
		
	if not body == null:
		
		points += 1
		body.set_meta("no_gravity",true)
		body.set_meta("flip_times",body.get_meta("flip_times") + 1)
		if body.get_meta("flip_times") == 5:
			all_food.pop_back()
			body.queue_free()
			return "max_flips"
		
		var body_fall_timer = Timer.new()
		body_fall_timer.one_shot = true
		body_fall_timer.wait_time = 0.02
		add_child(body_fall_timer)
		body_fall_timer.start()
		body_fall_timer.timeout.connect(_body_fall_timer_timeout.bind(body,body_fall_timer))

func _body_fall_timer_timeout(body,timer:Timer):
	timer.queue_free()
	if body == null:
		return
	body.set_meta("no_gravity",false)

func _input(event):
	# Mouse in viewport coordinates.
	if event is InputEventMouseButton:
		if not event.button_index == MOUSE_BUTTON_LEFT: return
		_flip_pan()
	

func _ready() -> void:
	hide()

# Something enters fire
func _on_hitbox_body_entered(body: Node2D) -> void:
	print("Entered")
	if not body.is_in_group("Food"): 
		print("Body entered, not food: " + body.name)
		return
	all_food.pop_back()
	body.queue_free()
	points -= 1
	print("-1 Point")
