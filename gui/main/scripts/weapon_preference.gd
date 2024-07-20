extends Panel

var character_settings: Characters.CharacterSettings


func update():
	$VBoxContainer/CheckBoxMelee.set_pressed_no_signal(
		"melee" in character_settings.valid_weapon_types)
	$VBoxContainer/CheckBoxRanged.set_pressed_no_signal(
		"ranged" in character_settings.valid_weapon_types)
	$VBoxContainer/CheckBoxMagic.set_pressed_no_signal(
		"magic" in character_settings.valid_weapon_types)
	$VBoxContainer/CheckBoxShield.set_pressed_no_signal(
		"shield" in character_settings.valid_weapon_types)
	$VBoxContainer/CheckBox1h.set_pressed_no_signal(
		character_settings.weapon_1h_alowed)
	$VBoxContainer/CheckBox2h.set_pressed_no_signal(
		character_settings.weapon_2h_alowed)
