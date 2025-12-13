extends Area2D

@export var walking_speed: float = 0.5
@export var movements_pos: Array[Vector2] = []

var target_point = 0
var waiting_order = false

func _ready() -> void:
	$Animator.play("Druck")
	if len(movements_pos) > 0:
		position = movements_pos[0]

func _process(delta: float) -> void:
	print(target_point, len(movements_pos))
	if len(movements_pos) > 1:
		var direction = (movements_pos[target_point] - position).normalized()
		position += direction * walking_speed * delta
		if position.distance_to(movements_pos[target_point]) < 2:
			if target_point < len(movements_pos) - 1:
				target_point += 1
			elif not waiting_order:
				waiting_order = true
				$Animator.play("instant_stop")
