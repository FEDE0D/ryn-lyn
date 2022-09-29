extends PlayerState

func _on_state_enter(param = null):
	$"%AnimatedSprite".play("idle")

func _physics_process_state(delta):
	$"../..".process_idle(delta)
	$"../..".process_control(delta)
