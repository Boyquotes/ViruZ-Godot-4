@icon("res://textures/gui/class_icons/item.png")
extends Resource
class_name ItemClass

@export var display_name : String = ""
@export var ID : String = ""
@export var equip_slot : Global.SLOT_TYPE = Global.SLOT_TYPE.default
@export var texture_item : Texture2D
@export var max_stack_size := 1
@export_multiline var description : String = ""

@export_category("Optionals")
@export var texture_on_equip : Texture2D
@export var attributes : Dictionary

func on_hand():
	print("ASD")

func equip_item(player):
	player.emit_signal("equip_item",self)

func desequip_item(player):
	player.emit_signal("desequip_item",self)
