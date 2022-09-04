extends Node2D

var pressed: Array = []

func _on_Area2D_body_entered(body):
	if pressed.empty():
		$AnimationPlayer.play("pressed")
	pressed.append(body)

func _on_Area2D_body_exited(body):
	pressed.erase(body)
	if pressed.empty():
		$AnimationPlayer.play_backwards("pressed")
