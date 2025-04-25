extends Node2D

var accelerationSpeed = 20
var velocitySpeed = 100
var rotationSpeed = PI/16

func _process(delta: float) -> void:
	velocitySpeed += accelerationSpeed * delta
	position.y += velocitySpeed * delta
	rotation += rotationSpeed * delta
