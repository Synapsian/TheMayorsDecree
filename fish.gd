extends CharacterBody2D

func _ready() -> void:
	var chosen_velocity = 10 * randf_range(1,5)
	if randi_range(1,2) == 2:
		chosen_velocity = -chosen_velocity
	velocity = Vector2(chosen_velocity,chosen_velocity)
	rotation = atan2(velocity.y,velocity.x)

func _process(delta: float) -> void:
	move_and_slide()
