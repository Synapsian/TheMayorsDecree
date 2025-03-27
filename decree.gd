extends Node2D

@onready var list = $container/list
@onready var tasks = Tasks
var buffs = ["You will gain +20% money at the end of the day","End Hunger"]
var debuffs = ["People will be unhappy at the raise in taxes","Lose 5 dollars every paycheck"]

func _ready() -> void:
	visible = false
	new_decree()

func _give_effects(buff_index:int,to_free:Array):
	print("Give effects, index: " + str(buff_index))
	if buff_index == 0:
		print("Give buff 0 effects")
	_remove_decree(to_free)

func _remove_decree(to_free:Array):
	for item in to_free:
		item.queue_free()
	visible = false
	tasks.show()

func new_decree():
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
