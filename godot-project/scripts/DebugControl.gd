extends Node

func _process(delta):
	if Input.is_action_just_pressed("debug_fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen
	if Input.is_action_just_pressed("debug_reload"):
		get_tree().change_scene("res://scenes/UI/menu/MainMenu.tscn")
