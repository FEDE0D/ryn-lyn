extends HFlowContainer

export(String, MULTILINE) var text = ""

func _ready():
	$RichTextLabel.bbcode_text = text
	if GameConfig.config.acc_text_to_speech:
		TTS.speak("Nuevo objectivo: %s" % text)

func set_done():
	$RichTextLabel.bbcode_text ="[s]%s[s]" % text
