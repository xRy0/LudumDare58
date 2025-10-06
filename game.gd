extends Node2D

var animstate = 0
@export var money = 0
var day = 0
var time = 0

@export var money_label: Label
var previous_track: AudioStreamPlayer = null
var current_track: AudioStreamPlayer = null

@export var track_main: AudioStreamPlayer
@export var track_piano: AudioStreamPlayer
@export var track_bass: AudioStreamPlayer
@export var fade_speed = 1.0
@export var fade_curve: Curve
var fade_t := 0.0
var fading := false


func _on_ready() -> void:
	updMoney(money)
	print("PROTOCOL GOYDA INITIALIZED")
	for track in [track_main, track_piano, track_bass]:
		track.volume_db = -80
		track.play()
	current_track = track_main
	previous_track = track_bass
	current_track.volume_db = 0
	await sleep(2)
	$lombard/Character.come_and_offer()
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
	var requested_track: AudioStreamPlayer = [track_main, track_piano, track_bass][new_track]
	if current_track == requested_track:
		return
	previous_track = current_track
	current_track = requested_track
	if previous_track == null:
		previous_track = track_bass
	fade_t = 0.0
	fading = true

func _process(delta):
	if not fading:
		return
	fade_t += delta / fade_speed
	if fade_t >= 1.0:
		fade_t = 1.0
		fading = false

	var fade_in_time = fade_speed * 0.2
	var fade_out_time = fade_speed * 2.6

	var fade_in_val = fade_curve.sample(min(fade_t / fade_in_time, 1.0))
	var fade_out_val = fade_curve.sample(min(fade_t / fade_out_time, 1.0))
	if previous_track:
		previous_track.volume_db = lerp(0.0, -80.0, fade_out_val)
	if current_track:
		current_track.volume_db = lerp(-80.0, 0.0, fade_in_val)


func _on_button_2_button_down() -> void:
	updMoney(money+100)
	pass # Replace with function body.

@onready var anim_player = $SceneAnimator

func _on_inventory_button_button_down() -> void:
	if (anim_player.current_animation == "down" or anim_player.current_animation == "down_collection"):
		return
	anim_player.play("down")
	set_active_track(2)
	pass # Replace with function body.

func _on_collection_button_2_button_down() -> void:
	if (anim_player.current_animation == "down" or anim_player.current_animation == "down_collection" or anim_player.current_animation == "side_to_collection"):
		return
	anim_player.play("down_collection")
	set_active_track(1)
	pass # Replace with function body.


func _on_up_btn_2_button_down() -> void:
	if (anim_player.current_animation == "down" or anim_player.current_animation == "down_collection" or anim_player.current_animation == "side_to_collection"):
		return
	anim_player.play_backwards("down_collection")
	set_active_track(0)
	pass # Replace with function body.


func _on_r_btn_button_down() -> void:
	if (anim_player.current_animation == "down" or anim_player.current_animation == "down_collection" or anim_player.current_animation == "side_to_collection"):
		return
	anim_player.play("side_to_collection")
	set_active_track(1)
	pass # Replace with function body.


func _on_l_btn_button_down() -> void:
	if (anim_player.current_animation == "down" or anim_player.current_animation == "down_collection" or anim_player.current_animation == "side_to_collection"):
		return
	anim_player.play_backwards("side_to_collection")
	set_active_track(2)
	pass # Replace with function body.
