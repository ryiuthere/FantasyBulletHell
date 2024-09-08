class_name StateMachine
extends Node

@export var initial_state: State

var current_state: State
var states: Dictionary = {}

func _ready() -> void:
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.transitioned.connect(on_child_transitioned)
	
	if initial_state:
		current_state = initial_state
		initial_state.enter()

func _process(delta) -> void:
	if current_state:
		current_state.update(delta)
		
func _physics_process(delta) -> void:
	if current_state:
		current_state.physics_update(delta)

func on_child_transitioned(state, new_state_name) -> void:
	if state != current_state:
		return
		
	var new_state = states.get(new_state_name.to_lower())
	
	if !new_state:
		return
	if current_state:
		current_state.exit()
		
	new_state.enter()
	current_state = new_state
	
