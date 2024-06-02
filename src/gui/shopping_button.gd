class_name ShoppingButton
extends Button

var shop_item: ShopItem 

func _ready() -> void:
	setup()

func setup() -> void:
	size_flags_horizontal = Control.SIZE_EXPAND_FILL
	button_group = Global.game_manager.gui.shop_button_group
	toggle_mode = true
	setup_label()
	if is_instance_valid(shop_item.icon):
		icon = shop_item.icon
		expand_icon = true
		icon_alignment = HORIZONTAL_ALIGNMENT_CENTER
		vertical_icon_alignment = VERTICAL_ALIGNMENT_TOP

func setup_label() -> void:
	text = 'G%s' % [shop_item.cost]
