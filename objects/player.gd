extends RigidBody2D

@export var speed: float = 35
var acceleration: float = 0

var direction = Vector2.ZERO
var velocity: Vector2 = Vector2.ZERO # The player's movement vector.


# Called when the node enters the scene tree for the first time.
func _process(_delta: float) -> void:
	match Global.player_can_interact:
		Global.PlayerInteractionType.PICKUP_ITEM:
			$ControlsLabels/Pickup.visible = true
			$ControlsLabels/Place.visible = false
		Global.PlayerInteractionType.PLACE_ITEM:
			$ControlsLabels/Pickup.visible = false
			$ControlsLabels/Place.visible = true
		Global.PlayerInteractionType.NONE:
			$ControlsLabels/Pickup.visible = false
			$ControlsLabels/Place.visible = false

func _physics_process(delta: float) -> void:
	var acc_state: int = 0
	if Input.is_action_pressed("ui_right"):
		acceleration = min(acceleration + (0.142 * delta), 1)
		direction.x = 1;
		#rotation_degrees = 90
	elif Input.is_action_pressed("ui_left"):
		acceleration = min(acceleration + (0.142 * delta), 1)
		direction.x = -1
		#rotation_degrees = -90
	else:
		acc_state = 1
		direction.x = 0
	if Input.is_action_pressed("ui_down"):
		acceleration = min(acceleration + (0.142 * delta), 1)
		direction.y = 1
		#rotation_degrees = 180
	elif Input.is_action_pressed("ui_up"):
		acceleration = min(acceleration + (0.142 * delta), 1)
		direction.y = -1
		#rotation_degrees = 0
	else:
		if acc_state > 0:
			acceleration -= (0x5f3759df / 10e8) * delta
			acceleration = max(acceleration, 0)
		direction.y = 0
	if direction.x or direction.y:
		$Normal.rotation = direction.angle()
	var tmp: float = ease_out_expo(acceleration) * speed * delta
	velocity.y = tmp * direction.y
	velocity.x = tmp * direction.x
	velocity = velocity.limit_length(tmp)
	position += velocity * speed

func ease_out_expo(x: float) -> float:
	return (1 - pow(2, -10 * x))
