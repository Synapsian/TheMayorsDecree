extends CanvasLayer

@onready var spawn_location = $spawn_path/spawn_location
@onready var pan = $pan
var food = preload("res://food.tscn")
var click_debounce = false
var points = 0

func _launch_food():
	var new_food = food.instantiate()
	spawn_location.progress_ratio = randf()
	new_food.position = spawn_location.position
	new_food.visible = true
	new_food.add_to_group("Food")
	add_child(new_food)
	

func start():
	points = 0
	show()
	print("Cooking minigame is now starting")
	_launch_food()
	
var MAX_PAN_POSITION = 675
var MIN_PAN_POSITION = 426
func _process(_delta: float) -> void:
	var mouse_position = get_viewport().get_mouse_position()
	pan.position.x = mouse_position.x - 25.0 # offset by half sprite size to make it at middle
	pan.position.x = clamp(pan.position.x,MIN_PAN_POSITION,MAX_PAN_POSITION)

func _click_debounce_end(timer:Timer):
	timer.queue_free()
	pan.color = Color.AQUAMARINE
	click_debounce = false

func flip_pan():
	if click_debounce: return
	click_debounce = true
	
	var click_debounce_timer = Timer.new()
	click_debounce_timer.one_shot = true
	click_debounce_timer.wait_time = 1
	add_child(click_debounce_timer)
	pan.color = Color.DARK_SEA_GREEN
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
			body.queue_free()
			return "max_flips"
		
		var body_fall_timer = Timer.new()
		body_fall_timer.one_shot = true
		body_fall_timer.wait_time = 0.02
		add_child(body_fall_timer)
		body_fall_timer.start()
		body_fall_timer.timeout.connect(_body_fall_timer_timeout.bind(body,body_fall_timer))

func _body_fall_timer_timeout(body:CharacterBody2D,timer:Timer):
	body.set_meta("no_gravity",false)
	timer.queue_free()

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
	points -= 1
	print("-1 Point")
