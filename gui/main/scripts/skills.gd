extends Panel

@export
var tooltip: Control

var character: Characters.Character

@onready
var vbox_container:= $ScrollContainer/VBoxContainer


func update():
	for c in vbox_container.get_children():
		c.hide()
	
	for i in range(character.skills.size()):
		var label: Label
		var skill: Dictionary = character.skills[i]
		if vbox_container.has_node("Skill" + str(i)):
			label = vbox_container.get_node("Skill" + str(i))
		else:
			label = vbox_container.get_node("Skill0").duplicate(14)
			label.name = "Skill" + str(i)
			vbox_container.add_child(label)
		if !label.is_connected("mouse_entered", Callable(self, "_show_skill_tooltip")):
			label.connect("mouse_entered", Callable(self, "_show_skill_tooltip").bind(i))
		label.text = skill.name + " " + Skills.convert_to_roman_number(skill.level)
		label.show()

# Tooltips

func _show_skill_tooltip(index: int):
	if tooltip == null:
		return
	
	var skill: Dictionary = character.skills[index]
	tooltip.show_texts([skill.description, skill.module_description], [tr("SKILL"),tr("MODULES")])
