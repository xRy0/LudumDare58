extends Node

class_name CharacterBase

var customer_messages = {
	"enter_message": [
		"[color=#000000]Hey! Look what I dug up in the attic.[b] Looks rare![/b]\n[b]I offer $%PRICE%[/b][/color]",
		"[color=#000000]Yo, got something [b][color=#ff0000]special[/color][/b] here! Could be worth a lot.\n[b]I offer $%PRICE%[/b][/color]",
		"[color=#000000]Found this old thing, thought you might be interested.\n[b]I offer $%PRICE%[/b][/color]",
		"[color=#000000]Check it out! My buddy said it’s valuable... maybe you can tell me?\n[b]I offer $%PRICE%[/b][/color]"
	],
	"trade_message": [
		"[color=#ff0000][b]Need cash fast![/b] I can let it go for a little less...\n[b]I offer $%PRICE%[/b][/color]",
		"[color=#ff0000]Come on, I trust you! Maybe I could bump the price a bit down?\n[b]I offer $%PRICE%[/b][/color]",
		"[color=#ff0000][i]I’m kinda desperate here[/i], maybe we can work out a deal?\n[b]I offer $%PRICE%[/b][/color]",
		"[color=#ff0000]If you give me a good offer, I’ll let it go [b]right now[/b]!\n[b]I offer $%PRICE%[/b][/color]"
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

func get_message(key: String, price: int = 0):
	if (customer_messages[key]):
		return String(customer_messages[key].pick_random()).replacen("%PRICE%", str(price))
	else:
		return "no_msg_" + key

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
	var avg_price = item.prices[item.current_index]
	var price
	if randi_range(1, 4) == 1:
		var AHHHHHHHH = int(avg_price / 100.0 * randi_range(1,10))
		price = avg_price + (AHHHHHHHH)
	else:
		var AHHHHHHHH = int(avg_price / 100.0 * randi_range(1,10))
		price = avg_price - (AHHHHHHHH)
	if randi_range(0,100) <= 3:
		price = price / randi_range(3,10)
	offer_price = price
	chat_text.text = get_message("enter_message", price)
	anim_player.play("new_guy_coming")
	await anim_player.animation_finished
	chatbox.visible = true
	


func _on_take_button_down() -> void:
	var mainnode = $"../.."
	if $"../../inventory".Inventory.size() > 5:
		return
	if mainnode.updMoney(mainnode.money - offer_price) == 0:
		take_button.visible = false
		reject_button.visible = false
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
	var avg_price = item.prices[item.current_index]
	var minus = int((offer_price / 100.0) * randi_range(1,10))
	var price = offer_price - minus
	var chance = randi_range(1,3)
	print(price)
	print(minus)
	print(chance)
	if (avg_price / 3) * 2 < price and chance >= 2:
		offer_price = price
		chat_text.text = get_message("trade_message", price)
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
