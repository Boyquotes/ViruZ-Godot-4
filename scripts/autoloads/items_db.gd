extends Node

var ITEMS := {}

func _ready():
	var items := _load_items()
	for item in items:
		ITEMS[item.ID] = item
	

#func get_item_data(unique_id: String) -> ItemClass:
#	if not unique_id in ITEMS:
#		return null
#	return ITEMS[unique_id].attributes

static func _load_items() -> Array:
	var item_files := []
	var items_folder := "res://items/"
	
	
#	var directory := Directory.new()
#	var _can_continue := directory.open(items_folder) == OK
#
#	directory.list_dir_begin() # TODOGODOT4 fill missing arguments https://github.com/godotengine/godot/pull/40547
#	var file_name := directory.get_next()
#	while file_name != "":
#		if file_name.get_extension() == "tres":
#			item_files.append(items_folder.plus_file(file_name))
#		file_name = directory.get_next()
	
	var item_resources := []
	for path in item_files:
		item_resources.append(load(path))
	
	return item_resources
