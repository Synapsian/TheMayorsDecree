extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if not body.name == "character": return
	$Arrow.visible = true
	$Arrow.modulate.a = 0
	var tween = get_tree().create_tween()
	tween.tween_property($Arrow,"modulate:a",1,0.5)
	

func _on_body_exited(body: Node2D) -> void:
	if not body.name == "character": return
	$Arrow.modulate.a = 1
	var tween = get_tree().create_tween()
	tween.tween_property($Arrow,"modulate:a",0,0.5)
