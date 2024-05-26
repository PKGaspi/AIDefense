extends Area2D

var n_targets: int = 1
var targets: Array[Node2D]
var reload_time: float = .3
var reload_timer: Timer

@export var projectile: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	new_targets()
	reload_timer = Timer.new()
	reload_timer.wait_time = reload_time
	reload_timer.one_shot = true
	reload_timer.autostart = false
	reload_timer.name = "ReloadTimer"
	add_child(reload_timer)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if len(targets) < n_targets:
		new_targets()
	if can_shoot():
		shoot()

func new_targets() -> void:
	var possible_targets: Array[Node2D] = get_overlapping_bodies()
	possible_targets.sort_custom(func(a, b): return global_position.distance_squared_to(a.global_position) < global_position.distance_squared_to(b.global_position))
	targets = possible_targets.slice(0, n_targets)
	for target in targets:
		target.tree_exited.connect(_on_target_tree_exited.bind(target))

func can_shoot() -> bool:
	return reload_timer.time_left <= 0

func shoot() -> void:
	reload_timer.start()
	for target in targets:
		print("shoot!")
		var p = projectile.instantiate()
		p.target = target
		p.global_position = global_position
		Global.game_manager.level.projectile_layer.add_child(p)

func _on_target_tree_exited(target: Node2D) -> void:
	targets.erase(target)
	new_targets()
