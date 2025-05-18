extends CanvasLayer

@onready var worker_score = $worker_score
@onready var mayor_score = $mayor_score

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	DayTimer.finished.connect(end_game)

func end_game():
	visible = true
	MoneyHandler.end_of_day_income()
	
	var MayorMoney = MoneyHandler.get_dict("Mayor")
	var WorkerMoney = MoneyHandler.get_dict("Worker")
	
	worker_score.text = "Worker Money: $" + str(WorkerMoney['Amount'])
	mayor_score.text = "Mayor Money: $" + str(MayorMoney['Amount'])
