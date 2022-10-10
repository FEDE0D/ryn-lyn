extends Node2D

func _ready():
	GameState.connect("on_player_collected_stone", self, "on_player_collected_stone")

func on_player_collected_stone():
	$tutoriales/CollectStoneTrigger.enabled = true
	$doors/Door11.deactivate()
	$doors/Door12.deactivate()
	
	var card = preload("res://scenes/UI/Card.tscn").instance()
	$InGameUI.add_child(card)

func _on_CollectStoneTrigger_on_player_entered():
	$tutoriales/CollectStoneTrigger.enabled = false
	$"%Player".player_pause()

func _on_EndTrigger_on_player_entered():
	GameState.main_menu()
