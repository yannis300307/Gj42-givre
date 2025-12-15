extends AnimationPlayer

func _ready() -> void:
	play("RESET")
	Global.loose.connect(loose_fade)

func loose_fade():
	play("Fade")
	print("aaaaaaaaaaaaaaaaaaaaaaaaa")
	get_tree().change_scene_to_file()
