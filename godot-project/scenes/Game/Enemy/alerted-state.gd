extends EnemyState

const timeout: float = 5.0
const attack_distance: float = 30.0
const attack_timeout: float = 0.5
var time: float = timeout
var attack_time = attack_timeout

func _on_state_enter(param = null):
	if !close_to_player():
		$"%AnimatedSprite".play("walk")
		$"%WakePlayer".play()
	time = timeout
	attack_time = attack_timeout

func player_detected(player):
	time = timeout

func on_player_stomp():
	change_state("idle")

func _physics_process_state(delta):
	$"../..".look_at_player()
	
	if !close_to_player():
		$"%AnimatedSprite".play("walk")
		$"../..".process_motion()
	else:
#		$"%AnimatedSprite".play("idle")
		pass
	check_attack(delta)
	check_idle(delta)
	

func check_attack(delta):
	if close_to_player():
		attack_time -= delta
		if attack_time < 0:
			change_state("attack")

func check_idle(delta):
	time -= delta
	if time < 0:
		if $"%PlayerDetector".get_overlapping_areas().empty():
			change_state("idle")
		else:
			time = timeout

func close_to_player():
	return $"../..".global_position.distance_to($"../..".player.global_position) <= attack_distance
