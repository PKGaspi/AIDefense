class_name Level
extends Node2D

@onready var projectile_layer: Node2D = %Projectiles
@onready var building_layer: Node2D = %Buildings
@onready var troop_layer: Node2D = %Troops
@export_node_path("StaticBody2D") var heart_building
