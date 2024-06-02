extends Area2D

@export var size: Vector2 = Vector2(1, 3)

var unselected_modulate: Color = Color(1, 1, 1, .7) # White transparent
var selected_modulate: Color = Color(1, 1, 1, 1) # White
var selected: bool = false
var weapon: Weapon

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	modulate = unselected_modulate

func _unhandled_input(event: InputEvent) -> void:
	if selected and event.is_action_released("build"):
		var built = build()
		if built:
			get_tree().root.set_input_as_handled()

func set_selected(value: bool) -> void:
	selected = value
	if is_instance_valid(weapon):
		weapon.show_range(selected)
	else:
		modulate = selected_modulate if selected else unselected_modulate

func _on_mouse_entered() -> void:
	set_selected(true)


func _on_mouse_exited() -> void:
	set_selected(false)

func build() -> bool:
	if weapon != null:
		return false
	var level: Level = Global.game_manager.level
	var shop_item: ShopItem = level.get_selected_shop_item()
	if not is_instance_valid(shop_item) or level.gold < shop_item.cost:
		return false
	
	level.increment_currency('gold', -shop_item.cost)
	var tileset_cell_size: Vector2 = Vector2(16, 16) # TODO: Get from tileset!
	var weapon_size: Vector2 = tileset_cell_size * 1 # TODO: Get from somewhere else!
	weapon = shop_item.item.instantiate()
	weapon.transform = transform
	weapon.global_position -= size * tileset_cell_size
	weapon.global_position += weapon_size
	level.building_layer.add_child(weapon)
	#modulate = selected_modulate
	set_selected(true)
	return true
