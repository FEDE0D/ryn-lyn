extends EnemyState

const timeout: float = 3.0
const attack_distance: float = 30.0
const attack_timeout: float = 0.8
var time: float = timeout
var attack_time = attack_timeout

func _on_state_enter(param = null):
	$"%AnimatedSprite".play("walk")
	time = timeout
	attack_time = attack_timeout

func player_detected(player):
	time = timeout

func _physics_process_state(delta):
	$"../..".look_at_player()
	
	if !close_to_player():
		$"%AnimatedSprite".play("walk")
		$"../..".process_motion()
	else:
		$"%AnimatedSprite".play("idle")
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
		if $"%PlayerDetector".get_overlapping_bodies().empty():
			change_state("idle")
		else:
			time = timeout

func close_to_player():
	return $"../..".global_position.distance_to($"../..".player.global_position) <= attack_distance
