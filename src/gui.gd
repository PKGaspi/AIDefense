class_name GUI
extends MarginContainer


@onready var hp_bar: ProgressBar = %HPBar
@onready var gold_label: Label = %GoldLabel


func setup(game_manager: GameManager) -> void:
	var hear_building = game_manager.level.get_node(game_manager.level.heart_building)
	hear_building.damage_taken.connect(update_hp_bar)
	setup_hp_bar(hear_building.hp)
	

func setup_hp_bar(max_value: float, value: float = max_value) -> void:
	hp_bar.max_value = max_value
	hp_bar.value = value

func update_hp_bar(value: float) -> void:
	hp_bar.value -= value
