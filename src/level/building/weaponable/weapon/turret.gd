class_name Weapon
extends Area2D

@onready var shoot_range: CollisionShape2D = %Range
var draw_range: bool = false

@export var n_targets: int = 3
@export var reload_time: float = .3

var reload_timer: Timer
var targets: Array[Node2D]
var targets_in_range: Array[Node2D]

@export var projectile: PackedScene
@export var projectile_stats: ProjectileStats

@export var snd_place: AudioStream
var snd_player_place: AudioStreamPlayer2D
@export var snd_shoot: AudioStream
var snd_player_shoot: AudioStreamPlayer2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	reload_timer = Timer.new()
	reload_timer.wait_time = reload_time
	reload_timer.one_shot = true
	reload_timer.autostart = false
	reload_timer.name = "ReloadTimer"
	add_child(reload_timer)
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	
	snd_player_place = setup_sound(snd_place)
	snd_player_place.play()
	snd_player_shoot = setup_sound(snd_shoot, 'Shooting')

func setup_sound(snd: AudioStream, bus: String = 'Master') -> AudioStreamPlayer2D:
	var node:= AudioStreamPlayer2D.new()
	node.stream = snd
	node.bus = bus
	add_child(node)
	return node
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if can_shoot():
		shoot()

func can_shoot() -> bool:
	return reload_timer.time_left <= 0

func shoot() -> void:
	reload_timer.start()
	var shooted: bool = false
	for target in targets:
		var p: Area2D = projectile.instantiate()
		p.stats = projectile_stats
		p.target = target
		p.global_position = global_position
		p.collision_mask = collision_mask
		Global.game_manager.level.projectile_layer.add_child(p)
		shooted = true
	if shooted:
		snd_player_shoot.play()

func remove_target(target: Node2D) -> void:
	if target in targets_in_range:
		targets_in_range.erase(target)
	elif target in targets:
		targets.erase(target)
		next_target()

func new_target(target: Node2D) -> void:
	targets_in_range.append(target)
	if len(targets) < n_targets:
		next_target()

func next_target() -> void:
	var target: Node2D = targets_in_range.pop_front()
	if !is_instance_valid(target):
		return
	target.tree_exited.connect(_on_target_tree_exited.bind(target))
	targets.append(target)

func _on_target_tree_exited(target: Node2D) -> void:
	remove_target(target)
	
func _on_target_exited(target: Node2D) -> void:
	remove_target(target)

func _on_body_entered(body: Node2D) -> void:
	new_target(body)
	
func _on_body_exited(body: Node2D) -> void:
	remove_target(body)

func show_range(value: bool):
	draw_range = value
	queue_redraw()

func _draw() -> void:
	if draw_range:
		#range.shape.draw(get_rid(), range.debug_color)
		draw_circle(Vector2.ZERO, shoot_range.shape.radius, shoot_range.debug_color)
