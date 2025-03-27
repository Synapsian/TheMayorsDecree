extends Area2D

signal throne_used

func _on_body_entered(body: Node2D) -> void:
	if not body.name == "character": return
	body.position = $hitbox.position
	body.set_meta("anchored",true)
	body.get_child(2).flip_h = 1
	body.get_child(2).play("idle")
	throne_used.emit()
	#$hitbox.set_meta("PlayerInside",true)

func _on_body_exited(body: Node2D) -> void:
	if not body.name == "character": return
	#$hitbox.set_meta("PlayerInside",false)
