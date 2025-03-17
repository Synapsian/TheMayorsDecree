extends CanvasLayer

signal dialogue_finished
@onready var text_input = $container/outline/RichTextLabel
@onready var sprite = $container/outline/Sprite2D
@onready var timer = $container/outline/Timer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false

func start_dialogue(new_text: String, new_sprite: Sprite2D, time: int):
	visible = true
	sprite = new_sprite
	
	var temp_text = " "
	for letter in new_text:
		temp_text = temp_text + letter
		text_input.text = temp_text
		var temp_timer = Timer.new()
		temp_timer.one_shot = true
		temp_timer.wait_time = 0.02
		add_child(temp_timer)
		temp_timer.start()
		await temp_timer.timeout
	
	timer.wait_time = time
	timer.start()
	await timer.timeout
	visible = false
	dialogue_finished.emit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
