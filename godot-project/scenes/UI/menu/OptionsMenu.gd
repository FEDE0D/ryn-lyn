extends Control

var action_to_change: String

func _ready():
	$"%GraphicBtn".grab_focus()
	
	# TODO setup UI config settings
	# GRAPHICS
	$"%WindowModeCheckBtn".pressed = OS.window_fullscreen
	# CONTROLS
	# AUDIO
	$"%MusicVolSlider".value = db2linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music")))
	$"%SoundFXVolSlider".value = db2linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("SoundFX")))
	# ACCESSIBILITY
	$"%AccShowTutorialChk".pressed = GameConfig.config.acc_show_controls
	$"%AccShowObjectivesChk".pressed = GameConfig.config.acc_show_objectives
	$"%AccHideBackgroundChk".pressed = GameConfig.config.acc_hide_background
	$"%AccWindowScaleSlider".value = GameConfig.config.acc_screen_scale
	$"%AccMonoAudioChk".pressed = GameConfig.config.acc_audio_mono
	$"%AccClosedCaptionChk".pressed = GameConfig.config.acc_closed_caption
	$"%AccTTSChk".pressed = GameConfig.config.acc_text_to_speech

func _on_CancelBtn_pressed():
	GameConfig.load_config()
	GameState.main_menu()

func _on_SaveBtn_pressed():
	GameConfig.save_config()
	GameState.main_menu()

func _on_button_focus(container_name):
	for c in $"%ParentContainer".get_children():
		c.hide()
	$"%ParentContainer".get_node(container_name).show()

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

func _on_MusicVolSlider_value_changed(value):
	GameConfig.config.audio_volume_music = value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear2db(value))

func _on_SoundFXVolSlider_value_changed(value):
	GameConfig.config.audio_volume_sound_effects = value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SoundFX"), linear2db(value))
	$"%SoundFXPlayer".play()

func _on_ui_scale_value_changed(value):
	GameConfig.config.acc_screen_scale = value
	get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_DISABLED, SceneTree.STRETCH_ASPECT_EXPAND, get_viewport_rect().size, value)

func _on_AccShowTutorialChk_toggled(button_pressed):
	GameConfig.config.acc_show_controls = button_pressed

func _on_AccShowObjectivesChk_toggled(button_pressed):
	GameConfig.config.acc_show_objectives = button_pressed

func _on_AccHideBackgroundChk_toggled(button_pressed):
	GameConfig.config.acc_hide_background = button_pressed

func _on_AccMonoAudioChk_toggled(button_pressed):
	GameConfig.config.acc_audio_mono = button_pressed

func _on_AccClosedCaptionChk_toggled(button_pressed):
	GameConfig.config.acc_closed_caption = button_pressed

func _on_AccTTSChk_toggled(button_pressed):
	GameConfig.config.acc_text_to_speech = button_pressed
