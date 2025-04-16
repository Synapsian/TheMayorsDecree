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

func default_function():
	print("Task called default function")

func add_task(task_name: String,text_contents: String, completion_signal: Signal, quest_location: Vector2, on_complete = default_function, args = null):
	var new_label = _create_new_label(text_contents)
	new_label.set_meta("target_location",quest_location)
	await completion_signal
	on_complete.call()
	new_label.queue_free()
	
func process_task(task_name):
	if task_name == "first_mayor_transition":
		print("Do first task things")
		return
	
func change_visibility(visibility: bool):
	visible = visibility

func get_target_location():
	if task_list.get_child_count() <= 1:
		return false
	var top_task = task_list.get_child(1)
	if not top_task:
		return false
	if top_task.has_meta("target_location"):
		return top_task.get_meta("target_location")
	return false
