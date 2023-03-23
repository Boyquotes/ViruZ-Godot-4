extends State

func enter_state(msg := {}):
	target.velocity = Vector2.ZERO

func state_process(delta):
	
	if target.input_vector: #and not target.inventory_panel.inventory_visible:
		state_machine.change_state("Walk")
	
