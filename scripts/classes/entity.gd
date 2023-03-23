extends CharacterBody2D
class_name EntityClass


var speed = 100
var acceleration = 10
var friction = 10

var health : float
var stamina : float

@export_group("Atributos", "max_")
@export var max_health := 100.0
@export var max_stamina := 200.0

@export var inventory_size := 8

@onready var body : CanvasGroup = $Body

var inventory : InventoryClass = null
var item_in_primary_hand : Dictionary:
	set(value):
		item_in_primary_hand = value
		emit_signal("item_on_primary_hand")

func _ready():
	inventory = InventoryClass.new(self)
	inventory.size = inventory_size
	inventory.equipment_size = 8
	
	health = max_health
	stamina = max_stamina

func equip_item(item : ItemClass, slot_type : int):
	print("Se equipo "+item.display_name+" en "+str(slot_type))

func addHealth(new_health : float):
	if health <= health:
		health += new_health
	health = clamp(health, 0, max_health)

func decreaseHealth(new_health : float):
	if health > 0:
		health -= new_health
	else:
		health = 0
		kill()

func addStamina(new_stamina : float):
	if stamina < stamina:
		stamina += new_stamina
	health = clamp(health, 0, max_stamina)

func decreaseStamina(new_stamina : float):
	if stamina > 0:
		stamina -= new_stamina

func takeDamage(damage):
	decreaseHealth(damage)

func kill():
	print("entity death")
