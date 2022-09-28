extends Node2D
class_name Door

export(bool) var active: bool = true

func _ready():
	if not active:
		deactivate(true)

func activate(ignore_state: bool = false):
	if active and not ignore_state:
		return
	active = true
	$StaticBody2D/CollisionShape2D.set_deferred("disabled", false)
	$AnimationPlayer.play_backwards("open")

func deactivate(ignore_state: bool = false):
	if not active and not ignore_state:
		return
	active = false
	$StaticBody2D/CollisionShape2D.set_deferred("disabled", true)
	$AnimationPlayer.play("open")
