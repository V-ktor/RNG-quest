extends Panel
class_name AttributePanel

var character: Characters.Character

@onready
var vbox_container:= $VBoxContainer


func update():
	for attribute in character.attributes:
		var container:= vbox_container.get_node(attribute.capitalize()) as HBoxContainer
		if container == null:
			continue
		(container.get_node("Value") as Label).text = str(character.attributes[attribute])
