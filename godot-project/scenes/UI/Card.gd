extends Control

const time: float = 3.0
onready var timer: float = time

func _ready():
	get_tree().paused = true
	
	if GameConfig.config.acc_text_to_speech:
		var text = "%s. %s" % [$"%Label".text, $"%RichTextLabel".text]
		TTS.speak(text)

func _process(delta):
	timer -= delta
	if timer <= 0:
		$ButtonCtrl.show()

func _input(event):
	if $ButtonCtrl.visible and event.is_action_pressed("action"):
			TTS.stop()
			get_tree().paused = false
			queue_free()
