extends Panel

var character: Characters.Character

@onready
var vbox_container:= $VBoxContainer


func update():
	for attribute in character.attributes:
		var container: HBoxContainer = vbox_container.get_node(attribute.capitalize())
		if container == null:
			continue
		container.get_node("Value").text = str(character.attributes[attribute])
