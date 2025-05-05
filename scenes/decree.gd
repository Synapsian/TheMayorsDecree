extends CanvasLayer

#signal set_player_meta(name:StringName, value:Variant)
signal increase_player_income(type:String, value:float)
signal on_decree_finished()
@onready var list = $container/list
@onready var tasks = Tasks
var amountOfDecrees = 1
var buffs = [
"You gain increased money at the end of the day",
"Your taxes are decreased by -10%",
"New factories are created, gaining more cash",
]

var debuffs = [
"The money is taken out of worker's wage",
"Worker taxes have to be increased by +10%",
"People are unhappy about this",
]

func _ready() -> void:
	visible = false

func _give_effects(buff_index:int,to_free:Array):
	print("Give effects, index: " + str(buff_index))
	if buff_index == 0:
		print("Decreasing worker wage")
		MoneyHandler.change_wage(-5)

	elif buff_index == 1:
		print("Lowering Mayor taxes by 10")
		MoneyHandler.increase_taxes(-10,"Mayor")
		print("Increasing Worker taxes by 10")
		MoneyHandler.increase_taxes(10,"Worker")
		
	elif buff_index == 2:
		print("Increasing mayor money gain")
		MoneyHandler.increase_income("Mayor",100.0,"Add")
		print("Lowering happiness")
		var current_happpiness = HappinessMeter.get_happiness()
		HappinessMeter.set_happiness(current_happpiness - 20)
		
	_remove_decree(to_free)

func _remove_decree(to_free:Array):
	for item in to_free:
		item.queue_free()
	
	if amountOfDecrees <= 1:	
		HappinessMeter.hide()
		GoldMeter.hide()
		visible = false
		tasks.show()
		on_decree_finished.emit()
		#new_decree()
	else:
		new_decree(amountOfDecrees - 1)

func new_decree(amount:int):
	amountOfDecrees = amount
	HappinessMeter.visible = true
	GoldMeter.visible = true
	visible = true
	tasks.hide()
	
	var new_buff = Label.new()
	var buff_index = randi() % buffs.size()
	new_buff.text = "+ " + buffs[buff_index]
	new_buff.modulate = Color(0,255,0)
	var new_debuff = Label.new()
	#var debuff_index = randi() % debuffs.size()
	new_debuff.text = "- " + debuffs[buff_index]
	new_debuff.modulate = Color(255,0,0)
	
	list.add_child(new_buff)
	list.add_child(new_debuff)
	
	var accept_button = Button.new()
	accept_button.text = "ACCEPT"
	list.add_child(accept_button)
	
	var decline_button = Button.new()
	decline_button.text = "DECLINE"
	list.add_child(decline_button)
	
	decline_button.pressed.connect(_remove_decree.bind([new_buff,new_debuff,accept_button,decline_button]))
	accept_button.pressed.connect(_give_effects.bind(buff_index,[new_buff,new_debuff,accept_button,decline_button]))
