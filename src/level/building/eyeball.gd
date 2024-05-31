extends Sprite2D


var movement_range: Vector2 = Vector2(8, 3)
var distance_range: Vector2 = Vector2(20, 120)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var global_mouse_position: Vector2 = get_global_mouse_position()
	var distance: float = global_position.distance_to(global_mouse_position)
	print(lerp(Vector2.ZERO, movement_range, min(1, (distance-distance_range.x)/distance_range.y)))
	position = global_position.direction_to(global_mouse_position) * lerp(Vector2.ZERO, movement_range, clamp((distance-distance_range.x)/distance_range.y, 0, 1))