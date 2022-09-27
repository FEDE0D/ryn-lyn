extends Node

signal on_state_changed(new_state, previous_state)
signal on_dialog_start(dialog)

enum STATE {GAME, PAUSED, SUBTITLE}
var _state = [STATE.GAME]

func start_game():
	_state = [STATE.GAME]

func show_dialog(dialog: DialogResource):
	GameState.push_state(GameState.STATE.SUBTITLE)
	emit_signal("on_dialog_start", dialog)

func show_pause():
	if !is_in_state(GameState.STATE.PAUSED):
		GameState.push_state(GameState.STATE.PAUSED)

func main_menu():
	get_tree().change_scene("res://scenes/UI/menu/MainMenu.tscn")

func hide_pause():
	if is_in_state(GameState.STATE.PAUSED):
		GameState.pop_state()

func push_state(s):
	var previous = _state.front()
	_state.push_front(s)
#	print("push %s" % GameState.STATE.keys()[s])
	emit_signal("on_state_changed", _state.front(), previous)

func pop_state():
	var previous = _state.pop_front()
#	print("pop %s" % GameState.STATE.keys()[previous])
	emit_signal("on_state_changed", _state.front(), previous)

func is_in_state(state):
	return _state.front() == state
