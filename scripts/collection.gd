extends Node2D


class_name Coll

@export var Items: Array[Sprite2D]
@export var CNBT: Array[TextureButton]

var Inventory = []

var page = 0

func updInv():
	var visualInv = Inventory.slice(page*6, page*6+6)
	var iid = 0
	for item in visualInv:
		var canvas = CanvasTexture.new()
		canvas.diffuse_texture = $"../lombard/Table/Item".textures[item]
		canvas.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		Items[iid].texture = canvas
		Items[iid].visible = true
		var CUNT = CanvasTexture.new()
		CUNT.diffuse_texture = load("res://assets/cell.png")
		CUNT.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		CNBT[iid].texture_normal = CUNT
		var taxi = CNBT[iid].get_node("faketaxi")
		taxi.visible = true
		taxi.get_node("Label").text = "$" + str($"../lombard/Table/Item".prices[item])
		iid += 1
		pass
	while iid < 6:
		var canvas = CanvasTexture.new()
		canvas.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		Items[iid].texture = canvas
		Items[iid].visible = false
		var CUNT = CanvasTexture.new()
		CUNT.diffuse_texture = load("res://assets/EMPTYBLYAT.png")
		CUNT.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		CNBT[iid].texture_normal = CUNT
		var taxi = CNBT[iid].get_node("faketaxi")
		taxi.visible = false
		iid += 1
	pass
