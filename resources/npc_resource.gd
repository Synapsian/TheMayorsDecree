extends Sprite2D

@export var DialogueText : String
@export var DialogueSpeed : int

@onready var Hitbox = $Area2D
@onready var Arrow = $Arrow

var PlayerInside = false
var Debounce = false

func _body_entered(body):
	if not body.is_in_group("Player"): return
	PlayerInside = true
	
	Arrow.modulate.a = 0
	Arrow.visible = true
	var tween = get_tree().create_tween()
	tween.tween_property(Arrow,"modulate:a",1,0.5)
	

func _body_exited(body):
	if not body.is_in_group("Player"): return
	PlayerInside = false
	
	var tween = get_tree().create_tween()
	tween.tween_property(Arrow,"modulate:a",0,0.5)

func _ready() -> void:
	Hitbox.connect("body_entered",_body_entered)
	Hitbox.connect("body_exited",_body_exited)

func _process(_delta: float) -> void:
	if PlayerInside and Input.is_action_just_pressed("Interact"):
		if Debounce: return
		Debounce = true
		
		Dialogue.start_dialogue(DialogueText,DialogueSpeed,texture)
		
		await  Dialogue.dialogue_finished
		Debounce = false
