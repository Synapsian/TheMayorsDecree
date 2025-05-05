extends CanvasLayer
@onready var progress_bar = $TextureProgressBar

func update_gold(gold_value):
	print("Updating gold to " + str(gold_value))
	var max_gold = MoneyHandler.get_max_gold()
	print("Max gold is " + str(max_gold))
	print("New progress is " + str(gold_value/max_gold))
	progress_bar.value = gold_value/max_gold

func _ready():
	var mayor_dict = MoneyHandler.get_dict("Mayor")
	var starting_net_cash = mayor_dict['Income'] + mayor_dict['Amount']
	update_gold(starting_net_cash)
