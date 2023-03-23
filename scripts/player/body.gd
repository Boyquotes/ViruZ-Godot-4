@tool
extends CanvasGroup
class_name BodyClass

@export var map_texture : Texture2D = null:
	set(new_texture):
		map_texture = new_texture
		apply_maps(map_texture)

@export var skin_texture : Texture2D = null:
	set(new_texture):
		skin_texture = new_texture
		apply_skin(skin_texture)

@export var base_texture : Texture2D = null:
	set(new_texture):
		base_texture = new_texture
		apply_base(base_texture)

func apply_maps(texture : Texture2D):
	for child in get_children():
		child.map_texture = map_texture

func apply_skin(texture : Texture2D):
	for child in get_children():
		child.skin_texture = skin_texture

func apply_base(texture : Texture2D):
	for child in get_children():
		child.base_texture = base_texture
