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

var on_complete_functions = {}
var labels = {}

func add_task(task_name: String,text_contents: String, quest_location: Vector2, on_complete = default_function, args = null):
	var new_label = _create_new_label(text_contents)
	new_label.set_meta("target_location",quest_location)
	
	on_complete_functions[task_name] = on_complete
	labels[task_name] = new_label
	
	# // Replace this with own function
	#await completion_signal
	#complete_task(task_name)
	#on_complete.call()
	#new_label.queue_free()
	# \\
	
func complete_task(task_name):
	if not on_complete_functions[task_name]: return
	var on_complete = on_complete_functions[task_name]
	on_complete_functions.erase(task_name) # Gets rid of task_name in dict
	on_complete.call()
	
	if not labels[task_name]: return	
	var label = labels[task_name]
	label.queue_free()
	
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
