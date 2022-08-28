extends KinematicBody2D

const gravity_force: float = 18.9
const jump_force: float = 350.0
const jump_double_force: float = 400.0
const motion_force: float = 200.0
const friction: float = 0.2
const acceleration: float = 0.2
const acceleration_air: float = 0.1

var velocity: Vector2 = Vector2()
var is_on_floor: bool = false
var can_double_jump: bool = false
var move_force = 0

func _physics_process(delta):
	if move_force != 0:
		if is_on_floor:
			velocity.x = lerp(velocity.x, move_force, acceleration)
		else:
			velocity.x = lerp(velocity.x, move_force, acceleration_air)
	else:
		velocity.x = lerp(velocity.x, 0, friction)
	velocity.y += gravity_force
	
	velocity = move_and_slide(velocity)
	move_force = 0

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
	print("Change state %s->%s" % [old_state, new_state])
