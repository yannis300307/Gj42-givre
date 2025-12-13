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
	get_node("Texture").reparent($TextureContainer)
	$Animator.play("Druck")
	state = CustomerState.WAITING_AWAY
	if len(movements_pos) > 0:
		position = movements_pos[0]

func go_buy_ice_cream():
	state = CustomerState.COMMING

func _process(delta: float) -> void:
	if len(movements_pos) > 1:
		var direction = (movements_pos[target_point] - position).normalized()
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
	
	if Input.is_action_just_pressed("Interact") && state == CustomerState.WAITING:
		state = CustomerState.LEAVING
		Global.clear_inventory()
