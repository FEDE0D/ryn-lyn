extends Character2D

var direction: float = 1.0 setget set_direction

func set_direction(d):
	direction = d
	$visual/direction.scale.x = self.direction


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
