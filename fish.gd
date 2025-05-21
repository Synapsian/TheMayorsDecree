extends CharacterBody2D

var SPEED = 50
var Destination : Vector2
var Direction

var LastPosition : Vector2

func set_target(TargetPosition:Vector2):
	SPEED = SPEED * randi_range(1,10)
	Destination = TargetPosition
	Direction = position.direction_to(Destination)

func remove_fish():
	get_parent().add_points(SPEED / 50)
	queue_free()

func _process(delta: float) -> void:
	if not Destination: return
	position += Direction * SPEED * delta

	if not LastPosition:
		LastPosition = position

	var AssumedVelocity = Vector2(position.x - LastPosition.x, position.y - LastPosition.y)
	rotation = atan2(AssumedVelocity.y,AssumedVelocity.x)
	LastPosition = position
