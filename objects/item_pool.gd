extends Area2D

@export var item_type: Global.ItemType

var player_in_area = false


func _on_body_entered(body: Node2D) -> void:
	if body != %Player:
		return
	player_in_area = true
	Global.player_can_interact = Global.PlayerInteractionType.PICKUP_ITEM

func _on_body_exited(body: Node2D) -> void:
	if body != %Player:
		return
	player_in_area = false
	Global.player_can_interact = Global.PlayerInteractionType.NONE

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Interact") and player_in_area:
		if get_node_or_null("Pickup") != null:
			get_node("Pickup").play()
		Global.add_item(item_type)
	if not Global.can_pickup(item_type) and player_in_area:
		Global.player_can_interact = Global.PlayerInteractionType.NONE
