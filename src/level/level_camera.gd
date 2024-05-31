class_name LevelCamera
extends Camera2D

@export var initial_zoom: Vector2 = Vector2(2, 2)

var mouse_start_pos
var screen_start_position

var dragging = false

const ZOOM_STEP: Vector2 = Vector2(.1, .1)
const ZOOM_MAX: Vector2 = Vector2(3, 3)
const ZOOM_MIN: Vector2 = Vector2(.7, .7)

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
	elif event is InputEventMouseMotion and dragging:
		position = (mouse_start_pos - event.position) / zoom + screen_start_position
	elif not dragging and event.is_action_pressed("zoom_in"):
		zoom_at_mouse(zoom + ZOOM_STEP)
	elif not dragging and event.is_action_pressed("zoom_out"):
		zoom_at_mouse(zoom - ZOOM_STEP)

	
func zoom_at_mouse(value: Vector2) -> void:
	var mouse_pos_1: Vector2 = get_global_mouse_position()
	zoom = clamp(value, ZOOM_MIN * initial_zoom, ZOOM_MAX * initial_zoom)
	var mouse_pos_2: Vector2 = get_global_mouse_position()
	global_position += mouse_pos_1 - mouse_pos_2
