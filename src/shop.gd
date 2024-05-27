extends VBoxContainer

func _ready():
	parse_shop_items()

func parse_shop_items() -> void:
	# Open the "res://" directory (change path if needed)
	var path = "res://res/gui/shop/"
	var directory = DirAccess.open(path)
	if !directory:
		print("Failed to open directory:", DirAccess.get_open_error())
		return
	
	# List files recursively (set to false for non-recursive)
	directory.list_dir_begin()
	
	var file = directory.get_next()
	while file != "":
		create_shop_button_from_file(path + file)
		file = directory.get_next()
	
	# Close the directory
	directory.list_dir_end()


func create_shop_button_from_file(res_path: String) -> void:
	var shop_item = load(res_path) as ShopItem
	if not is_instance_valid(shop_item):
		return
	create_shop_button(shop_item)

func create_shop_button(shop_item: ShopItem) -> void:
	var button: ShoppingButton = ShoppingButton.new()
	button.shop_item = shop_item
	button.button_group = Global.game_manager.gui.shop_button_group
	button.toggle_mode = true
	add_child(button)
	
