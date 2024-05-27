extends Camera2D

var mouse_start_pos
var screen_start_position

var dragging = false

const ZOOM_STEP: Vector2 = Vector2(.1, .1)
const ZOOM_MAX: Vector2 = Vector2(3, 3)
const ZOOM_MIN: Vector2 = Vector2(.4, .4)

func _input(event):
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
	elif not dragging and event.is_action("zoom_in"):
		_set_zoom(zoom + ZOOM_STEP)
	elif not dragging and event.is_action("zoom_out"):
		_set_zoom(zoom - ZOOM_STEP)

func _set_zoom(value: Vector2) -> void:
	zoom = clamp(value, ZOOM_MIN, ZOOM_MAX)
