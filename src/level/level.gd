class_name Level
extends Node2D

@onready var projectile_layer: Node2D = %Projectiles
@onready var building_layer: Node2D = %Buildings
@onready var troop_layer: Node2D = %Troops
@onready var spawner_layer: Node2D = %Spawners
@export_node_path("StaticBody2D") var _heart_building
var heart_building: StaticBody2D
@export_node_path("LevelCamera") var _camera
var camera: LevelCamera
var spawner_count: int = 0
var finished_waves: int = 0

var gold: float = 100
signal currency_changed(currency: String, value: Variant)

func _ready() -> void:
	setup()

func setup() -> void:
	heart_building = get_node(_heart_building)
	camera = get_node(_camera)
	heart_building.tree_exited.connect(level_end.bind(false))
	setup_spawners()

func setup_spawners() -> void:
	for spawner in spawner_layer.get_children():
		spawner_count += 1
		spawner.wave_finished.connect(_on_spawner_wave_finished)
		spawner.finished.connect(_on_spawner_finished)
		spawner.spawn() # Start this spawner

func next_wave() -> void:
	if troop_layer.get_child_count() > 0:
		# Wait until there are no troops left
		await get_tree().physics_frame
		next_wave.call_deferred()
		return
	finished_waves = 0
	for spawner in spawner_layer.get_children():
		spawner.next_wave()


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

func _on_spawner_wave_finished() -> void:
	finished_waves += 1
	if finished_waves >= spawner_count:
		next_wave()

func _on_spawner_finished() -> void:
	spawner_count -= 1
	if spawner_count == 0:
		level_end(true)

func level_end(victory: bool) -> void:
	if victory:
		print("Congratulations! You won!")
	else:
		print("Oh no, too bad!")
