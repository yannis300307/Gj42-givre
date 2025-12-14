extends Camera2D

@export var player_direction_offset: int = 10
@export var focus_position_smoothing_speed: float = 6.
@export var focus_zoom_smoothing_speed: float = 2.0

@onready var default_zoom = zoom
@onready var default_smooth = position_smoothing_speed
@onready var zoom_target = zoom

var zoom_progress: float = 0.0
@onready var start_zoom = zoom

var focus = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.need_camera_focus.connect(lock)
	Global.release_camera.connect(release)

func lock(pos: Vector2, zoom_level: float):
	position_smoothing_speed = focus_position_smoothing_speed
	global_position = pos
	focus = true
	zoom_target = zoom_level * Vector2.ONE
	start_zoom = zoom
	zoom_progress = 0.0

func release():
	focus = false
	position_smoothing_speed = default_smooth
	zoom_target = default_zoom
	start_zoom = zoom
	zoom_progress = 0.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not focus:
		global_position = %Player.global_position + %Player.direction * (player_direction_offset * %Player.acceleration)
	zoom_progress += delta * focus_zoom_smoothing_speed
	zoom_progress = min(zoom_progress, 1.0)
	zoom = start_zoom.lerp(zoom_target, ease(ease(zoom_progress, 2), 0.5))
	
