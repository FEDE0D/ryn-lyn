extends Control

signal subtitle_action

var current_line_index: int = 0

func _ready():
	GameState.connect("on_dialog_start", self, "_on_dialog_start")
	$"%SubtitlesContainer".hide()

func _input(event):
	if event.is_action_pressed("subtitle"):
		get_tree().set_input_as_handled()
		emit_signal("subtitle_action")

func _on_dialog_start(dialog: DialogResource):
	$"%Subtitles".clear()
	$"%SubtitlesContainer".show()
	while current_line_index < dialog.lines.size():
		var dialog_line: DialogLineResource = dialog.lines[current_line_index]
		var line = dialog_line.text
		var actor: ActorResource = dialog_line.actor
		var duration = line.length() * 0.03
		
		current_line_index += 1
		$"%Subtitles".percent_visible = 0.0
		$"%Subtitles".bbcode_text = "[b]%s[/b]:\n%s" % [actor.name, line]
		$"%ActorImage".texture = actor.image
		
		if GameConfig.config.acc_text_to_speech:
			TTS.speak("%s dice. %s" % [actor.name, line.replace("[b]", "").replace("[/b]", "")], true)
		
		$"%Tween".interpolate_property($"%Subtitles", "percent_visible", 0.0, 1.0, duration)
		$"%Tween".start()
		yield(self, "subtitle_action")
	$"%Subtitles".clear()
	$"%SubtitlesContainer".hide()
	TTS.stop()
	current_line_index = 0
	GameState.pop_state()
