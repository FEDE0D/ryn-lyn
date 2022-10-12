extends EnemyState

const timeout: float = 1.0
var time: float = timeout
var attacked: bool = false

func _on_state_enter(param = null):
	$"%AnimatedSprite".play("attack")
	time = timeout
	attacked = false

func _physics_process_state(delta):
	time -= delta
	if time < 0:
		change_state("alerted")

func on_attack_animation():
	if !attacked and $"%AttackDetector".get_overlapping_bodies().has($"../..".player):
		$"%WakePlayer".play()
		attacked = true
		$"../..".player.receive_attack()
