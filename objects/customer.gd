class_name Customer
extends Area2D

@export var walking_speed: float = 0.5
@export var movements_pos: Array[Vector2] = []
@export var bar_point_index = 1

var target_point = 0
var state = false

enum CustomerState {
	COMMING,
	WAITING,
	STOPPING,
	LEAVING,
	WAITING_AWAY,
}

func _ready() -> void:
	for child in get_children():
		if child.name.begins_with("Under"):
			child.reparent($Effects)
	get_node("Texture").reparent($TextureContainer)

	$Animator.play("Druck")
	state = CustomerState.WAITING_AWAY
	if len(movements_pos) > 0:
		position = movements_pos[0]

func go_buy_ice_cream():
	$Recipy.visible = false
	state = CustomerState.COMMING
	generate_recipy()

func _process(delta: float) -> void:
	if len(movements_pos) > 1:
		var direction = (movements_pos[target_point] - position).normalized()
		if state == CustomerState.COMMING or state == CustomerState.LEAVING:
			position += direction * walking_speed * delta
		if state == CustomerState.COMMING or state  == CustomerState.LEAVING:
			$Animator.play("Druck")
		if position.distance_to(movements_pos[target_point]) < 2:
			if state == CustomerState.COMMING && target_point == bar_point_index:
				state = CustomerState.STOPPING
			if state == CustomerState.COMMING or state == CustomerState.LEAVING:
				target_point += 1
				if target_point >= len(movements_pos):
					position = movements_pos[0]
					target_point = 0
					state = CustomerState.WAITING_AWAY
					Global.customer_leave.emit()
			elif state == CustomerState.STOPPING:
				$Animator.play("instant_stop")
				await $Animator.is_playing()
				state = CustomerState.WAITING
				$Recipy.visible = true

	if Input.is_action_just_pressed("Interact") and state == CustomerState.WAITING and Global.player_at_bar and Global.ItemType.ICE_CREAM in Global.inventory:
		state = CustomerState.LEAVING
		$Recipy.visible = false
		Global.customers_served += 1
		print(is_corect_recipy())
	
		Global.clear_inventory()

func is_corect_recipy():
	print(Global.ice_cream_ingredients)
	print(Global.asked_ingredients)
	if len(Global.ice_cream_ingredients) != len(Global.asked_ingredients):
		return false
	for t in Global.ice_cream_ingredients:
		if t not in Global.asked_ingredients or Global.ice_cream_ingredients[t] != Global.asked_ingredients[t]:
			return false
	return true

func generate_recipy():
	var max_recipy_types: int
	if Global.customers_served < 3:
		max_recipy_types = 1
	elif Global.customers_served < 5:
		max_recipy_types = 2
	elif Global.customers_served < 8:
		max_recipy_types = 3
	elif Global.customers_served < 20:
		max_recipy_types = 4
	else:
		max_recipy_types = 5
	
	var available = [Global.ItemType.FISH, Global.ItemType.MOSS, Global.ItemType.SUGAR_CUBE, Global.ItemType.GARBAGE, Global.ItemType.STRAWBERRY]
	var types = []
	for i in range(randi_range(1, max_recipy_types)):
		types.append(available.pop_at(randi_range(0, len(available) - 1)))
	var recipy = {}
	var index = 0
	for t in types:
		var count = randi_range(1, 3)
		recipy[t] = count
		var line: Node2D = $Recipy/LineSample.duplicate()
		line.visible = true
		line.get_node("Count").text = "x" + str(count)
		line.get_node("Item").texture = Global.get_item_image(t)
		line.position.y += index * 10
		$Recipy.add_child(line)
		index += 1
	
	Global.asked_ingredients = recipy
	
