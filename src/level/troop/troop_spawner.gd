extends Marker2D

var frequency: float = .8
var spawn_timer: Timer
@export var waves: Array[SpawnerWave]
var wave_index: int = -1

signal wave_finished()
signal finished()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_timer = Timer.new()
	spawn_timer.name = "SpawnTimer"
	spawn_timer.wait_time = frequency
	spawn_timer.autostart = false
	spawn_timer.one_shot = true
	spawn_timer.timeout.connect(spawn)
	add_child(spawn_timer)


func spawn() -> void:
	var troop_scene: PackedScene = waves[wave_index].next_troop()
	if not is_instance_valid(troop_scene):
		wave_finished.emit()
		return # This wave is done for this spawner
	var node := troop_scene.instantiate()
	node.transform = transform
	Global.game_manager.level.troop_layer.add_child(node)
	spawn_timer.start() # Spawn in next timeout again.

func next_wave() -> void:
	wave_index += 1
	if wave_index >= len(waves):
		# This spawner is done for
		finished.emit()
		return
	var wave: SpawnerWave = waves[wave_index]
	if not is_instance_valid(wave):
		wave_finished.emit()
		return # Empty wave, skip.
	wave.reset()
	spawn_timer.start() # Spawn in next timeout again.
