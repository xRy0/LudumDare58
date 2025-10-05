extends Node

class_name CharacterBase

@export var visual_node_path: NodePath
@export var animation_player_path: NodePath
@export var chat_text: RichTextLabel
@export var take_button: Button
@export var reject_button: Button
@export var chatbox: Sprite2D

var visual_node: Node = null
var anim_player: AnimationPlayer = null

var offer_price = 0

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

func come_and_offer():
	var price = randi() % 100
	offer_price = price
	take_button.text = "Взять - $" + str(price)
	anim_player.play("new_guy_coming")
	await anim_player.animation_finished
	chatbox.visible = true
	$"../Table/Item".choose_random_item()


func _on_take_button_down() -> void:
	var mainnode = $"../.."
	if mainnode.updMoney(mainnode.money - offer_price) == 0:
		print("asd")
		chatbox.visible = false
		$"../Table/Item".hide_item()
		anim_player.play("guy_leave")
		await anim_player.animation_finished
		come_and_offer()
		pass
	pass # Replace with function body.


func _on_reject_button_down() -> void:
	var chance = randi() % 100
	print(chance)
	if chance > 50:
		chat_text.text = """[color=#000000]Блин [i]мне очень нужны[/i]
[color=#ff0000][b]БАБКИ[/b][/color]
Давай скину пару баксов...[/color]"""
		var price = randi() % offer_price
		offer_price = price
		take_button.text = "Взять - $" + str(price)
	else:
		chat_text.text = """[b][color=#900000]ДА ПОШËЛ ТЫ[/color][/b]"""
		anim_player.play("guy_leave")
		await anim_player.animation_finished
		chatbox.visible = false
		$"../Table/Item".hide_item()
		chat_text.text = """[color=#000000]Йоу чувак, зацени [b]ЭТО
[/b]Отрыл на хате у своей
бабули, выглядит [b][color=#ff0000]дорого[/color][/b][/color]"""
		come_and_offer()
	pass # Replace with function body.
