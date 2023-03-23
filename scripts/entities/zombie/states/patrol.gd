extends State

@export_node_path("State") var initial_state : = NodePath()
@onready var state : State = get_node(initial_state)

func enter_state(msg := {}):
	state.enter_state(msg)

func state_process(delta):
	state.state_process(delta)
