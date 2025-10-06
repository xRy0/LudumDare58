extends Node2D

var animstate = 0
@export var money = 0
var day = 0
var time = 0

@export var money_label: Label
var previous_track: AudioStreamPlayer = null
var current_track: AudioStreamPlayer = null
var track_index = 1;


@export var track_main: AudioStreamPlayer
@export var track_piano: AudioStreamPlayer
@export var track_bass: AudioStreamPlayer
@export var fade_speed = 1.0
@export var fade_curve: Curve
@export var sound_enabled: bool = true
var fade_t := 0.0
var fading := false

var sfx = {
	"sell": "res://assets/snd/snd_sell.ogg",
	"took": "res://assets/snd/snd_took.ogg",
	"reject": "res://assets/snd/snd_rejected.ogg"
}

var game_start_time: int
var game_end_time: int
var game_time: float

func playsfx(sound, pitched = false):
	if not sound_enabled:
		return
	if not sfx.has(sound):
		print("sfx not found")
		return
	var stream = load(sfx[sound])
	if not stream:
		print("failed to load sfx " + sound)
		return
	
	$sfxplayer.stop()
	$sfxplayer.stream = stream
	$sfxplayer.pitch_scale = randf_range(0.80, 1.20) if pitched else 1
	$sfxplayer.volume_db = 2.0
	$sfxplayer.play()
	pass


func _on_ready() -> void:
	for track in [track_main, track_piano, track_bass]:
		track.volume_db = -80
		track.play()
	current_track = track_piano
	previous_track = track_bass
	current_track.volume_db = 0.0 if sound_enabled else -80.0
	$TextureButton.button_pressed = sound_enabled
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


func set_active_track(new_track: int):
	track_index = new_track
	var requested_track: AudioStreamPlayer = [track_main, track_piano, track_bass][new_track]
	if requested_track == track_main:
		$lombard/Character.typing_muted = false
	else: 
		$lombard/Character.typing_muted = true
	
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
	
	var max_snd = 0.0 if sound_enabled else -80.0
	if current_track == track_bass:
		track_piano.volume_db = lerp(max_snd, -80.0, fade_out_val)
		track_main.volume_db = lerp(max_snd, -80.0, fade_out_val)
	elif current_track == track_piano:
		track_bass.volume_db = lerp(max_snd, -80.0, fade_out_val)
		track_main.volume_db = lerp(max_snd, -80.0, fade_out_val)
	elif current_track == track_main:
		track_piano.volume_db = lerp(max_snd, -80.0, fade_out_val)
		track_bass.volume_db = lerp(max_snd, -80.0, fade_out_val)
	if current_track:
		current_track.volume_db = lerp(-80.0, max_snd, fade_in_val)


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


func _on_texture_button_toggled(toggled_on: bool) -> void:
	sound_enabled = toggled_on
	if sound_enabled:
		set_active_track(track_index)
		$lombard/Character.typing_muted = false
	else:
		track_main.volume_db = -80.0
		track_piano.volume_db = -80.0
		track_bass.volume_db = -80.0
	pass # Replace with function body.


func format_time(ms: int) -> String:
	var total_sec = ms / 1000
	var hours = total_sec / 3600
	var minutes = (total_sec % 3600) / 60
	var seconds = total_sec % 60
	var msc = ms % 1000
	if hours > 0:
		return "%02d:%02d:%02d.%03d" % [hours, minutes, seconds, msc]
	else:
		return "%02d:%02d.%03d" % [minutes, seconds, msc]

func finish_game() -> void:
	var elapsed_ms = Time.get_ticks_msec() - game_start_time
	var formatted_time = format_time(elapsed_ms)
	$FinishGame/Time.text = "Time elapsed: " + formatted_time
	$FinishGame/Money.text = "Money left: $" + str(money)
	$FinishGame.visible = true
	

func _on_game_start_button_down() -> void:
	$lombard/Table/Table_PC/Name.text = ""
	$lombard/Table/Table_PC/Price.text = ""
	$lombard/Table/Table_PC/GameStart.visible = false
	$lombard/Table/Table_PC/GameStart.disabled = true
	game_start_time = Time.get_ticks_msec()
	anim_player.play("start_game")
	updMoney(money)
	current_track = track_main
	previous_track = track_bass
	current_track.volume_db = 0.0 if sound_enabled else -80.0
	await sleep(0.5)
	$lombard/Character.come_and_offer()
	pass # Replace with function body.
