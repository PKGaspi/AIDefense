extends CharacterBody2D

const TARGET_GROUP = "EnemyTarget"

@export var stats: EnemyStats
@onready var navigation_agent: NavigationAgent2D = %NavigationAgent2D
@onready var attack: Weapon = %Attack

var target: Node2D
var hp: float

func _ready() -> void:
	hp = stats.max_hp
	new_target()

func _physics_process(delta):
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if is_attacking():
		return # Don't move and attack
	var direction = global_position.direction_to(navigation_agent.get_next_path_position())
	velocity = direction * stats.speed * delta
	move_and_slide()

func new_target() -> void:
	var tree: SceneTree = get_tree()
	if !is_instance_valid(tree):
		return
	var nearest_target: Node2D
	for node: Node2D in tree.get_nodes_in_group(TARGET_GROUP):
		if !is_instance_valid(nearest_target) or global_position.distance_to(node.global_position) < global_position.distance_to(nearest_target.global_position):
			nearest_target = node
	if !is_instance_valid(nearest_target):
		return
	navigation_agent.target_position = nearest_target.global_position
	nearest_target.tree_exited.connect(new_target)

func get_hit(damage_received: float) -> void:
	hp -= damage_received
	if hp <= 0:
		die()

func die() -> void:
	Global.game_manager.level.increment_currency('gold', stats.gold_drop)
	queue_free()

func is_attacking() -> bool:
	return len(attack.targets) > 0
