extends Node

var node

var position_in_children = 0

var column_in_row = 0

func get_siblings():
	var parent = node.get_parent()
	if parent:
		return parent.get_children()
	return null

func click(item := node, button_index = BUTTON_LEFT):
	var click = InputEventMouseButton.new()
	click.button_index = button_index
	click.pressed = true
	if item is Node:
		click.position = item.rect_global_position
	else:
		click.position = node.get_tree().root.get_mouse_position()
	node.get_tree().input_event(click)
	click.pressed = false
	node.get_tree().input_event(click)

func guess_label():
	var tokens = PoolStringArray([])
	var to_check = node
	while to_check:
		if to_check.is_class("AcceptDialog"):
			return
		if to_check.is_class("EditorProperty") and to_check.label:
			tokens.append(to_check.label)
		if (to_check.is_class("EditorProperty") or to_check.is_class("EditorInspectorCategory")) and to_check.get_tooltip_text():
			tokens.append(to_check.get_tooltip_text())
		var label = tokens.join(": ")
		if label:
			return label
		for child in to_check.get_children():
			if child is Label:
				return child
		to_check = to_check.get_parent()

func _accept_dialog_speak():
	if node.dialog_text != "":
		TTS.speak("dialog: %s" % node.dialog_text)

func accept_dialog_focused():
	_accept_dialog_speak()
	if node.get_parent() and node.get_parent().is_class("ProjectSettingsEditor"):
		yield(node.get_tree().create_timer(5), "timeout")
		node.get_ok().emit_signal("pressed")

func _accept_dialog_about_to_show():
	_accept_dialog_speak()

func checkbox_focused():
	var tokens = PoolStringArray([])
	if node.pressed:
		tokens.append("checked")
	else:
		tokens.append("unchecked")
	tokens.append(" checkbox")
	TTS.speak(tokens.join(" "), false)

func checkbox_toggled(checked):
	if node.has_focus():
		if checked:
			TTS.speak("checked", true)
		else:
			TTS.speak("unchecked", true)

var spoke_hint_tooltip

func button_focused():
	var tokens = PoolStringArray([])
	if node.text:
		tokens.append(node.text)
	elif node.hint_tooltip:
		spoke_hint_tooltip = true
		tokens.append(node.hint_tooltip)
	tokens.append("button")
	if node.disabled:
		tokens.append("disabled")
	TTS.speak(tokens.join(": "), false)

func texturebutton_focused():
	var texture = node.texture_normal
	var rid = texture.get_rid()
	TTS.speak("button", false)

func item_list_item_focused(idx):
	var tokens = PoolStringArray([])
	var text = node.get_item_text(idx)
	if text:
		tokens.append(text)
	text = node.get_item_tooltip(idx)
	if text:
		tokens.append(text)
	tokens.append("%s of %s" % [idx + 1, node.get_item_count()])
	TTS.speak(tokens.join(": "))

func item_list_focused():
	var count = node.get_item_count()
	var selected = node.get_selected_items()
	if len(selected) == 0:
		if node.get_item_count() == 0:
			return TTS.speak("list, 0 items", false)
		selected = 0
		node.select(selected)
		node.emit_signal("item_list_item_selected", selected)
	else:
		selected = selected[0]
	position_in_children = selected
	item_list_item_focused(selected)

func item_list_item_selected(index):
	item_list_item_focused(index)

func item_list_multi_selected(index, selected):
	TTS.speak("Multiselect", false)

func item_list_nothing_selected():
	TTS.speak("Nothing selected", true)

func item_list_input(event):
	if event.is_action_pressed("ui_right") or event.is_action_pressed("ui_left"):
		return node.accept_event()
	var old_count = node.get_item_count()
	var old_pos = position_in_children
	if event.is_action_pressed("ui_up"):
		node.accept_event()
		if position_in_children == 0:
			return
		position_in_children -= 1
	elif event.is_action_pressed("ui_down"):
		node.accept_event()
		if position_in_children >= node.get_item_count()-1:
			return
		position_in_children += 1
	elif event.is_action_pressed("ui_home"):
		node.accept_event()
		position_in_children = 0
	elif event.is_action_pressed("ui_end"):
		node.accept_event()
		position_in_children = node.get_item_count()-1
	if old_pos != position_in_children:
		if position_in_children >= node.get_item_count():
			position_in_children = 0
		node.unselect_all()
		node.select(position_in_children)
		node.emit_signal("item_list_item_selected", position_in_children)
		item_list_item_focused(position_in_children)

