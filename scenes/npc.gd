extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
var interaction_debounce = false
func _process(delta: float) -> void:
	if get_meta("player_inside") == false or interaction_debounce == true: return
	if not Input.is_action_just_pressed("Interact"): return
	interaction_debounce = true
	print("Starting Dialogue")
	Dialogue.start_dialogue(get_meta("Dialogue"),$sprite,1)
	await Dialogue.dialogue_finished
	print("Dialogue Finished")
	interaction_debounce = false


func _on_interaction_area_body_entered(body: Node2D) -> void:
	if body.name != "character": return
	set_meta("player_inside",true)
	if not $arrow.visible:
		$arrow.visible = true
	$arrow.modulate.a = 0
	var tween = get_tree().create_tween()
	tween.tween_property($arrow,"modulate:a",1,0.5)

func _on_interaction_area_body_exited(body: Node2D) -> void:
	if body.name != "character": return
	set_meta("player_inside",false)
	
	$arrow.modulate.a = 1
	var tween = get_tree().create_tween()
	tween.tween_property($arrow,"modulate:a",0,0.5)
