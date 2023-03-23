@icon("res://textures/class_icons/item.png")
@tool
extends Resource
class_name ItemClass

@export var display_name : String = ""
@export var ID : String = ""
@export var type : Global.ITEM_TYPE = Global.ITEM_TYPE.default:
	set(value):
		type = value
		notify_property_list_changed()
@export var texture : CompressedTexture2D
@export var max_stack_size := 1
@export_multiline var description : String = ""

var damage := 0.0
var equip_slot := Global.SLOT_TYPE.default
var equip_texture : CompressedTexture2D = null

var inventory_size := 0
var contain_inventory := false:
	set(value):
		contain_inventory = value
		notify_property_list_changed()

func on_hand():
	print("ASD")

func equip_item(entity : EntityClass, slot_type : int):
	entity.equip_item(self, slot_type)

func desequip_item(entity : EntityClass):
	entity.emit_signal("desequip_item",self)

func _get_property_list():
	var property_usage = PROPERTY_USAGE_NO_EDITOR
	var properties = []
	
	match type:
		Global.ITEM_TYPE.combat:
			property_usage = PROPERTY_USAGE_DEFAULT
			var propertie := [{
				"name": "damage",
				"type": TYPE_FLOAT,
				"usage": property_usage
			}]
			properties.append_array(propertie)
		Global.ITEM_TYPE.equipable:
			property_usage = PROPERTY_USAGE_DEFAULT
			var propertie := [{
				"name": "equip_slot",
				"type": TYPE_INT,
				"usage": property_usage,
				"hint": PROPERTY_HINT_ENUM,
				"hint_string": Global.SLOT_TYPE.keys()
			},
			{
				"name": "contain_inventory",
				"type": TYPE_BOOL,
				"usage": property_usage
			},
			{
				"name": "equip_texture",
				"type": TYPE_OBJECT,
				"hint": PROPERTY_HINT_RESOURCE_TYPE,
				"hint_string": "Texture2D",
				"usage": property_usage
			}]
			properties.append_array(propertie)
	
	if contain_inventory:
		property_usage = PROPERTY_USAGE_DEFAULT
		var propertie := {
				"name": "inventory_size",
				"type": TYPE_INT,
				"usage": property_usage
			}
		properties.append(propertie)
	
	return properties