func label_focused():
	var text = node.text
	if text == "":
		text = "blank"
	TTS.speak(text, false)

func line_edit_focused():
	var text = "blank"
	if node.secret:
		text = "password"
	elif node.text != "":
		text = node.text
	elif node.placeholder_text != "":
		text = node.placeholder_text
	var type = "editable text"
	if not node.editable:
		type = "text"
	TTS.speak("%s: %s" % [text, type], false)

var old_text = ""

var old_pos

func line_edit_text_changed(text):
	if text == null or old_text == null:
		return
	if len(text) > len(old_text):
		for i in range(len(text)):
			if text.substr(i, 1) != old_text.substr(i, 1):
				TTS.speak(text.substr(i, 1))
				return
	else:
		for i in range(len(old_text)):
			if old_text.substr(i, 1) != text.substr(i, 1):
				TTS.speak(old_text.substr(i, 1))
				return

func line_edit_input(event):
	var pos = node.caret_position
	if old_pos != null and old_pos != pos:
		var text = node.text
		if old_text == text:
			if pos > len(text)-1:
				TTS.speak("blank", true)
			else:
				TTS.speak(text[pos], true)
		old_pos = pos
	elif old_pos == null:
		old_pos = pos
	old_text = node.text

func menu_button_focused():
	var tokens = PoolStringArray([])
	if node.text:
		tokens.append(node.text)
	if node.hint_tooltip:
		tokens.append(node.hint_tooltip)
		spoke_hint_tooltip = true
	tokens.append("menu")
	TTS.speak(tokens.join(": "), false)

func popup_menu_focused():
	TTS.speak("menu", false)

func popup_menu_item_id_focused(index):
	var tokens = PoolStringArray([])
	var shortcut = node.get_item_shortcut(index)
	var name
	if shortcut:
		name = shortcut.resource_name
		if name:
			tokens.append(name)
		var text = shortcut.get_as_text()
		if text != "None":
			tokens.append(text)
	var item = node.get_item_text(index)
	if item and item != name:
		tokens.append(item)
	var submenu = node.get_item_submenu(index)
	if submenu:
		tokens.append(submenu)
		tokens.append("menu")
	if node.is_item_checkable(index):
		if node.is_item_checked(index):
			tokens.append("checked")
		else:
			tokens.append("unchecked")
	var tooltip = node.get_item_tooltip(index)
	if tooltip:
		tokens.append(tooltip)
	var disabled = node.is_item_disabled(index)
	if disabled:
		tokens.append("disabled")
	tokens.append(str(index + 1) + " of " + str(node.get_item_count()))
	TTS.speak(tokens.join(": "), true)

func popup_menu_item_id_pressed(index):
	if node.is_item_checkable(index):
		if node.is_item_checked(index):
			TTS.speak("checked", true)
		else:
			TTS.speak("unchecked", true)

func range_focused():
	var tokens = PoolStringArray([])
	tokens.append(str(node.value))
	if node is HSlider:
		tokens.append("horizontal slider")
	elif node is VSlider:
		tokens.append("vertical slider")
	elif node is SpinBox:
		tokens.append("spin box")
	else:
		tokens.append("range")
	tokens.append("minimum %s" % node.min_value)
	tokens.append("maximum %s" % node.max_value)
	TTS.speak(tokens.join(": "), false)

func range_value_changed(value):
	if node.has_focus():
		TTS.speak("%s" % value, true)

func text_edit_focus():
	var tokens = PoolStringArray([])
	if node.text:
		tokens.append(node.text)
	else:
		tokens.append("blank")
	if node.readonly:
		tokens.append("read-only edit text")
	else:
		tokens.append("edit text")
	TTS.speak(tokens.join(": "), false)

