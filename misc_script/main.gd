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

var inventory = {}
var player_can_interact: PlayerInteractionType = PlayerInteractionType.NONE

func add_item(item: ItemType) -> bool:
	if can_pickup(item):
		if item in inventory:
			inventory[item] += 1
		else:
			inventory[item] = 1
		print("Plus 1", item)
		return true
	return false
	
func can_pickup(item: ItemType) -> bool:
	return (item not in inventory) or inventory[item] < max_item

func consume_item(item: ItemType) -> bool:
	if item in inventory:
		inventory.erase(item)
		return true
	return false
