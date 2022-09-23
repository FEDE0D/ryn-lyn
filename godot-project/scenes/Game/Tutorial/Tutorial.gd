extends Node2D

export(Resource) var dialog

func _ready():
	set_process_input(false)
	assert(dialog != null)

func _input(event):
	if event.is_action_pressed("subtitle"):
		set_process_input(false)
		GameState.show_dialog(dialog)
		$"%Button".hide()

func _on_Area2D_body_entered(body):
	$"%Button".show()
	set_process_input(true)
	
func _on_Area2D_body_exited(body):
	$"%Button".hide()
	set_process_input(false)
