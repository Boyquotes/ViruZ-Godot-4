extends Control

var inventory : InventoryClass
var hotbar

var item_put_slot_sound = preload("res://sounds/ui/item_put_slot.ogg")
var item_pick_slot_sound = preload("res://sounds/ui/item_pick_slot.ogg")

var open : bool

var slots_array := []

var holding_item = null

var slot_instance = preload("res://nodes/gui/slot.tscn")

@onready var SoundPlayer = $AudioStreamPlayer2D
@onready var SlotContainer = %SlotContainer
@onready var ItemHands = %ItemHands
@onready var EquipContainer = %Equipment

func _ready():
	hide()

func create_inventory():
	#Crear slost de inventario
	var equip_index : int = 0
	for i in range(inventory.inventory_items.size()):
		var slot : SlotClass = slot_instance.instantiate()
		#slot.inventory = inventory
		slot.slot_index = i
		slot.data = inventory.inventory_items[i]
		slot.connect("gui_input",Callable(self,"slot_gui_input").bind(slot))
		
		if i < 3:
			ItemHands.add_child(slot, true)
			slot.slot_type = Global.SLOT_TYPE.default
		elif i < inventory.inventory_items.size() - inventory.equipment_size:
			SlotContainer.add_child(slot, true)
			slot.slot_type = Global.SLOT_TYPE.default
		else:
			EquipContainer.add_child(slot, true)
			match equip_index:
				0:
					slot.slot_type = Global.SLOT_TYPE.head
				1:
					slot.slot_type = Global.SLOT_TYPE.chest
				2:
					slot.slot_type = Global.SLOT_TYPE.legs
				3:
					slot.slot_type = Global.SLOT_TYPE.feets
			
			equip_index += 1
			
		
		
		slots_array.append(slot)
	

func slot_gui_input(event : InputEvent, slot : SlotClass):
	#Agarrar item
	if event is InputEventMouseButton:
		
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			
			var data = slot.data
			#Soltar item
			if holding_item:
				if slot.slot_type == Global.SLOT_TYPE.default or inventory.drag_data.data.item.equip_slot == slot.slot_type:
					if data.item:
						if inventory.drag_data.data.item == data.item:
							if data.quantity < data.item.max_stack_size or inventory.drag_data.data.quantity > data.quantity:
								slot.add_quantity(inventory.drag_data.data.quantity)
							else:
								print("Stack Completo")
						else:
							print("Items distintos")
					else:
						slot.put_into_slot(inventory.drag_data.data)
			#Agarrar item cuando no tenemos ninguno en mano
			elif data.item:
				slot.pick_from_slot()
			
		#Menu de opciones
		elif event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			slot.display_tooltip(self)
	

func _input(event):
	holding_item = find_parent("UserInterface").holding_item
	
	if holding_item:
		holding_item.global_position = get_global_mouse_position() - (holding_item.size / 2) * Global.gui_scale
	
	if event.is_action_pressed("open_inventory"):
		if visible:
			hide()
			if inventory.drag_data["origin_slot"] != null:
				inventory.drag_data["origin_slot"].put_into_slot(inventory.drag_data.data)
				find_parent("UserInterface").holding_item = null
			if has_node("ToolTip"):
				get_node("ToolTip").queue_free()
	
			for slot in SlotContainer.get_children():
				slot.on_focus_exited_slot()
			for slot in EquipContainer.get_children():
				slot.on_focus_exited_slot()
			for slot in ItemHands.get_children():
				slot.on_focus_exited_slot()
	
		else:
			show()


func on_items_changed(index, data):
	slots_array[index].display_item(data)
	slots_array[index].data = data

func play_sound(sound):
	SoundPlayer.stream = sound
	SoundPlayer.play()
