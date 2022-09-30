extends Area2D
class_name MoonStone

const speed: float = 10.0
var active: bool = true

func _process(delta):
	var moon_position = $"../../MoonStoneTargetPosition".global_position
	global_position = global_position.linear_interpolate(moon_position, delta * speed)

func activate():
#	monitorable = true
	active = true
	collision_layer = 8
	$visuals/Light2D.show()

func deactivate():
#	monitorable = false
	active = false
	collision_layer = 0
	$visuals/Light2D.hide()

func invert():
	if !active:
		activate()
	else:
		deactivate()