func text_edit_input(event):
	pass

func tree_item_render():
	var focused_tree_item = node.get_selected()
	var tokens = PoolStringArray([])
	for i in range(node.columns):
		tokens.append(focused_tree_item.get_text(i))
	if focused_tree_item.get_children():
		if focused_tree_item.collapsed:
			tokens.append("collapsed")
		else:
			tokens.append("expanded")
	tokens.append("tree item")
	if focused_tree_item.is_selected(0):
		tokens.append("selected")
	TTS.speak(tokens.join(": "), true)

func tree_item_deselect_all(item: TreeItem):
	for i in range(node.columns):
		item.deselect(i)

func tree_deselect_all_but(target: TreeItem, tree: Tree):
	var cur = tree.get_root()
	while cur != null:
		if cur != target:
			tree_item_deselect_all(cur)
		cur = tree.get_next_selected(cur)

var prev_selected_cell

var button_index

func tree_item_selected():
	button_index = null
	var cell = node.get_selected()
	if cell != prev_selected_cell:
		if node.select_mode == Tree.SELECT_MULTI:
			cell.select(0)
			tree_deselect_all_but(cell, node)
		if node.has_focus():
			tree_item_render()
		prev_selected_cell = cell
	else:
		var tokens = PoolStringArray([])
		for i in range(node.columns):
			if cell.is_selected(i):
				var title = node.get_column_title(i)
				if title:
					tokens.append(title)
				var column_text = cell.get_text(i)
				if column_text:
					tokens.append(column_text)
				var button_count = cell.get_button_count(i)
				if button_count != 0:
					button_index = 0
					tokens.append(str(button_count) + " " + TTS.singular_or_plural(button_count, "button", "buttons"))
					if cell.has_method("get_button_tooltip"):
						var button_tooltip = cell.get_button_tooltip(i, button_index)
						if button_tooltip:
							tokens.append(button_tooltip)
							tokens.append("button")
						if button_count > 1:
							tokens.append("Use Home and End to switch focus.")
		TTS.speak(tokens.join(": "), true)

func tree_item_multi_selected(item, column, selected):
	if selected:
		TTS.speak("selected", true)
	else:
		TTS.speak("unselected", true)

func tree_input(event):
	var item = node.get_selected()
	var column
	if item:
		for i in range(node.columns):
			if item.is_selected(i):
				column = i
				break
	if item and event is InputEventKey and event.pressed and not event.echo:
		var area
		if column:
			area = node.get_item_area_rect(item, column)
		else:
			area = node.get_item_area_rect(item)
		var position = Vector2(node.rect_global_position.x + area.position.x + area.size.x / 2, node.rect_global_position.y + area.position.y + area.size.y / 2)
		node.get_tree().root.warp_mouse(position)
	if item and column and button_index != null:
		if event.is_action_pressed("ui_accept"):
			node.accept_event()
			return node.emit_signal("button_pressed", item, column, button_index + 1)
		var new_button_index = button_index
		if event.is_action_pressed("ui_home"):
			node.accept_event()
			new_button_index += 1
			if new_button_index >= item.get_button_count(column):
				new_button_index = 0
		elif event.is_action_pressed("ui_end"):
			node.accept_event()
			new_button_index -= 1
			if new_button_index < 0:
				new_button_index = item.get_button_count(column) - 1
		if new_button_index != button_index and item.has_method("get_button_tooltip"):
			button_index = new_button_index
			var tokens = PoolStringArray([])
			var tooltip = item.get_button_tooltip(column, button_index)
			if tooltip:
				tokens.append(tooltip)
			tokens.append("button")
			TTS.speak(tokens.join(": "), true)

func tree_focused():
	if node.get_selected():
		tree_item_render()
	else:
		TTS.speak("tree", true)

func tree_item_collapsed(item):
	if node.has_focus():
		if item.collapsed:
			TTS.speak("collapsed", true)
		else:
			TTS.speak("expanded", true)

