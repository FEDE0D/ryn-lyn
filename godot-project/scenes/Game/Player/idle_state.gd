extends StateMachineState

export(NodePath) onready var player = $"../.."

func _physics_process_state(_delta):
	player.process_movement(_delta)
