extends Control

func _ready():
	$"%GraphicBtn".grab_focus()

func _on_CancelBtn_pressed():
	get_tree().change_scene("res://scenes/UI/menu/MainMenu.tscn")

func _on_button_focus(container_name):
	for c in $"%ParentContainer".get_children():
		c.hide()
	$"%ParentContainer".get_node(container_name).show()

func _on_ui_scale_value_changed(value):
	print(value)
	get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_DISABLED, SceneTree.STRETCH_ASPECT_EXPAND, get_viewport_rect().size, value)
