extends State

func enter_state(msg := {}):
	pass

func state_process(delta):
	
	if target.input_vector == Vector2.ZERO: # or target.inventory_panel.inventory_visible:
		state_machine.change_state("Idle")
	
	target.velocity = target.input_vector * target.speed
	
	target.debug_label.text = str(target.velocity)
	
	target.move_and_slide()
