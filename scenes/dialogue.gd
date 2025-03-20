extends CanvasLayer

signal dialogue_finished
@onready var text_input = $container/outline/RichTextLabel
@onready var sprite = $container/outline/Sprite2D
@onready var timer = $container/outline/Timer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_get_dialogue_from_file("res://dialogues/test_npc.json")
	visible = false

func _get_dialogue_from_file(path: NodePath):
	print("Getting file")
	var text_content = FileAccess.get_file_as_string(path)
	var dictionary = JSON.parse_string(text_content)
	if dictionary:
		return dictionary
	return false

func _default_function():
	print("Dialogue called default function")

func start_dialogue(dialogue_path: NodePath, time: int, function = _default_function):
	var dictionary = _get_dialogue_from_file(dialogue_path)
	if not dictionary: 
		print("Failed to get dictionary")
		return
	var new_text = dictionary.message
	var new_sprite;
	print(new_sprite.name)
	
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
	function.call()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
