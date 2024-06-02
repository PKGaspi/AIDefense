class_name Level
extends Node2D

@export var gui_scene: PackedScene 
var gui: GUI
#@export var next_level: PackedScene
#@export var game_over_scene: PackedScene


@onready var projectile_layer: Node2D = %Projectiles
@onready var building_layer: Node2D = %Buildings
@onready var troop_layer: Node2D = %Troops
@onready var spawner_layer: Node2D = %Spawners

@export_node_path("AttackableBuilding") var _heart_building
var heart_building: AttackableBuilding
@export_node_path("LevelCamera") var _camera
var camera: LevelCamera

var spawner_count: int = 0
var wave: int = 0
var finished_waves: int = 0
var finished_spawners: int = 0
var wave_count: int = 0

@export var initial_gold: float = 100
@onready var gold: float = initial_gold

signal currency_changed(currency: String, value: Variant)

func _ready() -> void:
	heart_building = get_node(_heart_building)
	camera = get_node(_camera)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed('debug_win'):
		level_end(true)

func start() -> void:
	await add_notification("Level Start!", 3)
	heart_building.destroyed.connect(level_end.bind(false))
	setup_spawners()
	add_wave_notification()

func setup_spawners() -> void:
	for spawner in spawner_layer.get_children():
		spawner_count += 1
		spawner.wave_finished.connect(_on_spawner_wave_finished)
		spawner.finished.connect(_on_spawner_finished)
		wave_count = max(wave_count, spawner.get_wave_count())
		spawner.start() # Start this spawner

func next_wave() -> void:
	if troop_layer.get_child_count() > 0:
		# Wait until there are no troops left
		await get_tree().physics_frame
		next_wave.call_deferred()
		return
	finished_waves = 0
	wave += 1
	if wave >= wave_count:
		return
	for spawner in spawner_layer.get_children():
		spawner.next_wave()
	add_wave_notification()

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
	var button = gui.shop_button_group.get_pressed_button()
	if not is_instance_valid(button):
		return null
	return button.shop_item

func _on_spawner_wave_finished() -> void:
	finished_waves += 1
	if finished_waves >= spawner_count:
		next_wave()

func _on_spawner_finished() -> void:
	spawner_count -= 1
	if spawner_count <= 0:
		level_end(true)

func level_end(victory: bool) -> void:
	var message: String
	var level: PackedScene
	if victory:
		message = "Congratulations!\nYou won!"
#		level = next_level
	else:
		message = "Oh no!\nToo bad!"
#		level = game_over_scene
	await add_notification(message, 6)
	Global.game_manager.set_level(level)

func add_notification(message: String, duration: float = 10) -> void:
	if not is_instance_valid(gui):
		return
	var n: PanelContainer = gui.add_notification(message, duration)
	if is_instance_valid(n):
		await n.tree_exited

func add_wave_notification() -> void:
	var message: String = "Wave %s of %s" % [wave + 1, wave_count]
	if wave+1 == wave_count:
		message = "Last Wave!"
	add_notification(message)
