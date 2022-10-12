extends Camera2D

export(float) var shake_force: float = 2.0
var shake_time: float = 0.0

func _ready():
	# UI 1.5 -> zoom 0.7
	# UI 2.0 -> zoom 0.94
	self.zoom = ((0.48 * GameConfig.config.acc_screen_scale) - 0.02) * Vector2.ONE
	print(GameConfig.config.acc_screen_scale, zoom)

func _process(delta):
	if shake_time > 0:
		shake_time -= delta
		offset = Vector2(rand_range(-1, 1), rand_range(-1, 1)) * shake_force

func shake(time: float = 1.0):
	shake_time = time
