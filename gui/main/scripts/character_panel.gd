extends Control

var characters: Array[Characters.Character] = []

var scene_character_panel:= preload("res://gui/main/scenes/character_panel.tscn")

@onready
var container_node:= $ScrollContainer/HBoxContainer


func update_characters():
	for c in container_node.get_children():
		c.hide()
	
	for i in range(characters.size()):
		var panel: Panel
		var character: Characters.Character = characters[i]
		
		if container_node.has_node("CharacterPanel" + str(i)):
			panel = container_node.get_node("CharacterPanel" + str(i))
		else:
			panel = scene_character_panel.instantiate()
			panel.set_name("CharacterPanel" + str(i))
			container_node.add_child(panel)
		
		# TODO: skill
		
		for c in panel.get_node("VBoxContainer/Status").get_children():
			c.hide()
		for j in range(character.status.size()):
			var status_panel: Panel
			
		
		panel.show()

func _process(_delta: float):
	for i in range(characters.size()):
		if not container_node.has_node("CharacterPanel" + str(i)):
			continue
		
		var character: Characters.Character = characters[i]
		var panel: Panel = container_node.get_node("CharacterPanel" + str(i))
		
		panel.get_node("VBoxContainer/TopContainer/Name").set_text(character.name)
		panel.get_node("VBoxContainer/TopContainer/Level").set_text(tr("LVL") + " " + str(character.level))
		panel.get_node("VBoxContainer/HBoxContainer/VBoxContainer/HealthBar").set_max(character.max_health)
		panel.get_node("VBoxContainer/HBoxContainer/VBoxContainer/HealthBar").set_value(character.health)
		panel.get_node("VBoxContainer/HBoxContainer/VBoxContainer/StaminaBar").set_max(character.max_stamina)
		panel.get_node("VBoxContainer/HBoxContainer/VBoxContainer/StaminaBar").set_value(character.stamina)
		panel.get_node("VBoxContainer/HBoxContainer/VBoxContainer/ManaBar").set_max(character.max_mana)
		panel.get_node("VBoxContainer/HBoxContainer/VBoxContainer/ManaBar").set_value(character.mana)
		panel.get_node("VBoxContainer/HBoxContainer/VBoxContainer/FocusBar").set_max(character.max_focus)
		panel.get_node("VBoxContainer/HBoxContainer/VBoxContainer/FocusBar").set_value(character.focus)
#		panel.get_node("VBoxContainer/HBoxContainer/VBoxContainer/ExpBar").set_max(character.get_max_exp())
#		panel.get_node("VBoxContainer/HBoxContainer/VBoxContainer/ExpBar").set_value(character.experience)
		panel.get_node("VBoxContainer/HBoxContainer/VBoxContainer/ProgressBar").set_max(character.action_duration)
		panel.get_node("VBoxContainer/HBoxContainer/VBoxContainer/ProgressBar").set_value(character.action_duration - character.delay)
		panel.get_node("VBoxContainer/HBoxContainer/VBoxContainer/ProgressBar/Label").text = character.current_action
		
		panel.get_node("VBoxContainer/HBoxContainer/LeftColumn/VBoxContainer/Line1").modulate.a = 0.25 + 0.75*float(character.min_dist == 0)
		panel.get_node("VBoxContainer/HBoxContainer/LeftColumn/VBoxContainer/Line2").modulate.a = 0.25 + 0.75*float(character.min_dist == 1)
		panel.get_node("VBoxContainer/HBoxContainer/LeftColumn/VBoxContainer/Line3").modulate.a = 0.25 + 0.75*float(character.min_dist >= 2)
		
		# TODO: skill
		
	