func progress_bar_focused():
	var percentage = int(node.ratio * 100)
	TTS.speak("%s percent" % percentage, false)
	TTS.speak("progress bar", false)

var last_percentage_spoken

var last_percentage_spoken_at = 0

func progress_bar_value_changed(value):
	var percentage = node.value / (node.max_value - node.min_value) * 100
	percentage = int(percentage)
	if percentage != last_percentage_spoken and OS.get_ticks_msec() - last_percentage_spoken_at >= 10000:
		TTS.speak("%s percent" % percentage)
		last_percentage_spoken_at = OS.get_ticks_msec()
		last_percentage_spoken = percentage

func tab_container_focused():
	var text = node.get_tab_title(node.current_tab)
	text += ": tab: " + str(node.current_tab + 1) + " of " + str(node.get_tab_count())
	TTS.speak(text, false)

func tab_container_tab_changed(tab):
	if node.has_focus():
		TTS.stop()
		tab_container_focused()

func tab_container_input(event):
	var new_tab = node.current_tab
	if event.is_action_pressed("ui_right"):
		node.accept_event()
		new_tab += 1
	elif event.is_action_pressed("ui_left"):
		node.accept_event()
		new_tab -= 1
	if new_tab < 0:
		new_tab = node.get_tab_count() - 1
	elif new_tab >= node.get_tab_count():
		new_tab = 0
	if node.current_tab != new_tab:
		node.current_tab = new_tab

func focused():
	TTS.stop()
	if not node is Label:
		var label = guess_label()
		if label:
			if label is Label:
				label = label.text
			if label and label != "":
				TTS.speak(label, false)
	if node is MenuButton:
		menu_button_focused()
	elif node is AcceptDialog:
		accept_dialog_focused()
	elif node is CheckBox:
		checkbox_focused()
	elif node is Button:
		button_focused()
	elif node.is_class("EditorInspectorSection"):
		editor_inspector_section_focused()
	elif node is ItemList:
		item_list_focused()
	elif node is Label or node is RichTextLabel:
		label_focused()
	elif node is LineEdit:
		line_edit_focused()
	elif node is LinkButton:
		button_focused()
	elif node is PopupMenu:
		popup_menu_focused()
	elif node is ProgressBar:
		progress_bar_focused()
	elif node is Range:
		range_focused()
	elif node is TabContainer:
		tab_container_focused()
	elif node is TextEdit:
		text_edit_focus()
	elif node is TextureButton:
		texturebutton_focused()
	elif node is Tree:
		tree_focused()
	elif node is TextureRect:
		pass
	elif node is ColorRect:
		pass
	else:
		TTS.speak(node.get_class(), true)
	if node.hint_tooltip and not spoke_hint_tooltip:
		TTS.speak(node.hint_tooltip, false)
	spoke_hint_tooltip = false

var timer

func unfocused():
	position_in_children = 0
	timer = node.get_tree().create_timer(1)

func click_focused():
	if node.has_focus():
		return
	if node.focus_mode == Control.FOCUS_ALL:
		print_debug("Grabbing focus: %s" % node)
		node.grab_focus()

func gui_input(event):
	if event is InputEventKey and Input.is_action_just_pressed("ui_accept") and event.control and event.alt:
		TTS.speak("click", false)
		click()
	elif event is InputEventKey and event.pressed and not event.echo and event.scancode == KEY_MENU:
		node.get_tree().root.warp_mouse(node.rect_global_position)
		return click(null, BUTTON_RIGHT)
	if node is TabContainer:
		return tab_container_input(event)
	elif node is ItemList:
		return item_list_input(event)
	elif node is LineEdit:
		return line_edit_input(event)
	elif node is TextEdit:
		return text_edit_input(event)
	elif node is Tree:
		if event.is_action_pressed("ui_up") or event.is_action_pressed("ui_down") or event.is_action_pressed("ui_left") or event.is_action_pressed("ui_right"):
			node.accept_event()
		return tree_input(event)
	elif node.is_class("EditorInspectorSection"):
		return editor_inspector_section_input(event)

