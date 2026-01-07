extends Panel
class_name PotionPreferencePanel

var character_settings: Characters.CharacterSettings


func update():
	($VBoxContainer/CheckBoxHealth as CheckBox).set_pressed_no_signal(
		"health" in character_settings.valid_potion_types)
	($VBoxContainer/CheckBoxStamina as CheckBox).set_pressed_no_signal(
		"stamina" in character_settings.valid_potion_types)
	($VBoxContainer/CheckBoxMana as CheckBox).set_pressed_no_signal(
		"mana" in character_settings.valid_potion_types)
