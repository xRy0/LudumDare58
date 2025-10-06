extends Node

class_name CharacterBase

var customer_messages = {
	"enter_message": [
		"[color=#000000]Hey! Look what I dug up in the attic.[b] Looks rare![/b]\n[i]I offer %PRICE%[/i][/color]",
		"[color=#000000]Yo, got something [b][color=#ff0000]special[/color][/b] here! Could be worth a lot.[i]I offer $%PRICE%[/i][/color]",
		"[color=#000000]Found this old thing, thought you might be interested.[i]I offer $%PRICE%[/i][/color]",
		"[color=#000000]Check it out! My buddy said it’s valuable... maybe you can tell me?[i]I offer $%PRICE%[/i][/color]"
	],
	"trade_message": [
		"[color=#ff0000][b]Need cash fast![/b][/color] I can let it go for a little less...",
		"[color=#ff0000]Come on, I trust you! Maybe I could bump the price a bit down?[/color]",
		"[color=#ff0000][i]I’m kinda desperate here[/i], maybe we can work out a deal?[/color]",
		"[color=#ff0000]If you give me a good offer, I’ll let it go [b]right now[/b]![/color]"
	],
	"leave_message": [
		"[b][color=#900000]Nah, not interested.[/color][/b]",
		"[b][color=#900000]Forget it, maybe next time.[/color][/b]",
		"[b][color=#900000]Eh, your offer sucks![/color][/b]",
		"[b][color=#900000]I’ll try somewhere else.[/color][/b]"
	],
	"thanks_message": [
		"[b][color=#008000]Thanks a lot! That’s a fair deal![/color][/b]",
		"[b][color=#008000]Appreciate it! Couldn’t ask for better![/color][/b]",
		"[b][color=#008000]Great doing business with you![/color][/b]",
		"[b][color=#008000]Sweet! I’m happy with that![/color][/b]"
	]
}

@export var visual_node_path: NodePath
@export var animation_player_path: NodePath
@export var chat_text: RichTextLabel
@export var take_button: TextureButton
@export var reject_button: TextureButton
@export var chatbox: Sprite2D
@export var inventory: Inv

@onready var item = $"../Table/Item"

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

func get_message(key: String):
	if (customer_messages[key]):
		return customer_messages[key].pick_random()
	else:
		return "no_msg_" + key
	pass

func play_animation(name: String, custom_blend: float = -1.0, custom_speed: float = 1.0, from_end: bool = false):
	await anim_player.animation_finished
	if anim_player and anim_player.has_animation(name):
		anim_player.play(name, custom_blend, custom_speed, from_end)
	else:
		push_warning("Анимация '%s' не найдена или AnimationPlayer не подключён." % name)

func stop_animation():
	if anim_player:
		anim_player.stop()

func come_and_offer():
	item.choose_random_item()
	take_button.visible = true
	reject_button.visible = true
	chat_text.text = get_message("enter_message")
	var avg_price = item.prices[item.current_index]
	var price = (randi() % 100) + 1
	offer_price = price
	take_button.get_child(0).text = "Take - $" + str(price)
	anim_player.play("new_guy_coming")
	await anim_player.animation_finished
	chatbox.visible = true
	


func _on_take_button_down() -> void:
	var mainnode = $"../.."
	if mainnode.updMoney(mainnode.money - offer_price) == 0:
		print("asd")
		inventory.addItem(item)
		item.hide_item()
		chat_text.text = get_message("thanks_message")
		anim_player.play("guy_leave")
		await anim_player.animation_finished
		chatbox.visible = false
		come_and_offer()
		pass
	pass # Replace with function body.


func _on_reject_button_down() -> void:
	var chance = randi() % 100
	print(chance)
	if chance > 50:
		chat_text.text = get_message("trade_message")
		var price = (randi() % offer_price) + 1
		offer_price = price
		take_button.get_child(0).text = "Take - $" + str(price)
	else:
		take_button.visible = false
		reject_button.visible = false
		chat_text.text = get_message("leave_message")
		anim_player.play("guy_leave")
		await anim_player.animation_finished
		chatbox.visible = false
		item.hide_item()
		come_and_offer()
	pass # Replace with function body.
