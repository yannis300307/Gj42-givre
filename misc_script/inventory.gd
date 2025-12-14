extends Node2D

@export var move_threshold: int = 450

func _ready() -> void:
	visible = true

func _process(delta: float) -> void:
	for i in len(Global.inventory):
		if i >= $Elements/Items.get_child_count():
			break
		var item: Sprite2D = $Elements/Items.get_child(i)
		item.texture = Global.get_item_image(Global.inventory[i])
		$Elements/Items.get_child(i).visible = true
	
	var player_screen_pos = %Player.get_global_transform_with_canvas()
	#if player_screen_pos.xx < move_threshold:
		#pass
	print(player_screen_pos)

	
	if len(Global.inventory) < $Elements/Items.get_child_count():
		for i in range(len(Global.inventory), $Elements/Items.get_child_count()):
			$Elements/Items.get_child(i).visible = false
