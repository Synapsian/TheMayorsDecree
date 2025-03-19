extends CanvasLayer

@onready var font = load("res://fonts/GeosansLight.ttf")
@onready var task_list = $container/VBoxContainer

func _create_new_label(text: String):
	var new_label = Label.new()
	new_label.text = text.to_upper()
	new_label.name = "Task" + str(task_list.get_child_count())
	
	# Formatting
	new_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	new_label.set("theme_override_fonts/font",font)
	
	task_list.add_child(new_label)
	return new_label

func add_task(task: String, completion_signal: Signal):
	var new_label = _create_new_label(task)
	await completion_signal
	new_label.queue_free()

func complete_task(task: String):
	pass
