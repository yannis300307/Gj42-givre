extends Node2D

@export var start_life: int = 3

@onready var current_life = start_life

const empty_star = preload("res://assets/textures/ui/star_empty.png")
const full_star = preload("res://assets/textures/ui/star_full.png")
const half_star = preload("res://assets/textures/ui/star_half.png")

func set_life(level: int):
	var remaining = level
	current_life = level

	for star in $Stars.get_children():
		if remaining == 1:
			star.texture = half_star
			remaining -= 1
		elif remaining:
			star.texture = full_star
			remaining -= 2
		else:
			star.texture = empty_star
	if current_life <= 0:
		current_life = 0
		Global.loose.emit()

func add_life(amount: int):
	set_life(current_life + amount)

func reduce_life(amount: int):
	set_life(current_life - amount)

func _ready() -> void:
	Global.set_life.connect(set_life)
	Global.add_life.connect(add_life)
	Global.reduce_life.connect(reduce_life)
	set_life(start_life)
