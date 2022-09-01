extends EnemyState

func _on_state_enter(param = null):
	$"%AnimatedSprite".play("idle")

func player_detected(player):
	change_state("alerted")
