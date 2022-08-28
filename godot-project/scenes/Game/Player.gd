extends KinematicBody2D

const gravity_force: float = 18.9
const jump_force: float = 350.0
const jump_double_force: float = 400.0
const motion_force: float = 250.0
const friction: float = 0.2
const acceleration: float = 0.15
const acceleration_air: float = 0.1

var velocity: Vector2 = Vector2()
var is_on_floor: bool = false
var can_double_jump: bool = false

func _ready():
	pass

func _physics_process(_delta):
	var move_force = 0
	var on_floor = $FootRayCast.is_colliding()
	if !is_on_floor and on_floor:
		can_double_jump = true
	is_on_floor = on_floor
	
	if Input.is_action_pressed("ui_left"):
		move_force -= motion_force
	if Input.is_action_pressed("ui_right"):
		move_force += motion_force
	if Input.is_action_just_pressed("ui_accept") and is_on_floor:
		velocity.y = -jump_force
	if Input.is_action_just_pressed("ui_accept") and !is_on_floor and can_double_jump:
		velocity.y = -jump_double_force
		can_double_jump = false
	
	if move_force != 0:
		if is_on_floor:
			velocity.x = lerp(velocity.x, move_force, acceleration)
		else:
			velocity.x = lerp(velocity.x, move_force, acceleration_air)
	else:
		velocity.x = lerp(velocity.x, 0, friction)
	velocity.y += gravity_force
	
	velocity = move_and_slide(velocity)
