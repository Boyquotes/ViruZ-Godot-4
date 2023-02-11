extends Resource
class_name CharacterClass

#CharacterClass es la clase de cada personaje del juego
#Se controla cada acción que hace el personaje

signal desequip_item(item, slot)            #Señal de que se desequipo un item de su slot correspondiente
signal equip_item(item, slot)         #Señal de que se equipo un item en su slot correspondiente
signal drop_item(item, slot)          #Señal de que dropeo un item

@export_category("Atributos")
@export var health : float                #Variable de vida maxima
@export var stamina : float               #Variable de estamina
@export var inventory_size : int = 18     #Slots que tendra el inventario
@export var inventory_equipment_size = 4

var inventory : InventoryClass      #Variable donde se guarda todo el inventario
var item_primary : ItemClass
var item_secondary : ItemClass
var entity : EntityClass

func set_entity(_entity : EntityClass):
	_entity.health = health
	_entity.stamina = stamina
	inventory = InventoryClass.new(inventory_size, inventory_equipment_size, self)

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
