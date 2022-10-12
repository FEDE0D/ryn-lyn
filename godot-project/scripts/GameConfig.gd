extends Node2D

var config: ConfigResource

func _ready():
	load_config()

func load_config():
	config = load("user://config.tres")
	if not config:
		config = ConfigResource.new()
		for action in InputMap.get_actions():
			config.control_mapping[action] = InputMap.get_action_list(action)
	
	# LOAD GRAPHICS
	OS.window_fullscreen = config.graphics_fullscreen_mode
	# LOAD CONTROL
	for action in config.control_mapping:
		InputMap.action_erase_events(action)
		for event in config.control_mapping[action]:
			InputMap.action_add_event(action, event)
	# LOAD AUDIO
	print(linear2db(config.audio_volume_music))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear2db(config.audio_volume_music))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SoundFX"), linear2db(config.audio_volume_sound_effects))
	# LOAD ACCESSIBILITY
	get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_DISABLED, SceneTree.STRETCH_ASPECT_EXPAND, get_viewport_rect().size, config.acc_screen_scale)

func save_config():
	# SAVE GRAPHICS
	config.graphics_fullscreen_mode = OS.window_fullscreen
	# SAVE CONTROL
	for action in InputMap.get_actions():
		config.control_mapping[action] = InputMap.get_action_list(action)
	# SAVE AUDIO
	config.audio_volume_music = db2linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music")))
	config.audio_volume_sound_effects = db2linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("SoundFX")))
	# SAVE ACCESSIBILITY
	var result = ResourceSaver.save("user://config.tres", config)
	print("Saving %s" % result)
