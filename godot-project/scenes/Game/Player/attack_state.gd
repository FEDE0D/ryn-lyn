extends PlayerState

const timeout: float = 0.3
var time: float = timeout

func _on_state_enter(param = null):
	time = timeout
	if $"../..".is_on_floor:
		$"%AnimatedSprite".play("attack")
	else:
		$"%AnimatedSprite".play("attack-air")

func _physics_process_state(delta):
	time -= delta
	if time < 0:
		change_state("idle")
