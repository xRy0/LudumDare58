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
		preload("res://assets/item_bust.png"),
		preload("res://assets/item_chasi.png"),
		preload("res://assets/item_kniga.png"),
		preload("res://assets/item_krujka.png"),
		preload("res://assets/item_kuvshin.png"),
		preload("res://assets/item_svitok.png")
	]

	prices = [300, 500, 150, 50, 350, 450]
	descriptions = [
		"Bust of a famous person",
		"Antique clock",
		"Fragile book",
		"Beer mug",
		"Strange jug",
		"Elder scroll",
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
