extends Node2D

const speed: float = 10.0

func _process(delta):
	var moon_position = $"%MoonStoneTargetPosition".global_position
	global_position = global_position.linear_interpolate(moon_position, delta * speed)
