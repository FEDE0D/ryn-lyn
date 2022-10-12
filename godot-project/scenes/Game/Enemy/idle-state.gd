extends EnemyState

const timeout: float = 0.5
var time: float = timeout

func _on_state_enter(param = null):
	$"%AnimatedSprite".play("idle")
	if not $"%SnorePlayer".playing:
		$"%SnorePlayer".play()
	time = timeout

func _on_state_exit(param = null):
	$"%SnorePlayer".stop()

func _physics_process_state(delta):
	if $"%PlayerDetector".get_overlapping_areas():
		time -= delta
	else:
		time = timeout
	if time < 0:
		change_state("alerted")
