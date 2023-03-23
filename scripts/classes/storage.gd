extends StaticBody2D
class_name StorageClass

@export var size := 10
@export var loot_table : JSON

var inventory : InventoryClass

func _ready():
	inventory = InventoryClass.new(self)
	inventory.size = size
	if loot_table:
		var items_data = loot_table.data.items
		
		for data in items_data:
			var amount : int = 0
			if data.has("rolls"):
				amount = data.rolls
			elif data.has("roll_min") and data.has("roll_max"):
				amount = randi_range(data.roll_min, data.roll_max)
			var current_amount := 0
			var item_resource = ItemsDataBase.get_item_by_id(data.id)
			while current_amount < amount:
				var range := randf_range(0, inventory.inventory_items.size())
				if inventory.inventory_items[range].item == {}:
					inventory.set_item(range, item_resource)
					current_amount += 1
		

func get_objet_class() -> String:
	return "StorageClass"
