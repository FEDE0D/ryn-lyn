extends Node2D

export(NodePath) onready var door = get_node(door) as Door
export(bool) var active: bool = false

var pressed: Array = []

func _ready():
	if active:
		$visuals/AnimatedSprite.play("on")

func _on_Area2D_body_entered(body):
	if not pressed.has(body):
		pressed.append(body)
	$visuals/Button.show()

func _on_Area2D_body_exited(body):
	pressed.erase(body)
	$visuals/Button.hide()

func _input(event):
	if event.is_action_pressed("action") and not pressed.empty():
		if active:
			turn_off()
		else:
			turn_on()

func turn_on():
	active = true
	$visuals/AnimatedSprite.play("on")
	door.activate()

func turn_off():
	active = false
	$visuals/AnimatedSprite.play("off")
	door.deactivate()
