extends ParallaxBackground

export(Color) var default_color = Color("8b425454")
export(Color) var disabled_color = Color.black

func _ready():
	$FrontColor.color = disabled_color if GameConfig.config.acc_hide_background else default_color
