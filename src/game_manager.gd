class_name GameManager
extends Node

@export var init_level_scene: PackedScene
@export var gui_scene: PackedScene
var level: Level
var gui: GUI
@onready var interface_canvas_layer: CanvasLayer = %InterfaceCanvasLayer

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
	level.gui = gui
	level.start()

func set_gui(value: PackedScene) -> void:
	for node in interface_canvas_layer.get_children():
		node.queue_free()
	gui = value.instantiate()
	interface_canvas_layer.add_child(gui)
	gui.setup(level)
