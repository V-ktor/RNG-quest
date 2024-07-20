extends Panel

var character: Characters.Character

@onready
var vbox_container:= $ScrollContainer/VBoxContainer


func update():
	for c in vbox_container.get_children():
		c.hide()
	
	for i in range(character.abilities.size()):
		var container: HBoxContainer
		if vbox_container.has_node("Ability" + str(i)):
			container = vbox_container.get_node("Ability" + str(i))
		else:
			container = vbox_container.get_node("Ability0").duplicate(14)
			container.name = "Ability" + str(i)
			vbox_container.add_child(container)
		container.get_node("Label").text = tr(character.abilities.keys()[i].to_upper())
		container.get_node("Value").text = str(character.abilities.values()[i])
		container.show()
