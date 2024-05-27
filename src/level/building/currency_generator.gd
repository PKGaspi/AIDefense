extends Node

var currency: String = "gold"
var rate: float = 2.3


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_instance_valid(Global.game_manager) and is_instance_valid(Global.game_manager.level):
		Global.game_manager.level.increment_currency(currency, rate * delta)
	
