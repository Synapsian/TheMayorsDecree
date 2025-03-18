extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var sinceLastInput = 0
var controlsDebounce = false

@onready var keys = [$W,$A,$S,$D]

func wait(time:float):
	var temp_timer = Timer.new()
	temp_timer.one_shot = true
	temp_timer.wait_time = time
	add_child(temp_timer)
	temp_timer.start()
	await temp_timer.timeout

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if controlsDebounce == false:
		sinceLastInput += delta
	
	if sinceLastInput > 7:
		controlsDebounce = true
		sinceLastInput = 0
		var tween = get_tree().create_tween()
		tween.tween_property(keys[0],"modulate:a",1,0.5)
		tween.tween_property(keys[1],"modulate:a",1,0.5)
		tween.tween_property(keys[2],"modulate:a",1,0.5)
		tween.tween_property(keys[3],"modulate:a",1,0.5)
		wait(1)
		tween.tween_property(keys[0],"modulate:a",0,0.5)
		tween.tween_property(keys[1],"modulate:a",0,0.5)
		tween.tween_property(keys[2],"modulate:a",0,0.5)
		tween.tween_property(keys[3],"modulate:a",0,0.5)
		controlsDebounce = false
		
	# Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
	#	velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	
	if Input.is_action_pressed("move_left"):
		direction = -1
	elif Input.is_action_pressed("move_right"):
		direction = 1
	
	if direction:
		sinceLastInput = 0
		if direction < 0:
			$sprite.flip_h = 1
		elif direction > 0:
			$sprite.flip_h = 0
		velocity.x = direction * SPEED
		$sprite.play("run")
	else:
		$sprite.play("idle")
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()


func _on_transition_set_position(new_position: Vector2) -> void:
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished
	position = new_position
