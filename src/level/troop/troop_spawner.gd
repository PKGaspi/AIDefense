extends Marker2D

var frequency: float = .8
var spawn_timer: Timer
@export var wave: SpawnerWave

signal wave_finished()
signal finished()


func _ready() -> void:
	spawn_timer = Timer.new()
	spawn_timer.name = "SpawnTimer"
	spawn_timer.wait_time = frequency
	spawn_timer.autostart = false
	spawn_timer.one_shot = true
	spawn_timer.timeout.connect(spawn)
	add_child(spawn_timer)


func spawn() -> void:
	var troop_scene: PackedScene = wave.next_troop()
	if not is_instance_valid(troop_scene):
		wave_finished.emit()
		return # This wave is done for this spawner
	var node := troop_scene.instantiate()
	node.transform = transform
	Global.game_manager.level.troop_layer.add_child(node)
	spawn_timer.start() # Spawn in next timeout again.

func next_wave() -> void:
	wave = wave.next_wave
	if not is_instance_valid(wave):
		finished.emit()
		return # Null wave, this spawner is done for.
	wave.reset()
	spawn_timer.start() # Spawn in next timeout again.
