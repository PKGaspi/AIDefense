class_name GUI
extends MarginContainer


@onready var hp_bar: ProgressBar = %HPBar
@onready var gold_label: Label = %GoldLabel
@export var shop_button_group: ButtonGroup

func setup(level: Level) -> void:
	var hear_building = level.heart_building
	hear_building.damage_taken.connect(update_hp_bar)
	setup_hp_bar(hear_building.hp)
	level.currency_changed.connect(_on_level_currency_change)
	

func setup_hp_bar(max_value: float, value: float = max_value) -> void:
	hp_bar.max_value = max_value
	hp_bar.value = value

func update_hp_bar(value: float) -> void:
	hp_bar.value -= value

func _on_level_currency_change(currency: String, value: Variant) -> void:
	if currency == 'gold':
		gold_label.text = 'Gold: %d' % value
