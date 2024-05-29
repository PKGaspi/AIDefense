class_name ShoppingButton
extends Button

var shop_item: ShopItem 

func _ready() -> void:
	setup_label()

func setup_label() -> void:
	text = '%s for %s' % [shop_item.resource_name, shop_item.cost]
