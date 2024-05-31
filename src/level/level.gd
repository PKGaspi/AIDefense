class_name Level
extends Node2D

@onready var projectile_layer: Node2D = %Projectiles
@onready var building_layer: Node2D = %Buildings
@onready var troop_layer: Node2D = %Troops
@export_node_path("StaticBody2D") var _heart_building
var heart_building: StaticBody2D
@export_node_path("LevelCamera") var _camera
var camera: LevelCamera

var gold: float = 100
signal currency_changed(currency: String, value: Variant)

func _ready() -> void:
	heart_building = get_node(_heart_building)
	camera = get_node(_camera)


func get_currency(currency: String) -> void:
	get(currency)

func set_currency(currency: String, value: Variant) -> void:
	set(currency, value)
	currency_changed.emit(currency, value)

func increment_currency(currency: String, increment: Variant) -> void:
	set_currency(currency, get(currency) + increment)

func build() -> void:
	var shop_item: ShopItem = get_selected_shop_item()
	if not is_instance_valid(shop_item) or shop_item.cost > gold:
		return
	var global_pos = get_global_mouse_position()
	var node: Node2D = shop_item.item.instantiate()
	node.global_position = global_pos
	building_layer.add_child(node)
	gold -= shop_item.cost

func get_selected_shop_item() -> ShopItem:
	var button = Global.game_manager.gui.shop_button_group.get_pressed_button()
	if not is_instance_valid(button):
		return null
	return button.shop_item
