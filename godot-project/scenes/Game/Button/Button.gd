extends Node2D

export(NodePath) onready var door = get_node(door) as Door
var pressed: Array = []

func _on_Area2D_body_entered(body):
	if pressed.empty():
		$AnimationPlayer.play("pressed")
		door.open()
	pressed.append(body)

func _on_Area2D_body_exited(body):
	pressed.erase(body)
	if pressed.empty():
		$AnimationPlayer.play_backwards("pressed")
		door.close()
