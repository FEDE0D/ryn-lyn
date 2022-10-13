extends CenterContainer

func _ready():
	GameState.connect("on_player_enter_section", self, "_on_player_enter_section")

func _on_player_enter_section(title, objective_text):
	$Label.text = title
	$AnimationPlayer.play("show")
	$AudioStreamPlayer.play()
	
	if GameConfig.config.acc_closed_caption:
		get_tree().call_group("caption", "descriptive", "SONIDO MISTERIOSO")
