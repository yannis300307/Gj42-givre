extends AnimationPlayer

func _ready() -> void:
	play("RESET")
	Global.loose.connect(loose_fade)

func loose_fade():
	play("Fade")
	get_tree().change_scene_to_file("res://scenes/game_over.tscn")
