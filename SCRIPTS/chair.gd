extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if not body.name == "character": return
	body.position = $hitbox.position
	body.set_meta("anchored",true)
	body.get_child(2).flip_h = 1
	body.get_child(2).play("idle")
	Tasks.complete_task("mayor_sit_down")
	#throne_used.emit() Old from when tasks used signals
	#$hitbox.set_meta("PlayerInside",true)

func _on_body_exited(body: Node2D) -> void:
	if not body.name == "character": return
	#$hitbox.set_meta("PlayerInside",false)
