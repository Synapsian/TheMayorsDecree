extends CanvasLayer
@export var start_time:int = 300
@export var enabled:bool = false
@onready var label:Label = $time_remaining
var current_time_left = 300

func _process(delta: float) -> void:
	if not enabled: return
	current_time_left -= delta
	label.text = str(int(current_time_left))
