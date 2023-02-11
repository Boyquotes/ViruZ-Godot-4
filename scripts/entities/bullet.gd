extends CharacterBody2D

var dir : Vector2 #Vector de direccion de la bala
var spd = 0 #Velocidad con la que viajara
var damage #Daño de la bala al impactar

var time_delete_seg = 1  #Tiempo para que se destruya si no coliciona con algo
var time : float #Contador de tiempo

@onready var audio = $AudioStreamPlayer2D

func _ready():
	#Colocar a la variable de daño el daño del arma equipada
	#damage = JsonData.item_data[str(JsonData.equipment_data["Primary"]["item"])]["Damage"]
	pass

func _physics_process(delta):
	
	#Le suma a time delta 
	time += delta
	
	#si tl tiempo es mañor a el tiempo para destruirse se destruye
	if time > time_delete_seg:
		queue_free()
	
	#normalizar el vector dir y multiplicarlo por la velocidad
	dir = dir.normalized() * spd
	
	#mover la bala
	set_velocity(dir)
	move_and_slide()
	var _vel = velocity
	

func _on_Area2D_body_entered(_body):
	queue_free()
