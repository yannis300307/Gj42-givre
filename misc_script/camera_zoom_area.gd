extends Area2D

@export var zoom_level: float = 6.0

func _on_body_entered(body: Node2D) -> void:
	if body == %Player:
		Global.need_camera_focus.emit($Marker.global_position, zoom_level)

func _on_body_exited(body: Node2D) -> void:
	if body == %Player:
		Global.release_camera.emit()
