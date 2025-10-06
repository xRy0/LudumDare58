extends Node

class_name Inv

@export var Items: Array[Sprite2D]

var Inventory = []

var page = 0

func addItem(item: Item):
	Inventory.append(item.current_index)
	updInv()
	pass
	
func sellItem(id: int) -> void:
	print(id)
	var item = Inventory.pop_at(page*8+id)
	if (not item):
		return;
	updInv()
	var mainnode = $".."
	mainnode.updMoney(mainnode.money + $"../lombard/Table/Item".prices[item])
	pass
	
func updInv():
	var visualInv = Inventory.slice(page*8, page*8+8)
	var iid = 0
	for item in visualInv:
		var canvas = CanvasTexture.new()
		canvas.diffuse_texture = $"../lombard/Table/Item".textures[item]
		canvas.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		Items[iid].texture = canvas
		iid += 1
		pass
	while iid < 8:
		var canvas = CanvasTexture.new()
		canvas.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		Items[iid].texture = canvas
		iid += 1
	pass

func _on_up_btn_1_button_down() -> void:
	$"../lombard/Character/model/AnimationPlayer".play_backwards("down")
	$"..".set_active_track(0)
	pass # Replace with function body.
