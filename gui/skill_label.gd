extends Label


func _make_custom_tooltip(for_text: String) -> Object:
	var panel:= Panel.new()
	var label:= RichTextLabel.new()
	label.fit_content = true
	label.bbcode_enabled = true
	label.parse_bbcode(for_text)
	label.anchor_right = 1.0
	label.anchor_bottom = 1.0
	label.offset_left = 4
	label.offset_right = -4
	label.offset_top = 4
	label.offset_bottom = -4
	panel.custom_minimum_size = Vector2(256,512)
	panel.add_child(label)
	return panel
