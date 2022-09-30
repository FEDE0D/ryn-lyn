extends Node2D

func _ready():
	GameState.connect("on_player_collected_stone", self, "on_player_collected_stone")

func on_player_collected_stone():
	$tutoriales/Trigger.enabled = true
