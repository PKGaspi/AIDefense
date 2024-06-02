class_name AttackableBuilding
extends StaticBody2D

var hp: float = 10000.0

signal damage_taken(damage: float)
signal destroyed

func get_hit(damage: float) -> void:
	hp -= damage
	damage_taken.emit(damage)
	if hp <= 0:
		die()

func die() -> void:
	queue_free()
