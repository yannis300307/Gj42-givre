extends Node2D

func _process(delta: float) -> void:
	for i in len(Global.inventory):
		if i >= $Items.get_child_count():
			break
		var item: Sprite2D = $Items.get_child(i)
		item.texture = Global.get_item_image(Global.inventory[i])
		$Items.get_child(i).visible = true

	
	if len(Global.inventory) < $Items.get_child_count():
		for i in range(len(Global.inventory), $Items.get_child_count()):
			$Items.get_child(i).visible = false
