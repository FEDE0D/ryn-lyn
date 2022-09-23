extends PlayerState

func _on_state_enter(param = null):
	$"%AnimatedSprite".play("idle")
