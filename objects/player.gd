extends CharacterBody2D

@export var speed: float = 35
var acceleration: float = 0

var old_direction = Vector2.ZERO
var direction = Vector2i.ZERO

# Called when the node enters the scene tree for the first time.
func _process(_delta: float) -> void:
	match Global.player_can_interact:
		Global.PlayerInteractionType.PICKUP_ITEM:
			$ControlsLabels/Pickup.visible = true
			$ControlsLabels/Place.visible = false
			$ControlsLabels/Blend.visible = false
			$ControlsLabels/PickupIceCream.visible = false
		Global.PlayerInteractionType.PLACE_ITEM:
			$ControlsLabels/Pickup.visible = false
			$ControlsLabels/Place.visible = true
			$ControlsLabels/Blend.visible = false
			$ControlsLabels/PickupIceCream.visible = false
		Global.PlayerInteractionType.NONE:
			$ControlsLabels/Pickup.visible = false
			$ControlsLabels/Place.visible = false
			$ControlsLabels/Blend.visible = false
			$ControlsLabels/PickupIceCream.visible = false
		Global.PlayerInteractionType.USE_BLENDER:
			$ControlsLabels/Pickup.visible = false
			$ControlsLabels/Place.visible = false
			$ControlsLabels/Blend.visible = true
			$ControlsLabels/PickupIceCream.visible = false
		Global.PlayerInteractionType.PICKUP_ICE_CREAM:
			$ControlsLabels/Pickup.visible = false
			$ControlsLabels/Place.visible = false
			$ControlsLabels/Blend.visible = false
			$ControlsLabels/PickupIceCream.visible = true

func _physics_process(delta: float) -> void:
	var acc_state: int = 0
	if Input.is_action_pressed("ui_right"):
		acceleration = min(acceleration + (0.4 * delta), 1)
		direction.x = 1;
		$Texture.rotation_degrees = 0
		#rotation_degrees = 90
	elif Input.is_action_pressed("ui_left"):
		acceleration = min(acceleration + (0.4 * delta), 1)
		direction.x = -1
		#rotation_degrees = -90
	else:
		acc_state = 1
		direction.x = 0
	if Input.is_action_pressed("ui_down"):
		acceleration = min(acceleration + (0.4 * delta), 1)
		direction.y = 1
		#rotation_degrees = 180
	elif Input.is_action_pressed("ui_up"):
		acceleration = min(acceleration + (0.4 * delta), 1)
		direction.y = -1
		#rotation_degrees = 0
	else:
		if acc_state > 0:
			acceleration -= (0x5f3759df / 10e8) * delta
			acceleration = max(acceleration, 0)
		direction.y = 0
	if direction.x or direction.y:
		if direction.x > 0 && direction.y == 0:
			$Texture.rotation_degrees = 0
			$Texture.scale.x = 1
			$Texture.scale.y = 1
		if direction.x < 0 && direction.y == 0:
			$Texture.rotation_degrees = 0
			$Texture.scale.x = - 1
			$Texture.scale.y = 1
		if direction.x == 0 && direction.y > 0:
			$Texture.rotation_degrees = 90
			$Texture.scale.y = 1
			$Texture.scale.x = 1
		if direction.x == 0 && direction.y < 0:
			$Texture.rotation_degrees = -90
			$Texture.scale.y = - 1
			$Texture.scale.x = 1
		if direction.x > 0 && direction.y > 0:
			$Texture.rotation_degrees = 45
			$Texture.scale.x = 1
			$Texture.scale.y = 1
		if direction.x < 0 && direction.y > 0:
			$Texture.rotation_degrees = -45
			$Texture.scale.x = - 1
			$Texture.scale.y = 1
		if direction.x > 0 && direction.y < 0:
			$Texture.rotation_degrees = -45
			$Texture.scale.x = 1
			$Texture.scale.y = 1
		if direction.x < 0 && direction.y < 0:
			$Texture.rotation_degrees = 45
			$Texture.scale.x = - 1
			$Texture.scale.y = 1
			
	var tmp: float = ease_out_expo(acceleration) * speed * delta
	var motion: Vector2 = tmp * (direction as Vector2).limit_length(tmp)
	move_and_collide(motion * speed)
	if direction.length() > 0.2:
		$Texture.play("roll")
	else:
		var frame = $Texture.frame
		$Texture.stop()
		$Texture.frame = frame
	
func ease_out_expo(x: float) -> float:
	return (1 - pow(2, -10 * x))
