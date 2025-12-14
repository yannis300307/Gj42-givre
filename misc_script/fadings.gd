extends AnimationPlayer

func _ready() -> void:
	play("RESET")
	Global.loose.connect(loose_fade)

func loose_fade():
	play("Fade")
	print("aaaaaaaaaaaaaaaaaaaaaaaaa")
