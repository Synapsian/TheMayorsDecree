extends CanvasLayer

@onready var face = $Path2D/PathFollow2D/face
@onready var path = $Path2D/PathFollow2D

func _process(delta: float) -> void:
	if path.progress_ratio < 0.1:
		face.play("angry")
	elif path.progress_ratio < 0.3:
		face.play("unhappy")
	elif path.progress_ratio < 0.6:
		face.play("neutral")
	elif path.progress_ratio < 0.8:
		face.play("happy")
	else:
		face.play("super_happy")
