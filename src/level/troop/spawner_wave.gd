class_name SpawnerWave
extends Resource

@export var troops: Array[PackedScene]
@export var quantity: Array[int]
@export var next_wave: SpawnerWave

var index: int = 0
var count: int = 0

func next_troop() -> PackedScene:
	if index >= len(troops):
		return null
	if count > quantity[index]:
		count = 0
		index += 1
		return next_troop()
		
	count += 1
	return troops[index]

func reset() -> void:
	index = 0
	count = 0
