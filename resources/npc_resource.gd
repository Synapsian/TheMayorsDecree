class_name NPC
extends Sprite2D

@export var NPCDialogue : String
@onready var Hitbox = $Area2D

func _area_entered():
	print("Entered")

func _area_exited():
	print("Area Exited")

func _ready() -> void:
	Hitbox.connect("area_entered",_area_entered)
	
