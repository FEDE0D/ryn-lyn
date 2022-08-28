extends Control

func _on_Button2_pressed():
	TTS.speak($VBoxContainer/TextEdit.text)
