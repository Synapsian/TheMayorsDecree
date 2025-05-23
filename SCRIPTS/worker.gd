extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var ANCHORED = false
var FIRST_TRANSITION = false

func anchor(anchored:bool = true):
	ANCHORED = anchored

func _physics_process(delta: float) -> void:
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
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
	if ANCHORED == true:
		direction = 0
	
	if direction:
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


func transition_set_position(new_position: Vector2) -> void:
	if not FIRST_TRANSITION:
		FIRST_TRANSITION = true
		DayTimer.start_timer()
	
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished
	position = new_position
