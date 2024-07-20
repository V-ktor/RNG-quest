extends Panel

var character_settings: Characters.CharacterSettings


func update():
	$VBoxContainer/CheckBoxLight.set_pressed_no_signal(
		"light" in character_settings.valid_armour_types)
	$VBoxContainer/CheckBoxMedium.set_pressed_no_signal(
		"medium" in character_settings.valid_armour_types)
	$VBoxContainer/CheckBoxHeavy.set_pressed_no_signal(
		"heavy" in character_settings.valid_armour_types)
