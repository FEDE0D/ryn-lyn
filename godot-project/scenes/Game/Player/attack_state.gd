extends PlayerState

const timeout: float = 0.3
var time: float = timeout

func _on_state_enter():
	time = timeout
	$"%AnimatedSprite".play("attack")

func _physics_process_state(delta):
	time -= delta
	if time < 0:
		change_state("idle")
