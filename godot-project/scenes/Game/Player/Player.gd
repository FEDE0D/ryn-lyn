extends Character2D

func process_control():
	move_force = 0
	var on_floor = $FootRayCast.is_colliding()
	if !is_on_floor and on_floor:
		can_double_jump = true
		$"%AnimatedSprite".play("idle")
	is_on_floor = on_floor
	
	if Input.is_action_pressed("left"):
		move_force -= motion_force
		$"%direction".scale.x = -1
	if Input.is_action_pressed("right"):
		move_force += motion_force
		$"%direction".scale.x = 1
	if Input.is_action_just_pressed("jump") and is_on_floor:
		velocity.y = -jump_force
	if Input.is_action_just_pressed("jump") and !is_on_floor and can_double_jump:
		velocity.y = -jump_double_force
		can_double_jump = false
	if Input.is_action_just_pressed("action"):
		$StateMachine.change_state("attack")

func process_idle():
	if is_on_floor:
		if move_force != 0:
			$"%AnimatedSprite".play("walk")
		else:
			$"%AnimatedSprite".play("idle")
	else:
		$"%AnimatedSprite".play("jump")

func _on_StateMachine_on_state_changed(old_state, new_state):
#	print("Change state %s->%s" % [old_state, new_state])
	pass
