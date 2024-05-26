extends Marker2D

var frequency: float = .45
var spawn_timer: Timer
@export var to_spawn: PackedScene
var quantity: int = 100
var spawned_count: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_timer = Timer.new()
	spawn_timer.name = "SpawnTimer"
	spawn_timer.wait_time = frequency
	spawn_timer.autostart = true
	spawn_timer.one_shot = true
	spawn_timer.timeout.connect(spawn)
	add_child(spawn_timer)


func spawn() -> void:
	spawn_timer.start()
	var node := to_spawn.instantiate()
	node.transform = transform
	Global.game_manager.level.troop_layer.add_child(node)
	spawned_count += 1
	if spawned_count >= quantity:
		print("spawner end")
		queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
