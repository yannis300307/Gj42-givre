extends Area2D

var player_in_area = false

func _on_body_entered(body: Node2D) -> void:
	if body == %Player:
		Global.player_can_interact = Global.PlayerInteractionType.CLEAR_INVENTORY
		player_in_area = true

func _on_body_exited(body: Node2D) -> void:
	if body == %Player:
		Global.player_can_interact = Global.PlayerInteractionType.NONE
		player_in_area = false

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Interact") and player_in_area:
		Global.clear_inventory()
