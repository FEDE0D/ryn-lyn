extends PlayerState

const timeout: float = 0.55
var time: float = timeout

func _on_state_enter(damage: float = 0.0):
	time = timeout
	$"%AnimatedSprite".play("damage")

func _physics_process_state(delta):
	time -= delta
	if time < 0:
		change_state("idle")
