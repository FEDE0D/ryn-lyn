extends Control

func _ready():
	$"%PlayBtn".grab_focus()

func _on_PlayBtn_pressed():
	GameState.start_game()
	SceneLoader.change_scene("res://scenes/Game/World1.tscn")

func _on_OptionsBtn_pressed():
	SceneLoader.change_scene("res://scenes/UI/menu/OptionsMenu.tscn")

func _on_QuitBtn_pressed():
	get_tree().quit()
