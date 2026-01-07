extends Panel
class_name WeaponPreferencePanel

var character_settings: Characters.CharacterSettings


func update():
	($VBoxContainer/CheckBoxMelee as CheckBox).set_pressed_no_signal(
		"melee" in character_settings.valid_weapon_types)
	($VBoxContainer/CheckBoxRanged as CheckBox).set_pressed_no_signal(
		"ranged" in character_settings.valid_weapon_types)
	($VBoxContainer/CheckBoxMagic as CheckBox).set_pressed_no_signal(
		"magic" in character_settings.valid_weapon_types)
	($VBoxContainer/CheckBoxShield as CheckBox).set_pressed_no_signal(
		"shield" in character_settings.valid_weapon_types)
	($VBoxContainer/CheckBox1h as CheckBox).set_pressed_no_signal(
		character_settings.weapon_1h_alowed)
	($VBoxContainer/CheckBox2h as CheckBox).set_pressed_no_signal(
		character_settings.weapon_2h_alowed)
