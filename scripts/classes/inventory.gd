extends Resource
class_name InventoryClass

var drag_data := {
	"origin_slot": null,
	"data": null
}

signal item_changed(index, item)

var inventory_equipment_size : int

var owner 
var inventory_items := []
var equipment_size : int

func _init(inventory_size : int, inventory_equipment_size : int, _owner):
	
	var data := {
		"item" : null,
		"quantity": 0
	}
	
	inventory_items.resize(inventory_size + inventory_equipment_size)
	inventory_items.fill(data)
	
	equipment_size = inventory_equipment_size
	
	owner = _owner
	

func is_full() -> bool:
	var full
	for index in inventory_items.size() - equipment_size:
		if inventory_items[index]["item"]:
			full = true
		else:
			full = false
	return full

func add_item(item : ItemClass):
	for index in inventory_items.size() - equipment_size:
		if inventory_items[index]["item"]:
			continue
		set_item(index, item)
		break
	

func set_item(slot : int, item : ItemClass, quantity : int = 1):
	var data = {
		"item": item,
		"quantity": quantity
	}
	inventory_items[slot] = data
	emit_signal("item_changed", slot, data)

func remove_item(index : int, quantity : int = 0):
	var previousItem = inventory_items[index]
	var data = {
		"item": null,
		"quantity": quantity
	}
	inventory_items[index] = data
	emit_signal("item_changed", index, inventory_items[index])
	return previousItem

func add_quantity(index : int, quantity : int):
	if inventory_items[index]["quantity"] < inventory_items[index]["item"].max_stack_size:
		inventory_items[index]["quantity"] += quantity
	else:
		add_item(inventory_items[index]["item"])
	emit_signal("item_changed", index, inventory_items[index])

func remove_quantity(index : int, quantity : int):
	inventory_items[index]["quantity"] -= quantity
	if inventory_items[index]["quantity"] <= 0:
		remove_item(index)
	emit_signal("item_changed", index, inventory_items[index])
