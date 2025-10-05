extends Node2D

var animstate = 0
var money = 0
var day = 0
var time = 0
var fade_speed = 10

@export var money_label: Label
var current_track: AudioStreamPlayer = null

@export var track_main: AudioStreamPlayer
@export var track_piano: AudioStreamPlayer
@export var track_bass: AudioStreamPlayer

func _on_ready() -> void:
	print("PROTOCOL GOYDA INITIALIZED")
	for track in [track_main, track_piano, track_bass]:
		track.volume_db = -80
		track.play()
	set_active_track(0)
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


func set_active_track(new_track: int):
	if current_track == [track_main, track_piano, track_bass][new_track]:
		return
	current_track = [track_main, track_piano, track_bass][new_track]

func _process(delta):
	for track in [track_main, track_piano, track_bass]:
		var target_volume = 0.0 if track == current_track else -80.0
		track.volume_db = lerp(track.volume_db, target_volume, delta * fade_speed)


func _on_button_2_button_down() -> void:
	updMoney(money+100)
	pass # Replace with function body.


func _on_inventory_button_button_down() -> void:
	$lombard/Character/model/AnimationPlayer.play("down")
	set_active_track(2)
	pass # Replace with function body.
