class_name ShopItem
extends Resource

@export var item: PackedScene
@export var cost: float = 30
@export var icon: Texture2D

func create_shop_button() -> ShoppingButton:
	var button: ShoppingButton = ShoppingButton.new()
	button.shop_item = self
	button.button_group = Global.game_manager.gui.shop_button_group
	button.toggle_mode = true
	return button
	
