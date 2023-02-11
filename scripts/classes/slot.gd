extends Control
class_name SlotClass

#Referencia al inventario del cual recibira los datos
var inventory : InventoryClass

#Referencia al nodo ToolTip
#@onready var tooltip = preload("res://nodes/gui/ToolTips.tscn")

#Referencia al nodo que muestra el item y su cantidad
#@onready var item_ui = preload("res://nodes/gui/ItemUI.tscn")

var data = {
	"item": null,
	"quantity": 0
}


var slot_type         #Tipo de slot
var slot_index : int  #Index del slot

func _ready():
	connect("mouse_entered",Callable(self,"on_focus_entered_slot"))
	connect("mouse_exited",Callable(self,"on_focus_exited_slot"))

#Esta función muestra el item en el slot 
#Pasandole como parametro el item a mostrar
func display_item(_data):
	if _data.item != null:
		$ItemUI/ItemTexture.texture = _data.item.texture_item
		if _data["quantity"] > 1:
			$ItemUI/StackLabel.text = str(_data.quantity)
	else:
		$ItemUI/ItemTexture.texture = null
		$ItemUI/StackLabel.text = ""


func on_focus_entered_slot():
	self_modulate = Color8(445,445,445,255)

func on_focus_exited_slot():
	self_modulate = Color8(255,255,255,255)

#func display_tooltip(parent):
#	#Si hay un item en el slot
#	if data != null:
#		#Y no hay un tooltip activado se crea uno
#		if not parent.has_node("ToolTip"):
#			var tool_tip_instance = tooltip.instantiate()
#			tool_tip_instance.position = Vector2(200,200)            #Posision del ToolTip
#			tool_tip_instance.item_data = data                       #Asignarle item_data al ToolTip
#			tool_tip_instance.slot = self                            #Asignarle el slot al ToolTip
#			tool_tip_instance.player = inventory.owner               #Asignarle el jugador al ToolTip
#			parent.add_child(tool_tip_instance, true)
#			if parent.has_node("ToolTip"):                           #Si hay un ToolTip se coloca en visible
#				parent.get_node("ToolTip").show()
#		else:
#			parent.get_node("ToolTip").queue_free()                  #Si hay un ToolTip se elimina a si mismo

func pick_from_slot():
#	show_holding_item()
	
	if slot_type != Global.SLOT_TYPE.default:
		inventory.owner.emit_signal("desequip_item", data.item, self)
	
	inventory.drag_data["data"] = data
	inventory.drag_data["origin_slot"] = self
	inventory.remove_item(slot_index)
	data = {
		"item": null,
		"quantity": 0
	}
	

func put_into_slot(data_draged):
	find_parent("Inventory").play_sound(find_parent("Inventory").item_put_slot_sound)
	
	find_parent("UserInterface").remove_child(find_parent("UserInterface").holding_item)
	find_parent("UserInterface").holding_item = null
	
	inventory.set_item(slot_index, data_draged.item, data_draged.quantity)
	
	data = data_draged
	
	if slot_type != Global.SLOT_TYPE.default:
		inventory.owner.emit_signal("equip_item", data.item, self)
	
	inventory.drag_data["origin_slot"] = null
	inventory.drag_data["data"] = null

#func show_holding_item():
#	find_parent("Inventory").play_sound(find_parent("Inventory").item_pick_slot_sound)
#	var ITEM_UI = item_ui.instantiate()
#	ITEM_UI.get_node("ItemTexture").texture = data.item.texture_item
#	ITEM_UI.scale = Global.gui_scale
#	find_parent("UserInterface").add_child(ITEM_UI)
#	find_parent("UserInterface").holding_item = ITEM_UI
#	find_parent("UserInterface").holding_item.global_position = get_global_mouse_position() - (ITEM_UI.size / 2) * Global.gui_scale

func remove_item():
	inventory.remove_item(slot_index)

func add_quantity(quantity : int):
	find_parent("UserInterface").remove_child(find_parent("UserInterface").holding_item)
	find_parent("UserInterface").holding_item = null
	
	inventory.drag_data["origin_slot"] = null
	inventory.drag_data["data"] = null
	
	inventory.add_quantity(slot_index, quantity)
