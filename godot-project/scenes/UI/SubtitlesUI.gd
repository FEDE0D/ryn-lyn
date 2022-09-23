extends Control

signal subtitle_action

var current_line_index: int = 0

func _ready():
	GameState.connect("on_dialog_start", self, "_on_dialog_start")

func _input(event):
	if event.is_action_pressed("subtitle"):
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
		
		$"%Tween".interpolate_property($"%Subtitles", "percent_visible", 0.0, 1.0, duration)
		$"%Tween".start()
		yield(self, "subtitle_action")
	$"%Subtitles".clear()
	$"%SubtitlesContainer".hide()
	current_line_index = 0
	GameState.pop_state()
