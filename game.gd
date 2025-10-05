extends Node2D

var animstate = 0
var money = 0
var day = 0
var time = 0

@export var money_label: Label

func _on_ready() -> void:
	print("PROTOCOL GOYDA INITIALIZED")
	pass # Replace with function body.

func sleep(sec):
	await get_tree().create_timer(sec).timeout
	
func updMoney(newBalance):
	if newBalance < 0:
		return 1
	money = newBalance
	money_label.text = str(newBalance)
	return 0

func _on_button_button_down() -> void:
	# TODO rewrite this shit in class, or better trow it away
	$lombard/Character.come_and_offer()
	pass # Replace with function body.


	


func _on_button_2_button_down() -> void:
	updMoney(money+100)
	pass # Replace with function body.
