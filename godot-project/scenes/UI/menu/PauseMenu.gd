extends Control

func _ready():
	GameState.connect("on_state_changed", self, "_on_state_changed")

func _input(event):
	if event.is_action_pressed("pause"):
		get_tree().set_input_as_handled()
		if GameState.is_in_state(GameState.STATE.PAUSED):
			GameState.hide_pause()
		else:
			GameState.show_pause()

func _on_state_changed(new_state, previous_state):
	if new_state == GameState.STATE.PAUSED:
		get_tree().paused = true
		$AnimationPlayer.play("show")
	elif previous_state == GameState.STATE.PAUSED:
		get_tree().paused = false
		$AnimationPlayer.play_backwards("show")

func _on_VolverButton_pressed():
	GameState.hide_pause()

func _on_SalirButton_pressed():
	$ConfirmationDialog.popup_centered()

func _on_ConfirmationDialog_confirmed():
	$ConfirmationDialog.hide()
	get_tree().paused = false
	GameState.main_menu(false)

func _on_ConfirmationDialog_hide():
	$HBoxContainer/PanelContainer/Panel/VBoxContainer/SalirButton.grab_focus()

