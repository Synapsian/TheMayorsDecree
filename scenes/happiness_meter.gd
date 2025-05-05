extends CanvasLayer

@onready var face = $Path2D/PathFollow2D/face
@onready var path = $Path2D/PathFollow2D
var happiness = 100.0
var max_happiness = 100.0
var previous_happiness;

func set_happiness(amount:float):
	happiness = amount

func get_happiness():
	return happiness

func _ready() -> void:
	hide()

func _process(delta: float) -> void:
	if previous_happiness != happiness:
		var new_tween = get_tree().create_tween()
		var desired_value = clamp(happiness/max_happiness,0,1)
		new_tween.tween_property(path,"progress_ratio",desired_value,0.5)
		#path.progress_ratio = clamp(happiness/max_happiness,0,100.0)
	previous_happiness = happiness
	
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
