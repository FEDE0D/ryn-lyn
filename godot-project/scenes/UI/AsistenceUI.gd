extends Control

const item_pkg_scn = preload("res://scenes/UI/AssistanceUIItem.tscn")
var items = []

func _ready():
	GameState.connect("on_player_enter_section", self, "_on_enter_section")
	GameState.connect("on_state_changed", self, "_on_state_changed")

func _on_enter_section(title, objective_text):
	for i in items:
		i.set_done()
	
	if not objective_text:
		return
	
	var item = item_pkg_scn.instance()
	item.text = objective_text
	items.append(item)
	$"%VBoxContainer".add_child(item)
	
	show_objectives()
	yield(get_tree().create_timer(5.0), "timeout")
	hide_objectives()

func _on_state_changed(new_state, previous_state):
	if new_state == GameState.STATE.PAUSED:
		show_objectives()
	elif previous_state == GameState.STATE.PAUSED:
		hide_objectives()

func show_objectives():
	if GameConfig.config.acc_show_objectives:
		$Tween.interpolate_property(self, "modulate", Color.transparent, Color.white, 1.0, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		$Tween.start()

func hide_objectives():
	if GameConfig.config.acc_show_objectives:
		$Tween.interpolate_property(self, "modulate", Color.white, Color.transparent, 1.0, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		$Tween.start()
