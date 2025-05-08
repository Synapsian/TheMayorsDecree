extends Node2D
	
@onready var cooking_minigame = $cooking_minigame
signal minigame_finished

func start_cooking_minigame():
	#get_tree().root.add_child(cooking_minigame)
	cooking_minigame.start()

func _emit_finished_signal():
	minigame_finished.emit()

var minigames = {"cooking":start_cooking_minigame}
func new_minigame(minigame_name:String):
	if not minigames.get(minigame_name):
		print("Error: Minigame key not found ... " + minigame_name)
		return
	print("Playing new minigame " + minigame_name)
	minigames[minigame_name].call()

#func _ready() -> void:
	#print("Parent is " + get_parent().name)
	#new_minigame("cooking")
