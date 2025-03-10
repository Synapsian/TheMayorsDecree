extends Area2D

signal set_position(x,y)
var interaction_debounce = false

func _process(delta: float) -> void:
	if Input.is_action_pressed("Interact") and $Hitbox.get_meta("PlayerInside") == true and interaction_debounce == false:
		set_position.emit(get_meta("Position"))

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
