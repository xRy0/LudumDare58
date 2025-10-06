extends Node

# Синглтон-класс предмета

class_name Item

@export var current_texture: Sprite2D
@export var current_price: Label
@export var current_description: Label
var current_index: int

var textures: Array[Texture] = []
var prices: Array[int] = []
var descriptions: Array[String] = []


func _ready():
	textures = [
		preload("res://assets/items/item_bust.png"),
		preload("res://assets/items/item_chasi.png"),
		preload("res://assets/items/item_kniga.png"),
		preload("res://assets/items/item_krujka.png"),
		preload("res://assets/items/item_kuvshin.png"),
		preload("res://assets/items/item_svitok.png"),
		preload("res://assets/items/hat.png"),
		preload("res://assets/items/stopsign.png"),
		preload("res://assets/items/Kino.png"),
		preload("res://assets/items/monet.png"),
		preload("res://assets/items/tvgirl.png"),
		preload("res://assets/items/unknown disk box.png"),
		preload("res://assets/items/unknown disk note.png"),
		preload("res://assets/items/unknown disk.png"),
		preload("res://assets/items/vase-ch1.png"),
		preload("res://assets/items/vase-ch2.png"),
		preload("res://assets/items/vase-ch3.png"),
		preload("res://assets/items/switch.png"),
		preload("res://assets/items/box360.png"),
		preload("res://assets/items/ps3.png"),
		preload("res://assets/items/gameboy.png")
		]
			#                              v hat here
	prices = [300, 500, 150, 50, 350, 450, 50, 40, 450, 400, 350, 50, 50, 50,
			  50, 50, 50, 550, 500, 500]
			# ^ vase      ^ consoles
	descriptions = [
		"Bust of a famous person",
		"Antique clock",
		"Fragile book",
		"Beer mug",
		"Strange jug",
		"Elder scroll",
		"Hat",
		"Stop sign",
		"Kino Vinyl",
		"Forbidden Vinyl",
		"TVGirl Vinyl",
		"Unknown Disk Box",
		"Unknown Disk Note",
		"Unknown Vinyl Disk",
		"Vase Shard",
		"Vase Shard",
		"Vase Shard",
		"Funtendo Console",
		"MC xStep 365 Console",
		"SP3 Console"
	]

	# Убедимся, что массивы синхронизированы по длине
	assert(textures.size() == prices.size() and prices.size() == descriptions.size())

func choose_random_item():
	if textures.is_empty():
		push_error("Нет доступных предметов для выбора.")
		return

	var index = randi() % textures.size()
	current_index = index
	var canvas = CanvasTexture.new()
	canvas.diffuse_texture = textures[index]
	canvas.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	current_texture.texture = canvas
	current_price.text = "sell price - $" + str(prices[index])
	current_description.text = descriptions[index]
	current_texture.visible = true
	
func hide_item():
	current_price.text = ""
	current_description.text = ""
	current_texture.visible = false
