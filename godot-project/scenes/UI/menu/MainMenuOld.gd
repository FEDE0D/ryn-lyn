extends Control

func _ready():
	$"%PlayButton".grab_focus()

func _on_PlayButton_pressed():
	GameState.start_game()
	get_tree().change_scene("res://scenes/Game/World1.tscn")

func _on_OptionsButton_pressed():
	get_tree().change_scene("res://scenes/UI/menu/OptionsMenu.tscn")

func _on_SalirButton_pressed():
	get_tree().quit()
