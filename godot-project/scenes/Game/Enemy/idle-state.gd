extends EnemyState

func _physics_process_state(delta):
	$"../..".process_motion()

func touch_wall(direction: float):
	$"../..".direction = -direction

func pit(direction: float):
	$"../..".direction = -direction
