extends StateMachine

func _ready():
	start_statemachine()

func _process(delta):
	target.input_vector.x = Input.get_axis("ui_left", "ui_right")
	target.input_vector.y = Input.get_axis("ui_up", "ui_down")
	
	target.input_vector = target.input_vector.normalized()
	
	state.state_process(delta)
