extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var sinceLastInput = 0
var controlsDebounce = false

@onready var keys = [$W,$A,$S,$D]
@onready var arrow = $Arrow
@onready var tasks = Tasks

func display_keys():
		var tween = get_tree().create_tween()
		tween.tween_property(keys[0],"modulate:a",1,0.5)
		tween.tween_property(keys[1],"modulate:a",1,0.5)
		tween.tween_property(keys[2],"modulate:a",1,0.5)
		tween.tween_property(keys[3],"modulate:a",1,0.5)

		tween.tween_property(keys[0],"modulate:a",0,0.5)
		tween.tween_property(keys[1],"modulate:a",0,0.5)
		tween.tween_property(keys[2],"modulate:a",0,0.5)
		tween.tween_property(keys[3],"modulate:a",0,0.5)
		controlsDebounce = false
	
func _update_quest_location():
	var target_location = Tasks.get_target_location()
	if not target_location:
		set_meta("quest_location",Vector2(0,0))
		return
	set_meta("quest_location",target_location)

func _physics_process(delta: float) -> void:
	_update_quest_location()
	var quest_location = get_meta("quest_location")
	if quest_location:
		arrow.visible = true
		arrow.look_at(quest_location)
	else:
		arrow.visible = false
		
	if get_meta("anchored"):
		return
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if controlsDebounce == false:
		sinceLastInput += delta
	else:
		sinceLastInput = 0
	
	if sinceLastInput > 7:
		controlsDebounce = true
		sinceLastInput = 0
		display_keys()
		
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


func _on_decree_increase_player_income(type: String, value: float) -> void:
	var current_income = get_meta("money_to_earn")
	if type == "Percent":
		var new_income = (current_income * value/100) + current_income
		set_meta("money_to_earn",new_income)
		print("Increased money to " + str(new_income))
	else:
		push_warning("Couldn't find type " + type + " for player_income")

func unanchor():
	set_meta("anchored",false)

func _ready() -> void:
	Decree.increase_player_income.connect(_on_decree_increase_player_income)
	Decree.on_decree_finished.connect(unanchor)
