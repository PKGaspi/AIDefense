class_name SpawnerWave
extends Resource

@export var troops: Array[PackedScene]
@export var quantity: Array[int]
@export var frequency: float = 1
@export var next_wave: SpawnerWave


var index: int = 0
var count: int = 0

func _init() -> void:
	resource_local_to_scene = true

func next_troop() -> PackedScene:
	if index >= len(troops):
		return null
	if count >= quantity[index]:
		count = 0
		index += 1
		return next_troop()
		
	count += 1
	return troops[index]

func reset() -> void:
	index = 0
	count = 0

func get_wave_count() -> int:
	if not is_instance_valid(next_wave):
		return 1
	return next_wave.get_wave_count() + 1
