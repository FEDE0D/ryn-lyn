extends Node2D

export(Array, NodePath) var doors
export(bool) var active: bool = false
export(float) var timer: float = 1.0

var collisions: Array = []
onready var time: float = timer

func _ready():
	if active:
		$visuals/AnimatedSprite.play("on")
		$FireSound.play()

func _on_Area2D_body_entered(body):
	if not collisions.has(body):
		collisions.append(body)
		$ActionDisplay.show()

func _on_Area2D_body_exited(body):
	collisions.erase(body)
	$ActionDisplay.hide()

func _process(delta):
	if Input.is_action_pressed("action"):
		get_tree().set_input_as_handled()
		if not collisions.empty():
			$visuals/ProgressBar.show()
			time -= delta
			$visuals/ProgressBar.value = (1 - (time / timer))
	else:
		time = timer
		$visuals/ProgressBar.hide()
	
	if time <= 0:
		Input.action_release("action")
		$AudioStreamPlayer.play()
		if active:
			turn_off()
		else:
			turn_on()

func turn_on():
	active = true
	$visuals/AnimatedSprite.play("on")
	$FireSound.play()
	for door in doors:
		get_node(door).invert()

func turn_off():
	active = false
	$visuals/AnimatedSprite.play("off")
	$FireSound.stop()
	for door in doors:
		get_node(door).invert()

func _on_SoundArea_body_entered(body):
	get_tree().call_group("caption", "descriptive", "SONIDO DE FUEGO")
