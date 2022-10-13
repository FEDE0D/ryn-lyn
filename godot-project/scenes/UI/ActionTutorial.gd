extends VBoxContainer

export(String) var action = "jump"
export(String) var top_text = "Presiona"
export(String) var bottom_text = "para saltar"

func _ready():
	if not GameConfig.config.acc_show_controls:
		hide()
	
	$Control/Control/ActionDisplay.action = action
	$TopLabel.text = top_text
	$BottomLabel.text = bottom_text
	
	if not action:
		$Control/Control/ActionDisplay.hide()


func _on_VisibilityNotifier2D_screen_entered():
	if visible and GameConfig.config.acc_show_controls and GameConfig.config.acc_text_to_speech:
		TTS.speak("%s %s %s" % [top_text, action, bottom_text])