func is_in_bar():
	var parent = node.get_parent()
	if parent and parent is Container:
		for child in parent.get_children():
			if child and not is_focusable(child):
				return false
		return true
	return false

func is_focusable(node):
	if node.is_class("SceneTreeEditor"):
		return false
	if node.is_class("MultiMeshEditor"):
		return false
	if node.is_class("MeshInstanceEditor"):
		return false
	if node.is_class("SpriteEditor"):
		return false
	if node.is_class("Skeleton2DEditor"):
		return false
	if node.is_class("CollisionShape2DEditor"):
		return false
	if node is Panel:
		return false
	if node is TabContainer:
		return true
	if node.is_class("EditorInspectorSection"):
		return true
	if node is AcceptDialog:
		return true
	if node is Label and node.get_parent() and node.get_parent() is AcceptDialog:
		return false
	if node is Container or node is Separator or node is ScrollBar or node is Popup or node.get_class() == "Control":
		return false
	return true

func editor_inspector_section_focused():
	var child = node.get_children()[0]
	var expanded = child.is_visible_in_tree()
	var tokens = PoolStringArray(["editor inspector section"])
	if expanded:
		tokens.append("expanded")
	else:
		tokens.append("collapsed")
	TTS.speak(tokens.join(": "), false)

func editor_inspector_section_input(event):
	if event.is_action_pressed("ui_accept"):
		click()
		var child = node.get_children()[0]
		var expanded = child.is_visible_in_tree()
		if expanded:
			TTS.speak("expanded", true)
		else:
			TTS.speak("collapsed", true)

func _init(node):
	if node.is_in_group("accessible") or node.is_in_group("no-tts") or (node.get_parent() and node.get_parent().is_in_group("no-tts")):
		return
	node.add_to_group("accessible")
	add_to_group("accessibles")
	node.add_child(self)
	self.node = node
	if is_focusable(node):
		node.set_focus_mode(Control.FOCUS_ALL)
	var label = guess_label()
	if label and label is Label:
		label.set_focus_mode(Control.FOCUS_NONE)
	node.connect("focus_entered", self, "focused")
	node.connect("mouse_entered", self, "click_focused")
	node.connect("focus_exited", self, "unfocused")
	node.connect("mouse_exited", self, "unfocused")
	node.connect("gui_input", self, "gui_input")
	if node is AcceptDialog:
		node.connect("about_to_show", self, "_accept_dialog_about_to_show")
	elif node is CheckBox:
		node.connect("toggled", self, "checkbox_toggled")
	elif node is ItemList:
		node.connect("item_selected", self, "item_list_item_selected")
		node.connect("multi_selected", self, "item_list_multi_selected")
		node.connect("nothing_selected", self, "item_list_nothing_selected")
	elif node is LineEdit:
		node.connect("text_changed", self, "line_edit_text_changed")
	elif node is PopupMenu:
		node.connect("id_focused", self, "popup_menu_item_id_focused")
		node.connect("id_pressed", self, "popup_menu_item_id_pressed")
	elif node is ProgressBar:
		node.connect("value_changed", self, "progress_bar_value_changed")
	elif node is Range:
		node.connect("value_changed", self, "range_value_changed")
	elif node is TabContainer:
		node.connect("tab_changed", self, "tab_container_tab_changed")
	elif node is Tree:
		node.connect("item_collapsed", self, "tree_item_collapsed")
		node.connect("multi_selected", self, "tree_item_multi_selected")
		if node.select_mode == Tree.SELECT_MULTI:
			node.connect("cell_selected", self, "tree_item_selected")
		else:
			node.connect("item_selected", self, "tree_item_selected")
	node.connect("tree_exiting", self, "queue_free", [], Object.CONNECT_DEFERRED)

func _process(delta):
	if timer and timer.time_left <= 0:
		if node.is_inside_tree() and not node.get_focus_owner():
			node.get_tree().root.warp_mouse(node.rect_global_position)
			timer = null

func free():
	if timer:
		timer.unreference()
		timer = null
	.free()
