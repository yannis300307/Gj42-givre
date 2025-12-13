extends Area2D

@export var item_type: Global.ItemType

var player_in_area = false

func _on_body_entered(body: Node2D) -> void:
	if body != %Player:
		return
	player_in_area = true

func _on_body_exited(body: Node2D) -> void:
	if body != %Player:
		return
	player_in_area = false

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept") and player_in_area:
		Global.add_item(Global.ItemType.FISH)
