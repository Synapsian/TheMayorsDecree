extends Node2D

var MayorMoney = {"Amount":1000,'Income':100,'Taxes':10}
var WorkerMoney = {"Amount":100,'Income':10,'Taxes':10}
var WorkerWage = 15

func end_of_day_income():
	var worker_taxes = WorkerMoney['Taxes']
	var current_worker_income = WorkerMoney['Income']
	var taxed_worker_income = current_worker_income - (current_worker_income * worker_taxes/100)
	WorkerMoney['Income'] = 0
	WorkerMoney['Amount'] = WorkerMoney['Amount'] + taxed_worker_income
	
	var mayor_taxes = MayorMoney['Taxes']
	var current_mayor_income = MayorMoney['Income']
	var taxed_mayor_income = current_mayor_income - (current_mayor_income * mayor_taxes/100)
	MayorMoney['Income'] = 0
	MayorMoney['Amount'] = MayorMoney['Amount'] + taxed_mayor_income

func get_wage():
	return WorkerWage

func change_wage(amount:float):
	WorkerWage += amount
	WorkerWage = clampf(WorkerWage,1,100)

func increase_income(playerType:String,amount:float,increaseType:String):
	var playerDict;
	if playerType == "Mayor": playerDict = MayorMoney
	elif playerType == "Worker": playerDict = WorkerMoney
	if not playerDict: push_error("Incorrect player type given in increase_income in money_handler.gd ... Use Mayor or Worker."); return
	
	if increaseType == 'Add':
		playerDict['Income'] = playerDict['Income'] + amount
		print("Changed income to " + str(playerDict['Income']))
	else:
		push_error("Incorrect increaseType given in increase_income in money_handler.gd")

func increase_taxes(amount:float,whoToEffect:String):
	var playerDict;
	if whoToEffect == "Mayor": playerDict = MayorMoney
	elif whoToEffect == "Worker": playerDict = WorkerMoney
	else: push_error("Increase_Taxes has only two effects: Mayor,Worker"); return
	
	playerDict['Taxes'] = playerDict['Taxes'] + amount
