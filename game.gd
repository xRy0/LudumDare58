extends Node2D

var animstate = 0

func _on_ready() -> void:
	print("goyda")
	pass # Replace with function body.

func sleep(sec):
	await get_tree().create_timer(sec).timeout

func _on_button_button_down() -> void:
	# TODO rewrite this shit in class, or better trow it away
	if animstate == 0:
		$lombard/Character.play_animation("new_guy_coming")
		animstate = 1
	else:
		$lombard/Character.play_animation("guy_leave")
		animstate = 0
	pass # Replace with function body.


	
