@icon("res://textures/gui/class_icons/player.png")
extends EntityClass
class_name Player

#Vector de teclas de movimiento
var input_vector = Vector2.ZERO

var items_in_range : Dictionary
var interactuables_in_range : Dictionary

@export var character : CharacterClass

@onready var inventory_panel : InventoryHUD = %Inventory      #Referencia al nodo control Inventario

func _ready():
	Global.player = self
	
#	character.set_entity(self)
	
#	inventory_panel.inventory = inventory
#	inventory_panel.create_inventory()
#
	character.connect("desequip_item",Callable(self,"desequip_item"))
	character.connect("equip_item",Callable(self,"equip_item"))
	character.connect("drop_item",Callable(self,"drop_item"))
#
#	$InteractiveArea.connect("body_entered", Callable(self,"interactive_body_entered"))
#	$InteractiveArea.connect("area_entered", Callable(self,"interactive_area_entered"))
#	$InteractiveArea.connect("area_exited", Callable(self,"interactive_area_exited"))
	

func _input(event):
	pass
#	if event.is_action_pressed("pick_item"):
#		if items_in_range.size() > 0 and !character.inventory.is_full():
#			character.inventory.add_item(items_in_range.values()[0].item)
#			items_in_range.values()[0].queue_free()
#			items_in_range.erase(items_in_range.values()[0])
#	if event.is_action_pressed("interact"):
#		if interactuables_in_range.size() > 0:
#			var first = interactuables_in_range.values()[0]
#			interactuables_in_range[first].interact()
	

func equip_item(equiment_item : ItemClass, slot : SlotClass):
	
	match slot.slot_type:
		Global.SLOT_TYPE.head:
#			player_body.set_clothing_head(equiment_item.texture_on_equip)
			pass
	
	print("se equipo ",equiment_item.display_name)

func desequip_item(equiment_item : ItemClass,  slot : SlotClass):
	match slot.slot_type:
		Global.SLOT_TYPE.head:
#			player_body.unset_clothing_head()
			pass
	print("se desequipo ",equiment_item.display_name)

func drop_item(item_drop : ItemClass, slot : SlotClass, quantity : int = 1):
	
	slot.remove_item()
	
#	var item_instance =  item_droped.instantiate()
#	item_instance.item = item_drop
#	item_instance.global_position = global_position + Vector2(randf_range(-3,3),randf_range(-3,3))
#	get_parent().add_child(item_instance)

func interactive_body_entered(body : Node2D):
	pass

func interactive_area_entered(interactive):
	if interactive is ItemDropedClass:
		items_in_range[interactive] = interactive
	
#	if interactive is TriggerClass:
#		interactuables_in_range[interactive] = interactive
		

func interactive_area_exited(interactive):
	if interactive is ItemDropedClass:
		items_in_range.erase(interactive)
#	if interactive is TriggerClass:
#		interactuables_in_range.erase(interactive)
