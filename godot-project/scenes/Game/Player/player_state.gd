extends StateMachineState
class_name PlayerState

# Player interaction interface
# Every player state can respond differently to each interaction
# TODO complete with other actions

func _receive_damage(damage):
	change_state("damage", damage)

func _pickup_key():
	pass

func _open_door():
	pass
