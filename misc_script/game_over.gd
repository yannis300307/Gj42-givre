extends Node2D


func _ready() -> void:
	$Fading.play("RESET")
	Global.loose.connect(loose_fade)

func loose_fade():
	visible = true
	$Fading.play("Fade")
	await $Fading.animation_finished
	get_tree().change_scene_to_file("res://scenes/end_cinematic.tscn")
