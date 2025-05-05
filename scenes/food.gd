extends CharacterBody2D

var rotationSpeed = PI/8

func _process(delta: float) -> void:
	rotation += rotationSpeed * delta
	if not get_meta("no_gravity"):
		velocity += (get_gravity()/10) * delta
		move_and_slide()
	else:
		if velocity.y > 0:
			var old_velocity = velocity
			velocity = Vector2(old_velocity.x,-old_velocity.y)
		move_and_slide()
