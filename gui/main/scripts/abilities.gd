extends Panel
class_name AbilityPanel

var character: Characters.Character

@onready var vbox_container:= $ScrollContainer/VBoxContainer as VBoxContainer


func update():
	for c in vbox_container.get_children():
		(c as Control).hide()
	
	for i in range(character.abilities.size()):
		var container: HBoxContainer
		var ability:= character.abilities.values()[i] as Ability
		@warning_ignore("integer_division")
		var rank:= mini(ability.level * Items.RANK_COLORS.size() / 50, Items.RANK_COLORS.size()-1)
		if vbox_container.has_node("Ability" + str(i)):
			container = vbox_container.get_node("Ability" + str(i)) as HBoxContainer
		else:
			container = vbox_container.get_node("Ability0").duplicate(14) as HBoxContainer
			container.name = "Ability" + str(i)
			vbox_container.add_child(container)
		(container.get_node("Label") as Label).text = tr(ability.name.to_upper())
		(container.get_node("Label") as Label).add_theme_color_override("font_color", Items.RANK_COLORS[rank])
		(container.get_node("Value") as Label).text = str(ability.level)
		(container.get_node("Value") as Label).add_theme_color_override("font_color", Items.RANK_COLORS[rank])
		(container.get_node("Label/ExpBar") as ProgressBar).max_value = ability.get_max_exp()
		(container.get_node("Label/ExpBar") as ProgressBar).value = ability.experience
		# TODO: add tooltips
		container.show()
