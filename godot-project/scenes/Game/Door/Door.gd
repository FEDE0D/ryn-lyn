extends Node2D
class_name Door

func open():
	$StaticBody2D/CollisionShape2D.set_deferred("disabled", true)
	$AnimationPlayer.play("open")

func close():
	$StaticBody2D/CollisionShape2D.set_deferred("disabled", false)
	$AnimationPlayer.play_backwards("open")
