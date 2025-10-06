extends Node2D


class_name Coll

@export var inv: Inv
@export var Items: Array[Sprite2D]
@export var CNBT: Array[TextureButton]
@export var craftCell: TextureButton
@export var hideBtn: Button
@export var Recipe: Array[Sprite2D]
@export var Fin: TextureButton

var Inventory = []

var stage = 0
var craft_complete = false
var stage_complete = false

var textures = [
	preload("res://assets/items/RAREDISK.png"),
	preload("res://assets/items/gameboy.png"),
	preload("res://assets/items/vase-full.png")
]

var troph = [
	preload("res://assets/items/cup_music.png"),
	preload("res://assets/items/cup_gaming.png"),
	preload("res://assets/items/FINAL.png")
]

var nitems = [
	[8,9,10],
	[17,18,19],
	[0,4,5]
]

var crafts = [
	[11,12,13],
	[20,21,22],
	[14,15,16]
]

var current_build = []


func updInv():
	var visualInv = Inventory.slice(0, 3)
	var iid = 0
	
	for item in visualInv:
		var canvas = CanvasTexture.new()
		canvas.diffuse_texture = $"../lombard/Table/Item".textures[item]
		canvas.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		Items[iid].texture = canvas
		Items[iid].visible = true

		var cell_texture = CanvasTexture.new()
		cell_texture.diffuse_texture = load("res://assets/GOLD.png")
		cell_texture.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		CNBT[iid].texture_normal = cell_texture
		iid += 1
	
	# очистка оставшихся пустых ячеек
	while iid < 3:
		var canvas = CanvasTexture.new()
		canvas.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		Items[iid].texture = canvas
		Items[iid].visible = false

		var empty_texture = CanvasTexture.new()
		empty_texture.diffuse_texture = load("res://assets/EMPTYBLYAT.png")
		empty_texture.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		CNBT[iid].texture_normal = empty_texture
		iid += 1
		
func craft():
	var done = []
	if stage >= 3:
		return
	for itm in crafts[stage]:
		if itm in inv.Inventory and itm not in done:
			done.append(itm)
			pass
		pass
	if done.size() == 3:
		craft_complete = true
		var cell_texture = CanvasTexture.new()
		cell_texture.diffuse_texture = load("res://assets/SILVER.png")
		cell_texture.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		craftCell.texture_normal = cell_texture
		var item_texture = CanvasTexture.new()
		item_texture.diffuse_texture = textures[stage]
		item_texture.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		craftCell.get_node("Item").texture = item_texture
		craftCell.get_node("Item").visible = true
		updCol()
	else:
		var i = 0
		for itm in Recipe:
			var canvas = CanvasTexture.new()
			var id = crafts[stage][i]
			canvas.diffuse_texture = $"../lombard/Table/Item".textures[id]
			canvas.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
			itm.texture = canvas
			i += 1
			pass
		hideBtn.visible = true
		pass
	pass

func updCol():
	Inventory = []
	if stage == 3:
		return
	for id in inv.Inventory:
		if id in nitems[stage] and id not in Inventory:
			Inventory.append(id)
			pass
		pass
	updInv()
	if craft_complete and Inventory.size() == 3:
		var item_texture = CanvasTexture.new()
		item_texture.diffuse_texture = troph[stage]
		item_texture.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		Fin.get_node("Item").texture = item_texture
		Fin.get_node("Item").visible = true
		stage_complete = true
		if stage == 0:
			$Sprite2D2.visible = true
		elif stage == 1:
			$Sprite2D3.visible = true
		elif stage == 2:
			$Sprite2D4.visible = true
	pass


func _on_craft_button_down() -> void:
	craft()
	pass # Replace with function body.


func _on_hide_button_down() -> void:
	hideBtn.visible = false
	pass # Replace with function body.


func _on_FIN_button_down() -> void:
	if stage_complete:
		stage += 1
		if stage == 3:
			$"..".anim_player.play_backwards("down_collection")
			$"..".finish_game()
			return
		craft_complete = false
		stage_complete = false
		Inventory = []
		updCol()
		Fin.get_node("Item").visible = false
		var cell_texture = CanvasTexture.new()
		cell_texture.diffuse_texture = load("res://assets/CRAFT.png")
		cell_texture.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		craftCell.texture_normal = cell_texture
		craftCell.get_node("Item").visible = false
		print("STAGE COMPLETE")
		pass
	pass # Replace with function body.
