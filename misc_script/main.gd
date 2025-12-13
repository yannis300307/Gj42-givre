extends Node

@export var max_item: int = 3

enum ItemType {
	FISH,
	MUSHROOM,
	ALGAE,
}

enum PlayerInteractionType {
	PICKUP_ITEM,
	PLACE_ITEM,
	NONE,
}

func get_item_image(type: ItemType) -> Resource:
	match type:
		ItemType.FISH:
			return load("res://assets/textures/inventory/fish.png")
		ItemType.ALGAE:
			return load("res://assets/textures/inventory/algae.png")
		ItemType.MUSHROOM:
			return load("res://assets/textures/inventory/mushroom.png")
	return null

var inventory: Array[ItemType] = []
var player_can_interact: PlayerInteractionType = PlayerInteractionType.NONE

func add_item(item: ItemType) -> bool:
	if can_pickup(item):
		inventory.append(item)
		print("Plus 1", item)
		return true
	return false
	
func can_pickup(item: ItemType) -> bool:
	return (item not in inventory) or inventory.count(item) < max_item

func consume_item(item: ItemType) -> bool:
	if item in inventory:
		while item in inventory:
			inventory.erase(item)
		return true
	return false
