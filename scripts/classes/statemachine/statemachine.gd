extends Node
class_name StateMachine

signal state_change

@export_node_path("State") var initial_state : = NodePath()
@onready var state : State = get_node(initial_state)

func _ready():
	await owner.ready
	for _state in get_children():
		_state.target = owner
		_state.state_machine = self
		if _state.get_child_count() > 0:
			for _state_ in _state.get_children():
				_state.target = owner
				_state.state_machine = self
	
	if state:
		state.enter_state()

func change_state(target_state: String, msg := {}):
	if not has_node(target_state):
		return
	
	if state:
		state.exit_state()
	
	state = get_node(target_state)
	state.enter_state(msg)
	emit_signal("state_change", state.name)

func _process(delta):
	state.state_process(delta)

func _input(event):
	state.state_input(event)

func _physics_process(delta):
	state.state_physics_process(delta)

