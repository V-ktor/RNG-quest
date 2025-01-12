extends Panel
class_name Tooltip

const MOUSE_LIMIT = 128.0

var current_texts: Array

@onready var container:= $VBoxContainer as VBoxContainer
@onready var text_label:= $VBoxContainer/RichTextLabel as RichTextLabel
@onready var tabs_container:= $VBoxContainer/Tabs as HBoxContainer


func _get_text_length(text: String) -> int:
	var length:= text.length()
	var regex:= RegEx.new()
	var result: Array[RegExMatch]
	regex.compile(r'\[[\w0-9=",./#]+\]')
	result = regex.search_all(text)
	for m in result:
		length -= m.get_string().length()
	return length

func _get_max_line_length(text: String) -> int:
	var pos_l:= 0
	var pos_r:= text.find("\n")
	var max_len:= pos_r - pos_l
	var len: int
	while pos_r>=0:
		pos_l = pos_r
		pos_r = text.find("\n", pos_r + 1)
		len = _get_text_length(text.substr(pos_l, pos_r-pos_l))
		if len > max_len:
			max_len = len
	len = _get_text_length(text.substr(pos_l))
	if len > max_len:
		max_len = len
	return max_len

func _set_pos_scale(text: String):
	position = get_global_mouse_position() + Vector2(8, 0)
	size.x = clampi(16 + 8*_get_max_line_length(text), 192, 448)
	size.y = clampi(48 + 17*text.count("\n"), 64, 512)
	
	# Move tooltip to the other side if it it reaches the window border
	if position.x + size.x > DisplayServer.window_get_size().x:
		position.x -= size.x
	if position.y + size.y > DisplayServer.window_get_size().y:
		position.y -= size.y

func show_text(text: String):
	text_label.clear()
	text_label.parse_bbcode(text)
	tabs_container.hide()
	_set_pos_scale(text)
	show()

func show_texts(text_list: Array, category_names: Array):
	current_texts = text_list
	text_label.clear()
	text_label.parse_bbcode(text_list[0])
	for c in tabs_container.get_children():
		(c as Button).set_pressed_no_signal(false)
		(c as Button).hide()
	for i in range(text_list.size()):
		var button: Button
		if tabs_container.has_node("Button" + str(i)):
			button = tabs_container.get_node("Button" + str(i)) as Button
		else:
			button = tabs_container.get_node("Button0").duplicate(14) as Button
			button.name = "Button" + str(i)
			tabs_container.add_child(button)
		if !button.is_connected("toggled", Callable(self, "_tab_button_toggled")):
			button.connect("toggled", Callable(self, "_tab_button_toggled").bind(i))
		button.text = tr(category_names[i])
		button.show()
	tabs_container.show()
	(tabs_container.get_node("Button0") as Button).set_pressed_no_signal(true)
	_set_pos_scale(text_list[0])
	show()

func _tab_button_toggled(pressed: bool, index: int):
	if pressed:
		text_label.clear()
		text_label.parse_bbcode(current_texts[index])

func _process(_delta: float):
	if !visible:
		return
	
	var mouse_pos:= get_local_mouse_position()
	if mouse_pos.x < -MOUSE_LIMIT || mouse_pos.y < -MOUSE_LIMIT || mouse_pos.x > size.x + MOUSE_LIMIT || mouse_pos.y > size.y + MOUSE_LIMIT:
		hide()
		return
	
	position.x = mini(position.x, DisplayServer.window_get_size().x - size.x - 16)	# leave extra space for scroll bar
	position.y = clampi(position.y, 0, DisplayServer.window_get_size().y - size.y)
