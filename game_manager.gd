class_name GameManager
extends Node


@export var init_level: PackedScene
var level: Level

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if is_instance_valid(init_level):
		set_level(init_level)

func set_level(value: PackedScene) -> void:
	if is_instance_valid(level):
		level.queue_free()
	level = init_level.instantiate() as Level
	add_child(level)
