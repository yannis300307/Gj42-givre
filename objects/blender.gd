extends Node2D

var in_area = false
var active = false
var ice_cream_available = false

func _on_area_body_entered(body: Node2D) -> void:
	if body == %Player:
		if not active and not ice_cream_available and len(Global.inventory) > 0:
			Global.player_can_interact = Global.PlayerInteractionType.USE_BLENDER
		if ice_cream_available and Global.ItemType.CORNETO in Global.inventory:
			Global.player_can_interact = Global.PlayerInteractionType.PICKUP_ICE_CREAM
		if ice_cream_available and Global.ItemType.CORNETO not in Global.inventory:
			Global.player_can_interact = Global.PlayerInteractionType.NEED_CORNETO
		in_area = true

func _on_area_body_exited(body: Node2D) -> void:
	if body == %Player:
		Global.player_can_interact = Global.PlayerInteractionType.NONE
		in_area = false

func _process(_delta: float) -> void:
	if in_area and not active and Global.ItemType.ICE_CREAM not in Global.inventory and len(Global.inventory) > 0 and not ice_cream_available and Input.is_action_just_pressed("Interact"):
		active = true
		ice_cream_available = false
		Global.player_can_interact = Global.PlayerInteractionType.NONE
		for i in Global.inventory:
			if i in Global.ice_cream_ingredients:
				Global.ice_cream_ingredients[i] += 1
			else:
				Global.ice_cream_ingredients[i] = 1
		Global.clear_inventory()
		$Animated.visible = true
		$Animated.play("Blend")
		$Sound.play()
		$TurnedOff.visible = false
		await get_tree().create_timer(5).timeout
		$Animated.stop()
		active = false
		ice_cream_available = true
		if Global.ItemType.CORNETO in Global.inventory:
			Global.play_sound_to_player(AudioStreamWAV.load_from_file("res://assets/audio/i_scream.wav"))
			Global.player_can_interact = Global.PlayerInteractionType.PICKUP_ICE_CREAM
		else:
			Global.player_can_interact = Global.PlayerInteractionType.NEED_CORNETO
	if in_area and ice_cream_available and Input.is_action_just_pressed("Interact") and Global.ItemType.CORNETO in Global.inventory:
		Global.inventory.append(Global.ItemType.ICE_CREAM)
		Global.inventory.erase(Global.ItemType.CORNETO)
		$Animated.visible = false
		$TurnedOff.visible = true
		Global.player_can_interact = Global.PlayerInteractionType.NONE
		active = false
		ice_cream_available = false
		
