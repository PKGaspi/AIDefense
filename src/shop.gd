extends GridContainer

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
	if '.tres.remap' in res_path:
		res_path = res_path.trim_suffix('.remap')
	var shop_item = load(res_path) as ShopItem
	if not is_instance_valid(shop_item):
		return
	add_child(shop_item.create_shop_button())
