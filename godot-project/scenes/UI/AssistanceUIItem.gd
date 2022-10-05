extends HFlowContainer

export(String, MULTILINE) var text = ""

func _ready():
	$RichTextLabel.bbcode_text = text

func set_done():
	$RichTextLabel.bbcode_text ="[s]%s[s]" % text
