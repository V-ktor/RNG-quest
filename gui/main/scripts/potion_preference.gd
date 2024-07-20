extends Panel

var character_settings: Characters.CharacterSettings


func update():
	$VBoxContainer/CheckBoxHealth.set_pressed_no_signal(
		"health" in character_settings.valid_potion_types)
	$VBoxContainer/CheckBoxStamina.set_pressed_no_signal(
		"stamina" in character_settings.valid_potion_types)
	$VBoxContainer/CheckBoxMana.set_pressed_no_signal(
		"mana" in character_settings.valid_potion_types)
