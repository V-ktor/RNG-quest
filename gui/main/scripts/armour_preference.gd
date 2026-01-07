extends Panel
class_name ArmourPreferencePanel

var character_settings: Characters.CharacterSettings


func update():
	($VBoxContainer/CheckBoxLight as CheckBox).set_pressed_no_signal(
		"light" in character_settings.valid_armour_types)
	($VBoxContainer/CheckBoxMedium as CheckBox).set_pressed_no_signal(
		"medium" in character_settings.valid_armour_types)
	($VBoxContainer/CheckBoxHeavy as CheckBox).set_pressed_no_signal(
		"heavy" in character_settings.valid_armour_types)
