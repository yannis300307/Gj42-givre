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
		if item_type == Global.ItemType.MOSS:
			Global.play_sound_to_player(AudioStreamWAV.load_from_file("res://assets/audio/moss_collecting.wav"))
		if item_type == Global.ItemType.SUGAR_CUBE:
			Global.play_sound_to_player(AudioStreamWAV.load_from_file("res://assets/audio/sugarcube.wav"))
		if item_type == Global.ItemType.FISH:
			Global.play_sound_to_player(AudioStreamWAV.load_from_file("res://assets/audio/jean_charles.wav"))
		if item_type == Global.ItemType.GARBAGE:
			Global.play_sound_to_player(AudioStreamWAV.load_from_file("res://assets/audio/trash_collecting.wav"))
		if item_type == Global.ItemType.STRAWBERRY:
			Global.play_sound_to_player(AudioStreamWAV.load_from_file("res://assets/audio/strawberry.wav"))
		if item_type == Global.ItemType.CORNETO:
			Global.play_sound_to_player(AudioStreamWAV.load_from_file("res://assets/audio/amazon_cardboard.wav"))
		Global.add_item(item_type)
	if not Global.can_pickup(item_type) and player_in_area:
		Global.player_can_interact = Global.PlayerInteractionType.NONE
