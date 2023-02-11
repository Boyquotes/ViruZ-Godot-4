extends Node
class_name StateMachine

signal state_change

@export var target : EntityClass = null
@export var initial_state := NodePath()
@onready var state : State = get_node(initial_state)

func start_statemachine():
	await owner.ready
	for _state in get_children():
		_state.state_machine = self
		_state.target = target
	
	state.enter_state()

func change_state(target_state: String, msg := {}):
	if not has_node(target_state):
		return
	
	if state:
		state.exit_state()
	
	state = get_node(target_state)
	state.enter_state(msg)
	emit_signal("state_change", state.name)

