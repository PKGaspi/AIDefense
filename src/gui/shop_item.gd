class_name ShopItem
extends Resource

@export var item: PackedScene
@export var cost: float = 30
@export var icon: Texture2D

func create_shop_button() -> ShoppingButton:
	var button: ShoppingButton = ShoppingButton.new()
	button.shop_item = self
	return button
	
