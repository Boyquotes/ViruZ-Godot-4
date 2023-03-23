@icon("res://textures/class_icons/player.png")
extends EntityClass
class_name Player

var input_vector : Vector2
var items_in_range : Dictionary
var interactive_in_range : Dictionary

@export var character : CharacterClass

@onready var interactive_area = %InteractiveArea
@onready var hurtbox = %Hurtbox
@onready var inventory_panel : InventoryHUD = %Inventory
@onready var debug_label = %Label

func _ready():
	super._ready()
	Global.player = self
	
	interactive_area.area_entered.connect(interactive_area_entered)
	interactive_area.area_exited.connect(interactive_area_exited)
	
	interactive_area.body_entered.connect(interactive_area_entered)
	interactive_area.body_exited.connect(interactive_area_exited)

func _process(delta):
	input_vector = Vector2(Input.get_axis("ui_left", "ui_right"), Input.get_axis("ui_up", "ui_down"))
	input_vector = input_vector.normalized()

func _input(event):
	if event.is_action_pressed("pick_items"):
		if items_in_range.size() > 0:
			var item_droped = items_in_range[items_in_range.keys()[0]]
			var item = item_droped.item
			if inventory.add_item(item):
				item_droped.queue_free()
				items_in_range.erase(item_droped)

func interactive_area_entered(interactive):
	match interactive.get_objet_class():
		"ItemEntity":
			items_in_range[interactive] = interactive
		"StorageClass":
			inventory_panel.create_storage(interactive)

func interactive_area_exited(interactive):
	match interactive.get_objet_class():
		"ItemEntity":
			items_in_range.erase(interactive)
		"StorageClass":
			inventory_panel.delete_storage(interactive)

