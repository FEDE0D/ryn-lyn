extends Node2D

export(bool) var show_on_start = true
export(Resource) var dialog

onready var active: bool = show_on_start

func _ready():
	set_process_input(false)
	assert(dialog != null)
	if show_on_start:
		$AnimationPlayer.play("show")

func activate():
	if !active:
		active = true
		if GameConfig.config.acc_closed_caption:
			get_tree().call_group("caption", "descriptive", "ROCAS TEMBLANDO")
		$AnimationPlayer.play("show")
		yield($AnimationPlayer, "animation_finished")
		show_dialog()

func _input(event):
	if event.is_action_pressed("subtitle"):
		get_tree().set_input_as_handled()
		show_dialog()

func show_dialog():
	set_process_input(false)
	GameState.show_dialog(dialog)
	$ActionDisplay.hide()

func _on_Area2D_body_entered(body):
	if !active:
		return
	if GameConfig.config.acc_show_controls:
		$ActionDisplay.show()
	set_process_input(true)
	
func _on_Area2D_body_exited(body):
	if !active:
		return
	$ActionDisplay.hide()
	set_process_input(false)

func _on_SoundArea_body_entered(body):
	if active:
		$PsstSound.play()
		get_tree().call_group("caption", "descriptive", "*CHISTIDO*")
		$BlinkAnimation.play("blink")
