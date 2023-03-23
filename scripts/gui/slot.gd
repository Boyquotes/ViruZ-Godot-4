extends Control
class_name SlotClass

var inventory : InventoryClass
var inventory_panel : InventoryHUD

var slot_data := {}

var item_display = preload("res://nodes/gui/item_display.tscn")
var tool_tip = preload("res://nodes/gui/tool_tip.tscn")

var slot_type : int   #Tipo de slot
var slot_index : int  #Index del slot

func _ready():
	mouse_entered.connect(select_slot)
	mouse_exited.connect(deselect_slot)

func select_slot():
	self.modulate += Color(0.4115, 0.4115, 0.4115, 1)

func deselect_slot():
	self.modulate = Color(1, 1, 1, 1)

func display_item(_slot_data, item_data):
	if _slot_data.slot_type == slot_type and _slot_data.slot_index == slot_index:
		
		var item_texture = $ItemDisplay/ItemTexture
		var item_stack = $ItemDisplay/StackLabel
		
		if item_data:
			item_texture.texture = item_data.item.texture
			if item_data.amount > 1:
				item_stack.text = str(item_data.amount)
		else:
			item_texture.texture = null
			item_stack.text = ""
		
		slot_data = item_data

func pick_item():
	var drag_data := {
	"origin_slot": self,
	"data": slot_data
	}
	
	show_holding_item()
	if slot_type != Global.SLOT_TYPE.default:
		inventory.remove_equipment(slot_index)
	else:
		inventory.remove_item(slot_index)
	
	slot_data = {}
	return drag_data

func swap_item():
	var temp_data = inventory_panel.drag_data.data
	
	inventory_panel.drag_data.origin_slot = self
	inventory_panel.drag_data.data = slot_data
	hide_holding_item()
	show_holding_item()
	inventory.set_item(slot_index, temp_data.item)

func put_item(data_draged : Dictionary):
	if slot_type != Global.SLOT_TYPE.default:
		inventory.set_equipment_item(slot_index, data_draged.item)
	else:
		inventory.set_item(slot_index, data_draged.item)
	
	slot_data = data_draged
	
	inventory_panel.drag_data["origin_slot"] = null
	inventory_panel.drag_data["data"] = null
	hide_holding_item()

func show_holding_item():
	var i_d = item_display.instantiate()
	i_d.get_node("ItemTexture").texture = slot_data.item.texture
	if slot_data.amount > 1:
		i_d.get_node("StackLabel").text = str(slot_data.amount)
	find_parent("UserInterface").add_child(i_d)
	find_parent("UserInterface").holding_item = i_d
	find_parent("UserInterface").holding_item.global_position = get_global_mouse_position() - (i_d.size / 2) * Global.scale
	find_parent("UserInterface").holding_item.scale = Global.scale
	

func hide_holding_item():
	if find_parent("UserInterface").holding_item:
		find_parent("UserInterface").remove_child(find_parent("UserInterface").holding_item)
		find_parent("UserInterface").holding_item = null
