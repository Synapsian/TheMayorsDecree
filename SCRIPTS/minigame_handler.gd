extends Node2D
	
@onready var cooking_minigame = $cooking_minigame
@onready var fishing_minigame = $fishing_minigame
signal minigame_finished

func start_cooking_minigame():
	cooking_minigame.start()

func start_fishing_minigame():
	fishing_minigame.start_minigame()

func _emit_finished_signal():
	minigame_finished.emit()

var minigames = {"cooking":start_cooking_minigame,"fishing":start_fishing_minigame}
func new_minigame(minigame_name:String):
	if not minigames.get(minigame_name):
		print("Error: Minigame key not found ... " + minigame_name)
		return
	print("Playing new minigame " + minigame_name)
	minigames[minigame_name].call()

#func _ready() -> void:
	#print("Parent is " + get_parent().name)
	#new_minigame("cooking")


func _on_fishing_minigame_fishing_minigame_ended() -> void:
	minigame_finished.emit()
