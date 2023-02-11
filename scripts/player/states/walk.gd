extends State

func enter_state(msg := {}):
	pass

func state_process(delta):
	
	if target.input_vector == Vector2.ZERO:
		state_machine.change_state("idle")
	
	target.velocity = target.input_vector * target.speed
	
	target.move_and_slide()
