class_name GameManager
extends Node


@export var init_level_scene: PackedScene
@export var gui_scene: PackedScene
var level: Level
var gui: GUI

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if is_instance_valid(init_level_scene):
		set_level(init_level_scene)

func set_level(value: PackedScene) -> void:
	if is_instance_valid(level):
		level.queue_free()
	level = value.instantiate() as Level
	add_child(level)
	if is_instance_valid(gui_scene):
		set_gui(gui_scene)

func set_gui(value: PackedScene) -> void:
	var canvas_gui_layer: CanvasLayer = CanvasLayer.new()
	canvas_gui_layer.name = "CanvasGUILayer"
	add_child(canvas_gui_layer)
	gui = value.instantiate()
	canvas_gui_layer.add_child(gui)
	gui.setup(self)
