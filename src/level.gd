class_name Level
extends Node2D

@onready var projectile_layer: Node2D = %Projectiles
@onready var building_layer: Node2D = %Buildings
@onready var troop_layer: Node2D = %Troops
@export_node_path("StaticBody2D") var heart_building
var gold: float = 100
signal currency_changed(currency: String, value: Variant)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action("build"):
		build()

func get_currency(currency: String) -> void:
	get(currency)

func set_currency(currency: String, value: Variant) -> void:
	set(currency, value)
	currency_changed.emit(currency, value)

func increment_currency(currency: String, increment: Variant) -> void:
	set_currency(currency, get(currency) + increment)

func build() -> void:
	var scene: PackedScene = get_selected_building_button()
	if not is_instance_valid(scene):
		return
	var global_pos = get_global_mouse_position()
	var node: Node2D = scene.instantiate()
	node.global_position = global_pos
	add_child(node)

func get_selected_building_button() -> PackedScene:
	var button: BaseButton = Global.game_manager.gui.building_button_group.get_pressed_button()
	if not is_instance_of(button, BuildingButton):
		return null
	return button.scene
