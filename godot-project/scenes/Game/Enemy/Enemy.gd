extends Character2D
class_name Enemy

var direction: float = 1.0 setget set_direction
var player: Player

func set_direction(d):
	direction = d
	$visual/direction.scale.x = self.direction

func look_at_player():
	self.direction = sign(player.global_position.x - global_position.x)

func process_motion():
	move_force += direction * motion_force
	if $RayCastWallRight.is_colliding():
		$StateMachine.state.touch_wall(1)
	elif $RayCastWallLeft.is_colliding():
		$StateMachine.state.touch_wall(-1)
	if !$RayCastPitRight.is_colliding():
		$StateMachine.state.pit(1)
	elif !$RayCastPitLeft.is_colliding():
		$StateMachine.state.pit(-1)

func _on_PlayerDetector_body_entered(body):
	player = body
	$StateMachine.state.player_detected(player)


func _on_AnimatedSprite_animation_finished():
	if $"%AnimatedSprite".animation == "attack":
		$"%AnimatedSprite".play("idle")

func _on_AnimatedSprite_frame_changed():
	if $"%AnimatedSprite".animation == "attack":
		if $"%AnimatedSprite".frame > 2 and $"%AnimatedSprite".frame < 7:
			$"%StateMachine".state.on_attack_animation()
