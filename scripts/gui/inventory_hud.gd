extends Control
class_name InventoryHUD

@onready var storage_container = %StorageContainer
@onready var inventory_container = %InventoryContainer
@onready var equipment_slots_container = %EquipmentSlotsContainer
@onready var inventory_slots_container = %InventorySlotsContainer
@onready var hotbar_slots_container = %HotbarSlotsContainer
@onready var backpack_slots_container = %BackpackSlotsContainer

@onready var buttons_container = %ButtonsContainer
@onready var inventory_button = %InventoryButton
@onready var backpack_button = %BackpackButton

@onready var tabs : Dictionary = {
	inventory_button : inventory_slots_container,
	backpack_button : backpack_slots_container
}

var slot_instance = preload("res://nodes/gui/slot.tscn")

var inventory : InventoryClass
var inventory_visible : bool
var hotkey_shift := false
var holding_item

var item_selected := 0:
	set(value):
		item_selected = value
var storages_container_dic : Dictionary
var drag_data := {
	"origin_slot": null,
	"data": null
	}

func _ready():
	await owner.ready
	inventory = owner.inventory
	create_inventory()
	item_selected = 0
	
	hide_inventory()
	change_scale(Global.scale)
	for button in buttons_container.get_children():
		button.pressed.connect(change_tab.bind(button))
	
	inventory_button.emit_signal("pressed")
	
	Global.scale_changed.connect(change_scale)

func change_tab(b : BaseButton):
	for button in buttons_container.get_children():
		if button.is_pressed():
			button.button_pressed = false
			button.z_index = -1
			tabs[button].visible = false
	b.button_pressed = true
	b.z_index = 1
	
	tabs[b].visible = true

func hide_inventory():
	inventory_container.visible = false
	storage_container.visible = false
	inventory_visible = false

func show_inventory():
	inventory_container.visible = true
	storage_container.visible = true
	inventory_visible = true

func change_scale(gui_scale):
	inventory_container.scale = gui_scale
	storage_container.scale = gui_scale
	hotbar_slots_container.scale = gui_scale
	
	hotbar_slots_container.anchors_preset = PRESET_BOTTOM_RIGHT
	hotbar_slots_container.pivot_offset = Vector2(hotbar_slots_container.size.x, hotbar_slots_container.size.y)

func create_inventory():
	var index := 0
	var equip_index := 1
	
	for i in inventory.size:
		var slot : SlotClass = slot_instance.instantiate()
		slot.inventory = inventory
		slot.slot_type = inventory.inventory_items[i].data.slot_type
		slot.slot_index = inventory.inventory_items[i].data.slot_index
		slot.slot_data = inventory.inventory_items[i].item
		slot.inventory_panel = self
		slot.inventory.item_changed.connect(slot.display_item)
		slot.connect("gui_input",Callable(self,"slot_gui_input").bind(slot))
		
		inventory_slots_container.add_child(slot, true)
		
#		slot.get_node("Label").text = str(slot.slot_type)
		
		index += 1
	
	for i in inventory.equipment_size:
		var slot : SlotClass = slot_instance.instantiate()
		slot.inventory = inventory
		slot.slot_type = inventory.equipment_items[i].data.slot_type
		slot.slot_index = inventory.equipment_items[i].data.slot_index
		slot.slot_data = inventory.equipment_items[i].item
		slot.inventory_panel = self
		slot.inventory.item_changed.connect(slot.display_item)
		slot.connect("gui_input",Callable(self,"slot_gui_input").bind(slot))
		
		equipment_slots_container.add_child(slot, true)
		
#		slot.get_node("Label").text = str(slot.slot_type)
		
		index += 1

func create_storage(storage : StorageClass):
	var storage_slots := GridContainer.new()
	storage_slots.columns = 5
	storage_slots.add_theme_constant_override("h_separation", 2)
	storage_slots.add_theme_constant_override("v_separation", 2)
	storage_container.add_child(storage_slots)
	
	for i in storage.inventory.size:
		var slot : SlotClass = slot_instance.instantiate()
		slot.inventory = storage.inventory
		slot.slot_type = storage.inventory.inventory_items[i].data.slot_type
		slot.slot_index = storage.inventory.inventory_items[i].data.slot_index
		slot.slot_data = storage.inventory.inventory_items[i].item
		slot.inventory_panel = self
		slot.inventory.item_changed.connect(slot.display_item)
		slot.connect("gui_input",Callable(self,"slot_gui_input").bind(slot))
		
		storage_slots.add_child(slot, true)
		storages_container_dic[storage] = storage_slots
		slot.display_item(storage.inventory.inventory_items[i].data, slot.slot_data)

func delete_storage(storage : StorageClass):
	storages_container_dic[storage].queue_free()

func slot_gui_input(event : InputEventMouse, slot : SlotClass):
	#Agarrar item
	if event is InputEventMouseButton:
		if inventory_visible:
			var data = slot.slot_data
			if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
				if data:
					if hotkey_shift:
						if slot.inventory == inventory:
							move_item_to_storage(slot, data)
						else:
							move_item_to_inventory(slot, data)
					else:
						if drag_data.data:
							if slot.slot_type == drag_data.data.item.equip_slot or slot.slot_type == Global.SLOT_TYPE.default:
								slot.swap_item()
						else:
							drag_data = slot.pick_item()
				elif drag_data.data:
					if slot.slot_type == drag_data.data.item.equip_slot or slot.slot_type == Global.SLOT_TYPE.default:
						slot.put_item(drag_data.data)
			if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
				print(data)

func _input(event):
	if event.is_action_pressed("open_inventory"):
		if inventory_visible:
			hide_inventory()
		else:
			show_inventory()
	elif event.is_action_pressed("hotbar_1"):
		item_selected = 0
	elif event.is_action_pressed("hotbar_2"):
		item_selected = 1
	elif event.is_action_pressed("hotbar_3"):
		item_selected = 2
	
	if event is InputEventKey:
		hotkey_shift = true if event.keycode == 4194325 and event.pressed else false
	
	holding_item = find_parent("UserInterface").holding_item
	
	if holding_item:
		holding_item.global_position = get_global_mouse_position() - (holding_item.size / 2) * Global.scale
		holding_item.scale = Global.scale

func move_item_to_storage(origin_slot : SlotClass , data : Dictionary):
	var target_slot : SlotClass
	if storage_container.get_child_count() > 0:
		var storage_slots = storage_container.get_child(0)
		for slot in storage_slots.get_children():
			if slot.slot_data == {}:
				target_slot = slot
				break
		if target_slot:
			target_slot.put_item(data)
			origin_slot.inventory.remove_item(origin_slot.slot_index)

func move_item_to_inventory(origin_slot : SlotClass , data : Dictionary):
	var target_slot : SlotClass
	for slot in inventory_slots_container.get_children():
		if slot.slot_data == {} and slot.slot_type == Global.SLOT_TYPE.default:
			target_slot = slot
			break
	if target_slot:
		target_slot.put_item(data)
		origin_slot.inventory.remove_item(origin_slot.slot_index)
