extends Node2D

export(Array, NodePath) var doors
export(String, "ACTIVATE", "DEACTIVATE", "INVERT") var mode = "INVERT"

func _on_Area2D_body_entered(body):
	for door in doors:
		if mode == "INVERT":
			get_node(door).invert()
		elif mode == "ACTIVATE":
			get_node(door).activate()
		elif mode == "DEACTIVATE":
			get_node(door).deactivate()
