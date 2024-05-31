extends Area2D

@export var stats: ProjectileStats
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
	global_position += direction * stats.speed * delta
	
func hit(body: Node2D) -> void:
	if body.has_method('get_hit'):
		body.get_hit(stats.damage)

func _on_body_entered(body: Node2D) -> void:
	if body == target:
		hit(body)
		queue_free()
