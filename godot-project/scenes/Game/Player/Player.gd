extends Character2D
class_name Player

onready var _camera: Camera2D = $CameraNormalPosition/Camera2D
onready var _camera_offset: Vector2 = $CameraNormalPosition/Camera2D.offset
var air_time: float = 0.0

const footstep_audio_scn = preload("res://resources/audio/player/Footsteps.tscn")
const jump_audio_scn = preload("res://resources/audio/player/Jump.tscn")

func _ready():
	GameState.connect("on_state_changed", self, "_on_game_state_changed")
	GameState.connect("on_player_collected_stone", self, "_on_player_collected_stone")

func receive_attack():
	$"%StateMachine".state._receive_damage(0.25)
	$HurtPlayer.pitch_scale = rand_range(1.5, 1.55)
	$HurtPlayer.play()
	if has_node("MoonStoneNode/MoonStone"):
			$"MoonStoneNode/MoonStone".deactivate()

func process_control(delta):
	move_force = 0
	var on_floor = $FootRayCast.is_colliding()
	if !is_on_floor and on_floor:
		can_double_jump = true
		$"%AnimatedSprite".play("idle")
		play_audio(footstep_audio_scn)
	is_on_floor = on_floor
	
	if !is_on_floor and velocity.y > 0: # falling
		var collider = $"%EnemyRayCastL".get_collider()
		if !collider:
			collider = $"%EnemyRayCastR".get_collider()
		if collider and collider.is_in_group("enemy"):
			velocity.y = -jump_double_force * 1.3
			can_double_jump = true
			collider.on_player_stomp()
			$"%FeetDust".restart()
			$"%FeetDust".emitting = true
	
	if Input.is_action_pressed("left"):
		move_force -= motion_force * Input.get_action_strength("left")
		$"%direction".scale.x = -1
	if Input.is_action_pressed("right"):
		move_force += motion_force * Input.get_action_strength("right")
		$"%direction".scale.x = 1
	if Input.is_action_just_pressed("jump") and is_on_floor:
		velocity.y = -jump_force
	if Input.is_action_just_pressed("jump") and !is_on_floor and can_double_jump and air_time > 0.0:
		velocity.y = -jump_double_force
		can_double_jump = false
		$"%FeetDust".restart()
		$"%FeetDust".emitting = true
		yield(get_tree().create_timer(0.3), "timeout")
		$"%FeetDust".emitting = false
	if Input.is_action_just_released("jump") and !is_on_floor and velocity.y < 0:
		if can_double_jump:
			velocity.y = -jump_force/3.0
	if Input.is_action_pressed("action"):
		if has_node("MoonStoneNode/MoonStone"):
			get_tree().set_input_as_handled()
			$"MoonStoneNode/MoonStone".activate()
	else:
		if has_node("MoonStoneNode/MoonStone"):
			$"MoonStoneNode/MoonStone".deactivate()
	
	var cam_offset = Vector2()
	if Input.is_action_pressed("camera_left"):
		cam_offset.x = -Input.get_action_strength("camera_left")
	elif Input.is_action_pressed("camera_right"):
		cam_offset.x = Input.get_action_strength("camera_right")
	if Input.is_action_pressed("camera_up"):
		cam_offset.y = -Input.get_action_strength("camera_up")
	elif Input.is_action_pressed("camera_down"):
		cam_offset.y = Input.get_action_strength("camera_down")
	$CameraNormalPosition/Camera2D.offset_h = cam_offset.x
	$CameraNormalPosition/Camera2D.offset_v = cam_offset.y
	
	if !is_on_floor:
		air_time += delta
	else:
		air_time = 0.0
	
func process_idle(delta):
	if is_on_floor:
		if abs(velocity.x) > 5.0:
			$"%AnimatedSprite".play("walk")
		else:
			$"%AnimatedSprite".play("idle")
	else:
		if velocity.y < 0 and $"%AnimatedSprite".animation in ["walk", "idle", "falling"]:
			$"%AnimatedSprite".play("jump-start")
			play_audio(jump_audio_scn, 1.2, 1.5)
		if velocity.y > 0 and $"%AnimatedSprite".animation in ["jump-start", "jump-loop"]:
			$"%AnimatedSprite".animation = "falling"

func _on_StateMachine_on_state_changed(old_state, new_state):
#	print("Change state %s->%s" % [old_state, new_state])
	pass

func _on_AnimatedSprite_animation_finished():
	if $"%AnimatedSprite".animation == "jump-start":
		$"%AnimatedSprite".animation = "jump-loop"

func _on_game_state_changed(new_state, previous_state):
	if new_state == GameState.STATE.GAME:
		$"%StateMachine".change_state("idle")
	else:
		$"%StateMachine".change_state("paused")

func player_pause():
	$"%StateMachine".change_state("paused")

func _on_player_collected_stone():
	var node = preload("res://scenes/Game/Player/MoonStone.tscn").instance()
	node.global_position = $MoonStoneTargetPosition.global_position
	$MoonStoneNode.add_child(node)

func _on_AnimatedSprite_frame_changed():
	if is_on_floor and $"%AnimatedSprite".animation == "walk" and $"%AnimatedSprite".frame in [0, 5, 9]:
		play_audio(footstep_audio_scn)

func play_audio(scn, pitch_start = 1, pitch_end = 1.05):
	var node = scn.instance()
	node.pitch_scale = rand_range(pitch_start, pitch_end)
	add_child(node)
