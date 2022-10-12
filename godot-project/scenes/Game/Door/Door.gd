extends Node2D
class_name Door

export(bool) var active: bool = true

func _ready():
	if not active:
		deactivate(true, true)

func activate(ignore_state: bool = false):
	if active and not ignore_state:
		return
	active = true
	$StaticBody2D/CollisionShape2D.set_deferred("disabled", false)
	$AnimationPlayer.play_backwards("open")
	$AudioStreamPlayer.play()
	get_tree().call_group("camera", "shake", 1.2)

func deactivate(ignore_state: bool = false, silent: bool = false):
	if not active and not ignore_state:
		return
	active = false
	$StaticBody2D/CollisionShape2D.set_deferred("disabled", true)
	$AnimationPlayer.play("open")
	if not silent:
		$AudioStreamPlayer.play()
		get_tree().call_group("camera", "shake", 1.2)

func invert():
	if active:
		deactivate()
	else:
		activate()
