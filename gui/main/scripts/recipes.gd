extends Panel
class_name RecipePanel

var character: Characters.Character
var character_settings: Characters.CharacterSettings

@onready var base_container:= $ScrollContainer/VBoxContainer as VBoxContainer


signal settings_changed


func _toggle_recipe_disabled(button_pressed: bool, type: String):
	if button_pressed:
		character_settings.disabled_recipes.erase(type)
	else:
		character_settings.disabled_recipes.push_back(type)
	emit_signal("settings_changed")

func update():
	for c1 in base_container.get_children():
		c1.hide()
		for c2 in c1.get_node("VBoxContainer").get_children():
			(c2 as Control).hide()
	
	for ability in character.abilities:
		if ability not in Skills.ABILITIES or "recipes" not in Skills.ABILITIES[ability]:
			continue
		
		var recipes:= Skills.ABILITIES[ability].recipes as Array
		var ability_name:= (ability as String).to_pascal_case()
		var container:= base_container.get_node(ability_name + "/VBoxContainer") as VBoxContainer
		(container.get_node("Label") as Label).show()
		base_container.get_node(ability_name).show()
		
		for i in range(recipes.size()):
			var panel: Panel
			var check_button: CheckButton
			var recipe:= recipes[i] as String
			if container.has_node("Panel" + str(i)):
				panel = container.get_node("Panel" + str(i)) as Panel
			else:
				panel = base_container.get_node("Alchemy/VBoxContainer/Panel0").duplicate(14) as Panel
				panel.name = "Panel" + str(i)
				container.add_child(panel)
			check_button = panel.get_node("CheckButton") as CheckButton
			if check_button.is_connected("toggled", Callable(self, "_toggle_recipe_disabled")):
				check_button.disconnect("toggled", Callable(self, "_toggle_recipe_disabled"))
			check_button.connect("toggled", Callable(self, "_toggle_recipe_disabled").bind(recipe))
			check_button.set_pressed_no_signal(recipe not in character_settings.disabled_recipes)
			check_button.text = tr(recipe.to_upper())
			(panel.get_node("Label") as Label).text = tr(recipe.to_upper()+"_DESCRIPTION")
			panel.show()
		(base_container.get_node(ability_name) as Control).custom_minimum_size.y = maxi(int(container.size.y + 16), 24 + 88 * recipes.size())
