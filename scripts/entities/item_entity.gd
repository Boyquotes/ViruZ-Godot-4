@tool
extends Area2D
class_name ItemEntity

@onready var icon = $Icon
@onready var item_sprite = $Item

@export var item : ItemClass:
	set(value):
		item = value
		if item != null:
			name = item.display_name + "__1"
			$Item.texture = item.texture
		else:
			name = "ItemEntity"
			$Item.texture = null

func _ready():
	if item:
		name = item.display_name + "__1"
		item_sprite.texture = item.texture
		icon.visible = false

func get_objet_class() -> String:
	return "ItemEntity"
