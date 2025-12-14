extends CharacterBody2D

@export var speed: float = 35
var acceleration: float = 0

var old_direction = Vector2.ZERO
var direction = Vector2i.ZERO
var player_move_sound_stream: AudioStreamPlayer2D = AudioStreamPlayer2D.new()


func _ready() -> void:
	var movement_sound: AudioStreamWAV = AudioStreamWAV.load_from_file("res://assets/audio/players_movments.wav")
	player_move_sound_stream.set_bus("Sound Design")
	player_move_sound_stream.set_stream(movement_sound)
	add_child(player_move_sound_stream)

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
		acceleration = min(acceleration + (0.4 * delta), 1)
		direction.x = 1;
		$Texture.rotation_degrees = 0
	elif Input.is_action_pressed("ui_left"):
		acceleration = min(acceleration + (0.4 * delta), 1)
		direction.x = -1
	else:
		acc_state = 1
		direction.x = 0
	if Input.is_action_pressed("ui_down"):
		acceleration = min(acceleration + (0.4 * delta), 1)
		direction.y = 1
	elif Input.is_action_pressed("ui_up"):
		acceleration = min(acceleration + (0.4 * delta), 1)
		direction.y = -1
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
		if !player_move_sound_stream.is_playing():
			player_move_sound_stream.play()
		$Texture.play("roll")
	else:
		var frame = $Texture.frame
		player_move_sound_stream.stop()
		$Texture.stop()
		$Texture.frame = frame
	
func ease_out_expo(x: float) -> float:
	return (1 - pow(2, -10 * x))
