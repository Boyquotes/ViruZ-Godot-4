extends Resource
class_name CharacterClass

#CharacterClass es la clase de cada personaje del juego
#Se controla cada acción que hace el personaje

signal desequip_item(item, slot)
signal equip_item(item, slot)
signal drop_item(item, slot)

@export_category("Atributos") 
@export var health : float = 100
@export var stamina : float = 200
@export var inventory_size : int = 18
@export var inventory_equipment_size = 4

var inventory : InventoryClass
var item_primary_hand : ItemClass
var item_secondary_hand : ItemClass
var entity : EntityClass


#Se le pasa a new_health el valor a añadir a la vida del personaje
func addHealth(new_health : float):
	if entity.health <= health:
		entity.health += new_health
	entity.health = clamp(entity.health, 0, health)

#Se le pasa a new_health el valor que se le quitara a la vida del personaje
func decreaseHealth(new_health : float):
	if entity.health > 0:
		entity.health -= new_health
	else:
		entity.health = 0
		kill()

#Lo mismo que addHealth
func addStamina(new_stamina : float):
	if entity.stamina < stamina:
		entity.stamina += new_stamina

#Lo mismo que decreaseHealth
func decreaseStamina(new_stamina : float):
	if entity.stamina > 0:
		entity.stamina -= new_stamina

#Funcion que toma el daño que recibe el personaje
func takeDamage(damage):
	decreaseHealth(damage)

#Funcion que mata al personaje
func kill():
	print("entity death")
