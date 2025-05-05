extends Area2D

# // Variables
var interaction_debounce = false
# \\ Variables

# // Tasks
#func complete_third_task():
	#Tasks.complete_task("mayor_exit_building")

#func complete_second_task():
	#Tasks.hide()
	#Decree.new_decree()
	#enable_transition.emit("Transition2")
	#Tasks.add_task("mayor_exit_building","Exit the building",Vector2(-1087.0,-3322.0))
# \\ Tasks

func _on_interaction():
	var minigame_name = get_meta("minigame_name")
	MinigameHandler.new_minigame(minigame_name)

func _process(_delta: float) -> void:
	# Must be enabled, player must be inside, interact button must have just been pressed
	if get_meta("Enabled") == true and Input.is_action_just_pressed("Interact") and $Hitbox.get_meta("PlayerInside") == true:
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

		# Call function here
		_on_interaction()
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
	if not body.is_in_group("Player"): 
		print('Not player -> ' + body.name)
		return
	# \\ 
	
	$Hitbox.set_meta("PlayerInside",false)
	
	# // Arrow animation
	$Arrow.modulate.a = 1
	var tween = get_tree().create_tween()
	tween.tween_property($Arrow,"modulate:a",0,0.5)
	# \\ Arrow Animation
