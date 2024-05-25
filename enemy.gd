extends CharacterBody2D

const TARGET_GROUP = "EnemyTarget"
const SPEED = 300.0
@onready var navigation_agent: NavigationAgent2D = %NavigationAgent2D
var target: Node2D


func _ready() -> void:
	new_target()

func _physics_process(delta):
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = (navigation_agent.get_next_path_position() - global_position).normalized()
	velocity = direction * SPEED
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
