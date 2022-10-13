extends EnemyState

const timeout: float = 0.5
var time: float = timeout

const snore_timeout: float = 5.0
var snore_time: float = snore_timeout

func _on_state_enter(param = null):
	$"%AnimatedSprite".play("idle")
	if not $"%SnorePlayer".playing:
		$"%SnorePlayer".play()
	time = timeout
	snore_time = snore_timeout

func _on_state_exit(param = null):
	$"%SnorePlayer".stop()

func _physics_process_state(delta):
	if $"%PlayerDetector".get_overlapping_areas():
		time -= delta
	else:
		time = timeout
	if time < 0:
		change_state("alerted")
	
	snore_time -= delta
	if snore_time < 0:
		snore_time = snore_timeout
		if $"%SoundArea".get_overlapping_bodies() and GameConfig.config.acc_closed_caption:
			get_tree().call_group("caption", "descriptive", "RONQUIDOS DE TRÁUCO")
