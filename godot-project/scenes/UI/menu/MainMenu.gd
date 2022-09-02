extends Control

func _ready():
	$"%PlayButton".grab_focus()

func _on_PlayButton_pressed():
	get_tree().change_scene("res://scenes/Game/World.tscn")

func _on_OptionsButton_pressed():
	get_tree().change_scene("res://scenes/UI/menu/OptionsMenu.tscn")
