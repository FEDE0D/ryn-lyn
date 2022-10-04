extends CenterContainer

func _ready():
	GameState.connect("on_player_enter_section", self, "_on_player_enter_section")

func _on_player_enter_section(title):
	$Label.text = title
	$AnimationPlayer.play("show")
