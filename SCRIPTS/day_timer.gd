extends CanvasLayer
@export var start_time:int
@export var enabled:bool = false
@onready var label:Label = $time_remaining

signal finished
var current_time_left = 999
var game_finished = false

func _ready() -> void:
	current_time_left = start_time

func _process(delta: float) -> void:
	if game_finished: return

	if not enabled: 
		visible = false
		return

	if current_time_left <= 0:
		print("Finished")
		game_finished = true
		finished.emit()
		return

	current_time_left -= delta
	label.text = str(int(current_time_left))

func start_timer():
	visible = true
	enabled = true
