extends Node2D

var MayorMoney = {"Amount":1000,"ToEarn":100}
var WorkerMoney = {"Amount":100,"ToEarn":10}

func increase_mayor_income(type: String, value: float) -> void:
	var current_income = MayorMoney["ToEarn"]
	if type == "Percent":
		var new_income = (current_income * value/100) + current_income
		MayorMoney["ToEarn"] = new_income
		#set_meta("money_to_earn",new_income)
		print("Increased money to " + str(new_income))
	else:
		push_warning("Couldn't find type " + type + " for mayor_income")
