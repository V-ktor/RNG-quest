extends Panel
class_name SkillModulePanel

var character: Characters.Character
var character_settings: Characters.CharacterSettings

@onready var base_container:= $ScrollContainer/VBoxContainer as VBoxContainer


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
				if c not in skill_module_dict:
					skill_module_dict[c] = []
				for k in Skills.ABILITY_MODULES[a][c]:
					if k not in skill_module_dict[c]:
						skill_module_dict[c].push_back(k)
	
	for c1 in base_container.get_children():
		for c2 in c1.get_node("VBoxContainer").get_children():
			(c2 as Control).hide()
	
	for k in skill_module_dict.keys():
		var n: String = k.capitalize().replace(' ','')
		if skill_module_dict[k].size() > 0:
			var container:= base_container.get_node(n + "/VBoxContainer") as VBoxContainer
			(container.get_node("Label") as Label).show()
			for i in range(skill_module_dict[k].size()):
				var panel: Panel
				var check_button: CheckButton
				if container.has_node("Panel" + str(i)):
					panel = container.get_node("Panel" + str(i)) as Panel
				else:
					panel = base_container.get_node("BaseType/VBoxContainer/Panel0").duplicate(14) as Panel
					panel.name = "Panel" + str(i)
					container.add_child(panel)
				check_button = panel.get_node("CheckButton") as CheckButton
				if check_button.is_connected("toggled", Callable(self, "_toggle_skill_module_disabled")):
					check_button.disconnect("toggled", Callable(self, "_toggle_skill_module_disabled"))
				check_button.connect("toggled", Callable(self, "_toggle_skill_module_disabled").bind(skill_module_dict[k][i]))
				check_button.set_pressed_no_signal(!(skill_module_dict[k][i] in character_settings.disabled_skill_modules))
				check_button.text = tr(skill_module_dict[k][i].to_upper())
				(panel.get_node("Label") as Label).text = tr(skill_module_dict[k][i].to_upper()+"_DESCRIPTION")
				panel.show()
			(base_container.get_node(n) as Control).custom_minimum_size.y = maxi(container.size.y + 16, 24 + 88 * skill_module_dict[k].size())
