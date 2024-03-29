extends Node

signal on_state_changed(new_state, previous_state)
signal on_dialog_start(dialog)
signal on_player_collected_stone()
signal on_player_enter_section(title, objective)

enum STATE {GAME, PAUSED, SUBTITLE}
var _state = [STATE.GAME]

# NAVIGATION

func start_game():
	_state = [STATE.GAME]

func main_menu(load_sync: bool = false):
	SceneLoader.change_scene("res://scenes/UI/menu/MainMenu.tscn", load_sync)

func show_pause():
	if !is_in_state(GameState.STATE.PAUSED):
		GameState.push_state(GameState.STATE.PAUSED)

func hide_pause():
	if is_in_state(GameState.STATE.PAUSED):
		GameState.pop_state()

# DIALOG

func show_dialog(dialog: DialogResource):
	GameState.push_state(GameState.STATE.SUBTITLE)
	emit_signal("on_dialog_start", dialog)

# PLAYER

func player_collected_stone():
	emit_signal("on_player_collected_stone")

func player_enter_section(title, objective):
	emit_signal("on_player_enter_section", title, objective)

# STATES

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
