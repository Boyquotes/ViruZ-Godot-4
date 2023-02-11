@tool
@icon("res://textures/gui/class_icons/item_droped.png")
extends Node2D
class_name ItemDropedClass

@export var item : ItemClass

func _ready():
	name = item.display_name
	$ItemSprite.texture = item.texture_item
	$KeyIcon.visible = false
