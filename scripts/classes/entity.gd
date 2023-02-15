extends CharacterBody2D
class_name EntityClass

var speed = 100
var acceleration = 10
var friction = 10

var health : float
var stamina : float

@export var max_health := 100.0
@export var max_stamina := 200.0

var inventory : InventoryClass = null

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
