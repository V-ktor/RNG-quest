extends Panel

var character: Characters.Character
var character_settings: Characters.CharacterSettings

@onready
var base_container: VBoxContainer = $ScrollContainer/VBoxContainer


signal settings_changed


func _toggle_skill_module_disabled(button_pressed: bool, type: String):
	if button_pressed:
		character_settings.disabled_skill_modules.erase(type)
	else:
		character_settings.disabled_skill_modules.push_back(type)
	emit_signal("settings_changed")

func update():
	var skill_module_dict:= {}
	for a in character.abilities.keys():
		if Skills.ABILITY_MODULES.has(a):
			for c in Skills.ABILITY_MODULES[a].keys():
				if !skill_module_dict.has(c):
					skill_module_dict[c] = []
				for k in Skills.ABILITY_MODULES[a][c]:
					if !skill_module_dict[c].has(k):
						skill_module_dict[c].push_back(k)
	
	for c1 in base_container.get_children():
		for c2 in c1.get_node("VBoxContainer").get_children():
			c2.hide()
	
	for k in skill_module_dict.keys():
		var n: String = k.capitalize().replace(' ','')
		if skill_module_dict[k].size() > 0:
			var container: VBoxContainer = base_container.get_node(n + "/VBoxContainer")
			container.get_node("Label").show()
			for i in range(skill_module_dict[k].size()):
				var panel: Panel
				if container.has_node("Panel" + str(i)):
					panel = container.get_node("Panel" + str(i))
				else:
					panel = base_container.get_node("BaseType/VBoxContainer/Panel0").duplicate(14)
					panel.name = "Panel" + str(i)
					container.add_child(panel)
				if panel.get_node("CheckButton").is_connected("toggled", Callable(self, "_toggle_skill_module_disabled")):
					panel.get_node("CheckButton").disconnect("toggled", Callable(self, "_toggle_skill_module_disabled"))
				panel.get_node("CheckButton").connect("toggled", Callable(self, "_toggle_skill_module_disabled").bind(skill_module_dict[k][i]))
				panel.get_node("CheckButton").set_pressed_no_signal(!(skill_module_dict[k][i] in character_settings.disabled_skill_modules))
				panel.get_node("CheckButton").text = tr(skill_module_dict[k][i].to_upper())
				panel.get_node("Label").text = tr(skill_module_dict[k][i].to_upper()+"_DESCRIPTION")
				panel.show()
			base_container.get_node(n).custom_minimum_size.y = max(container.size.y + 16, 24 + 88 * skill_module_dict[k].size())
