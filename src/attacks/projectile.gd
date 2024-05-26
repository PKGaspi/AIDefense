extends Area2D

const SPEED: float = 250.0
const DAMAGE: float = 100.0
var target: Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if !is_instance_valid(target):
		printerr("Projectile with no target set, destroying.")
		queue_free()
		return
	target.tree_exited.connect(queue_free)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var direction = global_position.direction_to(target.global_position).normalized()
	global_rotation = direction.angle()
	global_position += direction * SPEED * delta
	
func hit(body: Node2D) -> void:
	if body.has_method('hit'):
		body.hit(DAMAGE)

func _on_body_entered(body: Node2D) -> void:
	if body == target:
		hit(body)
		queue_free()
