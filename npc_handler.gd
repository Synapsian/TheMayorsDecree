extends Node2D

var NPCs = []
func _ready() -> void:
	NPCs = get_tree().get_nodes_in_group("NPC")

func _process(delta: float) -> void:
	if len(NPCs) <= 0:
		print("No npcs found")
