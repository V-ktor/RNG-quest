extends Control
class_name CharacterPanel

var characters: Array[Characters.Character] = []

var scene_character_panel:= preload("res://gui/main/scenes/character_panel.tscn")

@onready
var container_node:= $ScrollContainer/HBoxContainer


signal status_entered(status: String)


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
		
		var status_container: Container = panel.get_node("VBoxContainer/Status")
		for c in status_container.get_children():
			c.hide()
		for j in range(character.status.size()):
			var status_panel: Panel
			var status: Dictionary = character.status[j]
			
			if status_container.has_node("Status" + str(j)):
				status_panel = status_container.get_node("Status" + str(j))
			else:
				status_panel = status_container.get_node("Status0").duplicate(14)
				status_panel.name = "Status" + str(j)
				status_container.add_child(status_panel)
			if status_panel.is_connected("mouse_entered", Callable(self, "_status_entered")):
				status_panel.disconnect("mouse_entered", Callable(self, "_status_entered"))
			status_panel.connect("mouse_entered", Callable(self, "_status_entered").bind(Skills.create_status_tooltip(status)))
			status_panel.get_node("TextureProgressBar").max_value = status.max_duration
			status_panel.get_node("TextureProgressBar").value = status.max_duration - status.duration
			status_panel.get_node("Label").text = status.name.left(2)
			
			status_panel.show()
			
		
		panel.show()

func _status_entered(status: String):
	emit_signal("status_entered", status)

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
		panel.get_node("VBoxContainer/HBoxContainer/VBoxContainer/HealthBar").set_tooltip_text(tr("HEALTH") + ": " + str(int(character.health)) + " / " + str(character.max_health))
		panel.get_node("VBoxContainer/HBoxContainer/VBoxContainer/StaminaBar").set_max(character.max_stamina)
		panel.get_node("VBoxContainer/HBoxContainer/VBoxContainer/StaminaBar").set_value(character.stamina)
		panel.get_node("VBoxContainer/HBoxContainer/VBoxContainer/StaminaBar").set_tooltip_text(tr("STAMINA") + ": " + str(int(character.stamina)) + " / " + str(character.max_stamina))
		panel.get_node("VBoxContainer/HBoxContainer/VBoxContainer/ManaBar").set_max(character.max_mana)
		panel.get_node("VBoxContainer/HBoxContainer/VBoxContainer/ManaBar").set_value(character.mana)
		panel.get_node("VBoxContainer/HBoxContainer/VBoxContainer/ManaBar").set_tooltip_text(tr("MANA") + ": " + str(int(character.mana)) + " / " + str(character.max_mana))
		panel.get_node("VBoxContainer/HBoxContainer/VBoxContainer/FocusBar").set_max(character.max_focus)
		panel.get_node("VBoxContainer/HBoxContainer/VBoxContainer/FocusBar").set_value(character.focus)
		panel.get_node("VBoxContainer/HBoxContainer/VBoxContainer/FocusBar").set_tooltip_text(tr("FOCUS") + ": " + str(int(character.focus)) + " / " + str(character.max_focus))
#		panel.get_node("VBoxContainer/HBoxContainer/VBoxContainer/ExpBar").set_max(character.get_max_exp())
#		panel.get_node("VBoxContainer/HBoxContainer/VBoxContainer/ExpBar").set_value(character.experience)
		panel.get_node("VBoxContainer/HBoxContainer/VBoxContainer/ProgressBar").set_max(character.action_duration)
		panel.get_node("VBoxContainer/HBoxContainer/VBoxContainer/ProgressBar").set_value(character.action_duration - character.delay)
		panel.get_node("VBoxContainer/HBoxContainer/VBoxContainer/ProgressBar/Label").text = character.current_action
		
		panel.get_node("VBoxContainer/HBoxContainer/LeftColumn/VBoxContainer/Line1").modulate.a = 0.25 + 0.75*float(character.min_dist == 0)
		panel.get_node("VBoxContainer/HBoxContainer/LeftColumn/VBoxContainer/Line2").modulate.a = 0.25 + 0.75*float(character.min_dist == 1)
		panel.get_node("VBoxContainer/HBoxContainer/LeftColumn/VBoxContainer/Line3").modulate.a = 0.25 + 0.75*float(character.min_dist >= 2)
		
		# TODO: skill
		
	
