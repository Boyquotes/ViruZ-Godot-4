extends Node
class_name State

var state_machine : StateMachine = null

var target : EntityClass
var body : BodyClass
var blend_position : Vector2 = Vector2(0,1)

func enter_state(msg := {}) -> void:
	pass

func exit_state() -> void:
	pass

func state_input(_event: InputEvent) -> void:
	pass

func state_process(_delta: float) -> void:
	pass 

func state_physics_process(_delta: float) -> void:
	pass 
