extends VBoxContainer

export(String) var action = "jump"
export(String) var top_text = "Presiona"
export(String) var bottom_text = "para saltar"

func _ready():
	$Control/Control/ActionDisplay.action = action
	$TopLabel.text = top_text
	$BottomLabel.text = bottom_text
	
	if not action:
		$Control/Control/ActionDisplay.hide()
