extends KinematicBody2D
class_name Character2D

export(float) var gravity_force: float = 18.9
export(float) var motion_force: float = 200.0
const jump_force: float = 350.0
const jump_double_force: float = 400.0
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
