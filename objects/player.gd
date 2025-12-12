extends Area2D

@export var speed: int = 5;

var direction = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	var velocity = Vector2.ZERO # The player's movement vector.
	direction = Vector2.ZERO
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
		direction.x = 1;
		rotation_degrees = 90
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
		direction.x = -1
		rotation_degrees = -90
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
		direction.y = 1
		rotation_degrees = 180
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
		direction.y = -1
		rotation_degrees = 0

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed * delta
	position += velocity * speed
