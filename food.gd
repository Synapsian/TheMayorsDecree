extends CharacterBody2D

var rotationSpeed = PI/8

func _process(delta: float) -> void:
	rotation += rotationSpeed * delta
	if not get_meta("no_gravity"):
		velocity += (get_gravity()/10) * delta
		move_and_slide()
	else:
		if velocity.y > 0:
			velocity = -velocity
		move_and_slide()
