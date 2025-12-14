extends Node2D

@export var move_threshold: int = 450

var moved_to_right = false

func _ready() -> void:
	visible = true
	$Transition.play("RESET")

func _process(delta: float) -> void:
	for i in len(Global.inventory):
		if i >= $Elements/Items.get_child_count():
			break
		var item: Sprite2D = $Elements/Items.get_child(i)
		item.texture = Global.get_item_image(Global.inventory[i])
		$Elements/Items.get_child(i).visible = true
	
	var player_screen_pos = %Player.get_global_transform_with_canvas()
	if player_screen_pos.get_origin().x < move_threshold and not moved_to_right and not $Transition.is_playing():
		$Transition.play("move_right")
		moved_to_right = true
		await $Transition.animation_finished
	if player_screen_pos.get_origin().x > move_threshold and moved_to_right and not $Transition.is_playing():
		$Transition.play_backwards("move_right")
		moved_to_right = false
		await $Transition.animation_finished
		$Transition.play("RESET")
	
	if len(Global.inventory) < $Elements/Items.get_child_count():
		for i in range(len(Global.inventory), $Elements/Items.get_child_count()):
			$Elements/Items.get_child(i).visible = false
