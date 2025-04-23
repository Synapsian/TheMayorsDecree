extends Node2D

var MayorMoney = {"Amount":1000,"ToEarn":100}
var WorkerMoney = {"Amount":100,"ToEarn":10}

func increase_mayor_income(type: String, value: float, increase:bool) -> void:
	var current_income = MayorMoney["ToEarn"]
	if type == "Percent":
		if increase == true:
			var new_income = (current_income * value/100) + current_income
			MayorMoney["ToEarn"] = new_income
			#set_meta("money_to_earn",new_income)
			print("Increased mayor money to " + str(new_income))
		else:
			var new_income = current_income - (current_income * value/100)
			MayorMoney["ToEarn"] = new_income
			print("Decreased mayor money to " + str(new_income))
	else:
		push_warning("Couldn't find type " + type + " for mayor_income")

func increase_worker_income(type: String, value: float, increase:bool) -> void:
	var current_income = WorkerMoney["ToEarn"]
	if type == "Percent":
		if increase == true:
			var new_income = (current_income * value/100) + current_income
			WorkerMoney["ToEarn"] = new_income
			#set_meta("money_to_earn",new_income)
			print("Increased worker money to " + str(new_income))
		else:
			var new_income = current_income - (current_income * value/100)
			WorkerMoney["ToEarn"] = new_income
			print("Decreased worker money to " + str(new_income))
	else:
		push_warning("Couldn't find type " + type + " for worker_income")
