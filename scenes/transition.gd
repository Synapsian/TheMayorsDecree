extends Area2D

# // Signals
signal placeholder
signal interact_signal
signal seat_taken
signal enable_transition(transition_name)
# \\ Signals

# // Variables
var interaction_debounce = false
# \\ Variables

# // Tasks (Remove for own node)
func complete_second_task():
	Tasks.hide()
	Decree.new_decree()
	Tasks.add_task("mayor_exit_building","Exit the building",placeholder,Vector2(0,0))

func complete_first_task():
	Tasks.add_task("mayor_sit_down","Take your seat",seat_taken,Vector2(1568.0,-2690.0),complete_second_task)
# \\ Tasks

func _ready() -> void:
	enable_transition.emit(name)
	if get_meta("InteractSignal") == true:
		Tasks.add_task("mayor_first_transition","Enter city hall",interact_signal,Vector2(1283.0,658.0),complete_first_task)

func _process(_delta: float) -> void:
	# Must be enabled, player must be inside, interact button must have just been pressed
	if get_meta("Enabled") == true and Input.is_action_just_pressed("Interact") and $Hitbox.get_meta("PlayerInside") == true:
		print("Interact")
		
		# // Loops through all overlapping boddies, if it finds the player it returns it, else becomes null.
		var bodies = get_overlapping_bodies()
		var body = null
		for index in len(bodies):
			body = bodies[index]
			if not body.is_in_group("Player"):
				body = null
				continue
			if body.get_meta("transition_debounce") == true: return
			body.set_meta("transition_debounce",true)
		# \\ Body Check
		
		if body == null: return
		# Ended if player character not found
		print("Setting position")
		# Calls all objects with the group "Player", then calls the "transition_set_position" function.
		get_tree().call_group("Player","transition_set_position",$teleport_location.global_position)
		
		if get_meta("InteractSignal"):
			interact_signal.emit()
		
		# // Creates a new timer, awaits it, and then gets rid of it/
		var newtimer = Timer.new()
		newtimer.wait_time = 3
		newtimer.one_shot = true 
		$Hitbox.add_child(newtimer)
		newtimer.start()
		await newtimer.timeout
		newtimer.queue_free()
		# \\ Timer
		
		body.set_meta("transition_debounce",false)

func _on_body_entered(body: Node2D) -> void:
	# // Checks for player and whether or not node is enabled
	if not body.is_in_group("Player"): return
	if get_meta("Enabled") == false: return
	# \\
	
	$Hitbox.set_meta("PlayerInside",true)
	
	# // Arrow Animation
	if not $Arrow.visible:
		$Arrow.visible = true
	$Arrow.modulate.a = 0
	var tween = get_tree().create_tween()
	tween.tween_property($Arrow,"modulate:a",1,0.5)
	# \\ Arrow Animation
	

func _on_body_exited(body: Node2D) -> void:
	# // Checks for player group
	if not body.is_in_group("Player"): return
	# \\ 
	
	$Hitbox.set_meta("PlayerInside",false)
	
	# // Arrow animation
	$Arrow.modulate.a = 1
	var tween = get_tree().create_tween()
	tween.tween_property($Arrow,"modulate:a",0,0.5)
	# \\ Arrow Animation

func _on_chair_throne_used() -> void:
	seat_taken.emit()


func _on_enable_transition(transition_name: Variant) -> void:
	if name == transition_name:
		set_meta("Enabled",true)
