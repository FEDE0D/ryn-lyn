extends Node
class_name StateMachine

signal on_state_changed(old_state, new_state)
export(NodePath) onready var state = get_node(state)

func change_state(state_name: String, param = null):
	var new_state = get_node(state_name)
	assert(new_state, "New state with name %s cannot be found" % state_name)
	assert(new_state != state, "New state is same as current state")
	
	set_process(false)
	set_physics_process(false)
	var old_state = state
	state = new_state
	old_state._on_state_exit()
	new_state._on_state_enter(param)
	emit_signal("on_state_changed", old_state.name, new_state.name)
	set_process(true)
	set_physics_process(true)

func _process(delta):
	state._process_state(delta)

func _physics_process(delta):
	state._physics_process_state(delta)
