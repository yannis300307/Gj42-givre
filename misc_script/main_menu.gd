extends Control

@export var garbage_speed: float = 220.
var waiting = false

const garbages = [
	preload("res://assets/textures/inventory/strawberry_item.png"),
	preload("res://assets/textures/inventory/moss.png"),
	preload("res://assets/textures/inventory/amazon.png"),
	preload("res://assets/textures/inventory/miam.png"),
	preload("res://assets/textures/inventory/garbage.png"),
	preload("res://assets/textures/inventory/sugar_cube.png"),
	preload("res://assets/textures/inventory/fish.png"),
]

func _process(delta: float) -> void:
	if $Garbage.global_position.x > -60:
		$Garbage.global_position.x -= garbage_speed * delta
		$Garbage.rotation_degrees += 10 * delta
	elif not waiting:
		$GarbageTimer.wait_time = randf_range(5., 20.)
		$GarbageTimer.start()
		waiting = true
		await $GarbageTimer.timeout
		$Garbage.texture = garbages.pick_random()
		$Garbage.global_position.x = 1970
		$Garbage.global_position.y = randi_range(40, 1040)
		waiting = false


func _on_play_pressed() -> void:
	$Transitions.play("fade_out")
	$Fade.visible = true
	await $Transitions.animation_finished
	await get_tree().create_timer(1.).timeout
	get_tree().change_scene_to_packed(preload("res://scenes/main.tscn"))
