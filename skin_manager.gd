extends Node2D

@export var skin := Texture2D
@export var map := Texture2D
@export var new_color := Color()

var image_map : Image
var image_skin : Image

var souce_file_coordinates := {}
var base_skin_coordinates := {}

var skin_colors := {}
var map_coordinates := {}

func _ready():
	test_create_image()
#	image_map = load_image(map.resource_path)
#	map_coordinates = get_map_pixels(image_map)
#	update_skin(skin)

func load_image(path : String):
	var image := Image.load_from_file(path)
	return image

func update_skin(skin):
	image_skin = skin.get_image()
	var image_base_skin = load_image($Body.texture.resource_path)
	skin_colors = get_map_pixels(image_skin)
	base_skin_coordinates = get_texture_pixels(image_base_skin)
#	apply_skin(image_base_skin)

func test_create_image():
	var img = Image.create(32,32,false,Image.FORMAT_RGBA8)
	
	var height = img.get_height()
	var width = img.get_width()
	
	var cell_x = 0
	var cell_y = 0
	var cur_pos = Vector2()
	
	for pixel in width*height:
		cur_pos = Vector2(cell_x, cell_y)
		
		if cell_x % 2 == 0:
			img.set_pixelv(cur_pos, Color8(255,255,255))
		
		if cell_x >= width - 1:
			cell_x = 0
			cell_y += 1
		else:
			cell_x += 1
		
	
	img.save_png("res://white.png")
	
	$Body.texture = load("res://white.png")

func apply_skin(skin : Image):
	
	print($Body.texture.get_data())
	var width = skin.get_width()
	var height = skin.get_height()
	
	var cell_x = 0
	var cell_y = 0
	var cur_pos = Vector2()
	
	var new_image := Image.create(width, height, false, Image.FORMAT_ETC2_RGBA8)
	
	for pixel in width*height:
		cur_pos = Vector2(cell_x, cell_y)
		
		var cur_pixel = skin.get_pixelv(cur_pos)
		if cur_pixel in map_coordinates.keys():
			new_image.set_pixelv(cur_pixel, skin_colors[str(cur_pixel)])
		
		if cell_x >= width - 1:
			cell_x = 0
			cell_y += 1
		else:
			cell_x += 1
	
	var new_texture = ImageTexture.create_from_image(new_image)
	$Body.texture = new_texture

func get_map_pixels(image : Image):
	var width = image.get_width()
	var height = image.get_height()
	var coordinates := {}
	
	var cell_x = 0
	var cell_y = 0
	var cur_pos = Vector2()
	for pixel in width*height:
		cur_pos = Vector2(cell_x, cell_y)
		var cur_pixel = image.get_pixelv(cur_pos)
		if cur_pixel != Color(0,0,0,0):
			coordinates[cur_pos] = cur_pixel
		if cell_x >= width - 1:
			cell_x = 0
			cell_y += 1
		else:
			cell_x += 1
	return coordinates

func get_texture_pixels(image : Image):
	var width = image.get_width()
	var height = image.get_height()
	var coordinates := {}
	
	var cell_x = 0
	var cell_y = 0
	var cur_pos = Vector2()
	for pixel in width*height:
		cur_pos = Vector2(cell_x, cell_y)
		var cur_pixel = image.get_pixelv(cur_pos)
		if cur_pixel != Color(0,0,0,0):
			if cur_pixel in map_coordinates.values():
				coordinates[cur_pos] = cur_pixel
		if cell_x >= width - 1:
			cell_x = 0
			cell_y += 1
		else:
			cell_x += 1
	return coordinates
