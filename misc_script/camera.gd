extends Camera2D

@export var player_direction_offset: int = 10

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position = %Player.global_position + %Player.direction * player_direction_offset
