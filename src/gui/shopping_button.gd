class_name ShoppingButton
extends Button

var shop_item: ShopItem 

func _ready() -> void:
	setup()

func setup() -> void:
	setup_label()
	if is_instance_valid(shop_item.icon):
		icon = shop_item.icon

func setup_label() -> void:
	text = '%s for %s' % [shop_item.resource_name, shop_item.cost]
