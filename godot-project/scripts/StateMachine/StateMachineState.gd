extends Node
class_name StateMachineState

func _ready():
	set_process(false)
	set_physics_process(false)

func change_state(state_name: String, param = null):
	get_parent().change_state(state_name, param)

func _process_state(_delta):
	pass

func _physics_process_state(_delta):
	pass

func _on_state_enter(param = null):
	pass

func _on_state_exit():
	pass
