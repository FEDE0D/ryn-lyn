extends Node2D

func _on_Trigger_on_player_entered():
	GameState.player_collected_stone()
	queue_free()
