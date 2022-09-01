extends PlayerState

func _on_state_enter(param = null):
	$"%AnimatedSprite".play("idle")

func _physics_process_state(_delta):
	$"../..".process_idle()
	$"../..".process_control()
