extends Node

var ITEMS := {}

func _ready():
	var items := _load_items()
	for item in items:
		ITEMS[item.ID] = item

func get_item_by_id(unique_id: String) -> ItemClass:
	if not unique_id in ITEMS:
		return null
	return ITEMS[unique_id]

static func _load_items() -> Array:
	var item_files := []
	var items_folder := "res://items/"
	
	var directory := DirAccess.open(items_folder)

	directory.list_dir_begin() 
	
	var file_name := directory.get_next()
	while file_name != "":
		if file_name.get_extension() == "tres":
			item_files.append(file_name)
		file_name = directory.get_next()
	
	var item_resources := []
	for path in item_files:
		item_resources.append(load(items_folder+path))
	
	
	return item_resources
