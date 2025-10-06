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

var customers = [
	{
		"asset": load("res://assets/dude.png"),
		"voice": "male"
	},
	{
		"asset": load("res://assets/dude2.png"),
		"voice": "male"
	},
	{
		"asset": load("res://assets/dude3.png"),
		"voice": "male"
	},
]

@export var visual_node_path: NodePath
@export var animation_player_path: NodePath
@export var chat_text: RichTextLabel
@export var typer_sounds: AudioStreamPlayer
@export var take_button: TextureButton
@export var reject_button: TextureButton
@export var chatbox: Sprite2D
@export var inventory: Inv
@export var type_speed: float = 0.03

@onready var item = $"../Table/Item"

var visual_node: Node = null
var anim_player: AnimationPlayer = null

var offer_price = 0

var cur_customer = null
var full_text: String = "I forgot what i wanted to say!"
var display_text: String = ""
var i = 0
var typing = false
var typing_muted = false
var male_sound_paths = [
	"res://assets/snd/TXT/SND_MAN_TXT1.ogg",
	"res://assets/snd/TXT/SND_MAN_TXT2.ogg",
	"res://assets/snd/TXT/SND_MAN_TXT3.ogg",
	"res://assets/snd/TXT/SND_MAN_TXT4.ogg"
]

var female_sound_paths = [
	"res://assets/snd/TXT/SND_WOM_TXT1.ogg",
	"res://assets/snd/TXT/SND_WOM_TXT2.ogg",
	"res://assets/snd/TXT/SND_WOM_TXT3.ogg",
	"res://assets/snd/TXT/SND_WOM_TXT4.ogg"
]


func start_typing(new_text: String):
	full_text = new_text
	display_text = ""
	i = 0
	typing = true
	chat_text.text = ""
	typing_loop()

func play_type_snd():
	if typing_muted:
		return
	if typer_sounds == null:
		print("no typer_sounds instance")
		return
	var snd_list = female_sound_paths if cur_customer.voice == "female" else male_sound_paths
	
	if snd_list.is_empty():
		return
	
	var random_sound_path = snd_list.pick_random()
	var random_sound: AudioStream = load(random_sound_path)
	typer_sounds.stream = random_sound
	typer_sounds.pitch_scale = randf_range(1, 1.20) if cur_customer.voice == "male" else randf_range(0.70, 1)
	typer_sounds.volume_db = -5.0
	typer_sounds.play()


func typing_loop():
	while typing and i < full_text.length():
		var ch = full_text[i]
		if ch == "[":
			var end = full_text.find("]", i)
			if end != -1:
				var tag = full_text.substr(i, end - i + 1)
				display_text += tag
				i = end + 1
				chat_text.text = display_text
				continue
		display_text += ch
		chat_text.text = display_text
		i += 1
		play_type_snd()
		await get_tree().create_timer(1 / type_speed).timeout
	typing = false



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
	cur_customer = customers.pick_random()
	var CUNT = CanvasTexture.new()
	CUNT.diffuse_texture = cur_customer.asset
	CUNT.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	$model.texture = CUNT
	
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
	anim_player.play("new_guy_coming")
	await anim_player.animation_finished
	chatbox.visible = true
	start_typing(get_message("enter_message", price))
	


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
		start_typing(get_message("thanks_message"))
		while typing:
			await get_tree().create_timer(1 / type_speed).timeout
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
		start_typing(get_message("trade_message", price))
	else:
		take_button.visible = false
		reject_button.visible = false
		start_typing(get_message("leave_message"))
		while typing:
			await get_tree().create_timer(1 / type_speed).timeout
		anim_player.play("guy_leave")
		await anim_player.animation_finished
		chatbox.visible = false
		item.hide_item()
		come_and_offer()
	pass # Replace with function body.
