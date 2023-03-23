extends Resource
class_name InventoryClass

signal item_changed(slot_data, item)
signal size_changed(size)

var data := {
		"item" : null,
		"amount": 0,
		"description": "",
		"atributes": {}
	}

var inventory_items : Array[Dictionary]
var equipment_items : Array[Dictionary]

@export var owner : PhysicsBody2D

@export var size : int :
	set(value):
		size = value
		inventory_items.resize(size)
		for i in inventory_items.size():
			inventory_items[i] = {
				"data" : {
					"slot_type" : Global.SLOT_TYPE.default,
					"slot_index" : i
				},
				"item": {}
			}

@export var equipment_size : int :
	set(value):
		equipment_size = value
		equipment_items.resize(equipment_size)
		for i in equipment_items.size():
			equipment_items[i] = {
				"data" : {
					"slot_type" : (2 + i) / 2,
					"slot_index" : i
				},
				"item": {}
			}

func _init(o):
	owner = o
	resource_local_to_scene = true

func add_item(item : ItemClass):
	for slot in inventory_items:
		if slot.item == {}:
			set_item(slot.data.slot_index, item)
			return true
	return false

func set_item(index : int, item : ItemClass, amount : int = 1):
	var item_data := data.duplicate()
	
	item_data["item"] = item
	item_data["amount"] = amount
	item_data["description"] = item.description
	inventory_items[index].item = item_data
	
	emit_signal("item_changed", inventory_items[index].data, item_data)

func set_equipment_item(index : int, item : ItemClass, amount : int = 1):
	var item_data := data.duplicate()
	
	item_data["item"] = item
	item_data["amount"] = amount
	item_data["description"] = item.description
	
	item.equip_item(owner, equipment_items[index].data.slot_type)
	
	equipment_items[index].item = item_data
	
	emit_signal("item_changed", equipment_items[index].data, item_data)

func remove_item(index : int):
	var previousItem = inventory_items[index]
	
	inventory_items[index].item = {}
	
	emit_signal("item_changed", inventory_items[index].data, inventory_items[index].item)
	return previousItem

func remove_equipment(index : int):
	var previousItem = inventory_items[index]
	
	equipment_items[index].item = {}
	
	emit_signal("item_changed", equipment_items[index].data, equipment_items[index].item)
	return previousItem
