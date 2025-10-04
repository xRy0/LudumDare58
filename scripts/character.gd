extends Node

class_name CharacterBase

@export var visual_node_path: NodePath
@export var animation_player_path: NodePath

var visual_node: Node = null
var anim_player: AnimationPlayer = null

func _ready():
	if visual_node_path:
		visual_node = get_node(visual_node_path)
	else:
		push_warning("visual_node_path не задан!")

	if animation_player_path:
		anim_player = get_node(animation_player_path)
	else:
		push_warning("animation_player_path не задан!")

func play_animation(name: String, custom_blend: float = -1.0, custom_speed: float = 1.0, from_end: bool = false):
	if anim_player and anim_player.has_animation(name):
		anim_player.play(name, custom_blend, custom_speed, from_end)
	else:
		push_warning("Анимация '%s' не найдена или AnimationPlayer не подключён." % name)

func stop_animation():
	if anim_player:
		anim_player.stop()
