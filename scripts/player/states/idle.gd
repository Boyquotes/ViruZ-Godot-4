extends State

func enter_state(msg := {}):
	target.velocity = Vector2.ZERO

func state_process(delta):
	
	if target.input_vector:
		state_machine.change_state("walk")
	
