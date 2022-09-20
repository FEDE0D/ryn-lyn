extends Node2D

export(NodePath) onready var door = get_node(door) as Door
export(String, "TOGGLE", "KEEP") var button_type = "TOGGLE"
var pressed: Array = []

func _on_Area2D_body_entered(body):
	if pressed.empty():
		$AnimationPlayer.play("pressed")
		door.open()
	pressed.append(body)

func _on_Area2D_body_exited(body):
	if button_type == "TOGGLE":
		pressed.erase(body)
		if pressed.empty():
			$AnimationPlayer.play_backwards("pressed")
			door.close()
