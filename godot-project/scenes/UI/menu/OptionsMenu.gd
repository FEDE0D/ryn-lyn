extends Control

var action_to_change: String

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

func _on_assign_button_pressed(action):
	action_to_change = action
	$"%LabelTouch".show()
	$"%AnimationPlayer".play("flash")

func _input(event:InputEvent):
	if !$"%LabelTouch".visible: return
	if event is InputEventMouse: return
	var is_button:bool = event is InputEventJoypadButton
	var is_motion:bool = event is InputEventJoypadMotion
	if is_button && !event.pressed: return
	if is_motion && abs(event.axis_value) < InputMap.action_get_deadzone(action_to_change): return false
	var existing_mappings := InputMap.get_action_list(action_to_change)
	for mapping in existing_mappings:
		var is_mapping_button_or_joy:bool = mapping is InputEventJoypadMotion || mapping is InputEventJoypadButton
		if is_motion && is_mapping_button_or_joy:
			InputMap.action_erase_event(action_to_change, mapping)
			event.axis_value = 1 if event.axis_value > 0 else -1
			InputMap.action_add_event(action_to_change, event)
			break
		elif is_button && is_mapping_button_or_joy:
			InputMap.action_erase_event(action_to_change, mapping)
			InputMap.action_add_event(action_to_change, event)
			break
		elif !is_button && !is_motion && mapping is InputEventKey:
			InputMap.action_erase_event(action_to_change, mapping)
			InputMap.action_add_event(action_to_change, event)
			break
	get_tree().set_input_as_handled()
	$"%LabelTouch".hide()
	$"%AnimationPlayer".stop(true)
	get_tree().call_group("action_%s" % action_to_change, "set_action", action_to_change)

func _on_WindowModeCheckBtn_toggled(button_pressed):
	OS.window_fullscreen = button_pressed
