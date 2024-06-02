class_name LevelCamera
extends Camera2D

@export var initial_zoom: Vector2 = Vector2(2, 2)

var mouse_start_pos
var screen_start_position

var dragging: bool = false
var dragged: bool = false

var ZOOM_STEP: Vector2 = Vector2(.4, .4)
var ZOOM_MAX: Vector2 = Vector2(5, 5)
@onready var ZOOM_MIN: Vector2 = initial_zoom

func _ready() -> void:
	zoom = initial_zoom
	global_position = (get_tree().root.size / 2) / Vector2i(zoom)

func _input(event) -> void:
	# Source: https://forum.godotengine.org/t/how-to-drag-camera-with-mouse/28508/2
	if event.is_action("drag"):
		if event.is_pressed():
			mouse_start_pos = event.position
			screen_start_position = position
			dragging = true
		else:
			dragging = false
			if dragged:
				get_tree().root.set_input_as_handled()
				dragged = false
	elif event is InputEventMouseMotion and dragging:
		position = (mouse_start_pos - event.position) / zoom + screen_start_position
		dragged = true
	elif not dragging and event.is_action_pressed("zoom_in"):
		zoom_at_mouse(zoom + ZOOM_STEP)
	elif not dragging and event.is_action_pressed("zoom_out"):
		zoom_at_mouse(zoom - ZOOM_STEP)

	
func zoom_at_mouse(value: Vector2) -> void:
	var mouse_pos_1: Vector2 = get_global_mouse_position()
	zoom = clamp(value, ZOOM_MIN, ZOOM_MAX)
	var mouse_pos_2: Vector2 = get_global_mouse_position()
	global_position += mouse_pos_1 - mouse_pos_2
