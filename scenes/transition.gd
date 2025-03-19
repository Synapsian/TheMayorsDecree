extends Area2D

signal set_position(x,y)
signal interact_signal
var interaction_debounce = false

func _ready() -> void:
	if get_meta("InteractSignal") == true:
		Tasks.add_task("cool quest 1",interact_signal)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Interact") and $Hitbox.get_meta("PlayerInside") == true:
		var bodies = get_overlapping_bodies()
		var body = null
		for index in len(bodies):
			body = bodies[index]
			if body.name != "character": 
				body = null
				continue
			if body.get_meta("transition_debounce") == true: return
			body.set_meta("transition_debounce",true)
		if body == null: return
		set_position.emit(get_meta("Position"))
		
		if get_meta("InteractSignal"):
			interact_signal.emit()
		
		var newtimer = Timer.new()
		newtimer.wait_time = 3
		newtimer.one_shot = true 
		$Hitbox.add_child(newtimer)
		newtimer.start()
		await newtimer.timeout
		newtimer.queue_free()
		body.set_meta("transition_debounce",false)

func _on_body_entered(body: Node2D) -> void:
	if not body.name == "character": return
	$Hitbox.set_meta("PlayerInside",true)
	if not $Arrow.visible:
		$Arrow.visible = true
	$Arrow.modulate.a = 0
	var tween = get_tree().create_tween()
	tween.tween_property($Arrow,"modulate:a",1,0.5)
	

func _on_body_exited(body: Node2D) -> void:
	if not body.name == "character": return
	$Hitbox.set_meta("PlayerInside",false)
	$Arrow.modulate.a = 1
	var tween = get_tree().create_tween()
	tween.tween_property($Arrow,"modulate:a",0,0.5)
