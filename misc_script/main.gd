extends Node

@export var max_item: int = 3

signal customer_leave
signal need_camera_focus(pos: Vector2, zoom_level: float)
signal release_camera

enum ItemType {
	FISH,
	MOSS,
	SUGAR_CUBE,
	GARBAGE,
}

enum PlayerInteractionType {
	PICKUP_ITEM,
	PLACE_ITEM,
	NONE,
}

var stream_player: AudioStreamPlayer2D


func _ready():
	stream_player = AudioStreamPlayer2D.new()
	add_child(stream_player)
	stream_player.set_bus("Sound Design")


func play_sound_to_player(stream: AudioStreamWAV):
	stream_player.global_position = get_node("/root/Main/Player").global_position
	stream_player.set_stream(stream)
	stream_player.play()


func get_item_image(type: ItemType) -> Resource:
	match type:
		ItemType.FISH:
			return load("res://assets/textures/inventory/fish.png")
		ItemType.MOSS:
			return load("res://assets/textures/inventory/moss.png")
		ItemType.SUGAR_CUBE:
			return load("res://assets/textures/inventory/sugar_cube.png")
		ItemType.GARBAGE:
			return load("res://assets/textures/inventory/garbage.png")
	return null

var inventory: Array[ItemType] = []
var player_can_interact: PlayerInteractionType = PlayerInteractionType.NONE

func add_item(item: ItemType) -> bool:
	if can_pickup(item):
		inventory.append(item)
		return true
	return false

func clear_inventory():
	inventory.clear()
	
func can_pickup(item: ItemType) -> bool:
	return (item not in inventory) or inventory.count(item) < max_item

func consume_item(item: ItemType) -> bool:
	if item in inventory:
		while item in inventory:
			inventory.erase(item)
		return true
	return false
