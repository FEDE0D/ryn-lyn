extends Control

func _ready():
	$"%Label3".text = "v%s Federico Pacheco 2022" % ProjectSettings.get_setting("global/version")
	$"%PlayBtn".grab_focus()

func _on_PlayBtn_pressed():
	$"%BackgroundMusic".stop()
	GameState.start_game()
	SceneLoader.change_scene("res://scenes/Game/World1.tscn")

func _on_OptionsBtn_pressed():
	$"%BackgroundMusic".stop()
	SceneLoader.change_scene("res://scenes/UI/menu/OptionsMenu.tscn", true)

func _on_QuitBtn_pressed():
	get_tree().quit()
