extends Node2D

export(String, MULTILINE) var section_title
export(String, MULTILINE) var objective_text

var active: bool = false

func _ready():
	assert(section_title)

func _on_Area2D_body_entered(body):
	if not active:
		active = true
		GameState.player_enter_section(section_title, objective_text)
