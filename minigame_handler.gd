extends Node2D

func _cooking_minigame():
	print("Cooking minigame started")

var minigames = {"cooking":_cooking_minigame}
func new_minigame(minigame_name:String):
	if not minigames.find_key(minigame_name):
		print("Error: Minigame key not found ... " + minigame_name)
		return
	print("Playing new minigame " + minigame_name)
	minigames[minigame_name].call()
