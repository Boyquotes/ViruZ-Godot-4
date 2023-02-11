extends CharacterBody2D

var speed = 30

var healt = 50
var current_healt = healt

var hit_pos = []

var target
var player_detect

func _ready():
	$TextureProgressBar.visible = false
	$TextureProgressBar.max_value = healt

func chase_target():
	var look = $Vision
	
	if player_detect:
		look.cast_to = target.global_position - global_position
		look.force_raycast_update()
		
		if !look.is_colliding() :
			velocity = look.cast_to.normalized()
	
	if velocity.x < 0:
		$Sprite2D.scale.x = -1
	elif velocity.x > 0:
		$Sprite2D.scale.x = 1
	
	var motion = velocity * speed
	set_velocity(motion)
	move_and_slide()
	var _vel = velocity

func _physics_process(_delta):
	chase_target()

