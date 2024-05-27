extends Node

var game_manager: GameManager

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game_manager = get_tree().root.get_node('GameManager') as GameManager


