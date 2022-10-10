extends Node

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
	# LOAD ACCESSIBILITY

func save_config():
	# SAVE GRAPHICS
	config.graphics_fullscreen_mode = OS.window_fullscreen
	# SAVE CONTROL
	for action in InputMap.get_actions():
		config.control_mapping[action] = InputMap.get_action_list(action)
	# SAVE AUDIO
	# SAVE ACCESSIBILITY
	var result = ResourceSaver.save("user://config.tres", config)
	print("Saving %s" % result)
