extends Node

signal on_state_changed(new_state)
signal on_dialog_start(dialog)

enum STATE {GAME, PAUSED, SUBTITLE}
var _state = [STATE.GAME]

func show_dialog(dialog: DialogResource):
	GameState.push_state(GameState.STATE.SUBTITLE)
	emit_signal("on_dialog_start", dialog)

func push_state(s):
	_state.push_front(s)
	emit_signal("on_state_changed", _state.front())

func pop_state():
	_state.pop_front()
	emit_signal("on_state_changed", _state.front())

func is_in_state(state):
	return _state.front() == state
