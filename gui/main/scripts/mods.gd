extends Panel

var character: Characters.Character

@onready
var vbox_container:= $ScrollContainer/VBoxContainer


func _add_mod(index: int, type: String, value: float):
	var container: HBoxContainer
	if vbox_container.has_node("Mod" + str(index)):
		container = vbox_container.get_node("Mod" + str(index))
	else:
		container = vbox_container.get_node("Mod0").duplicate(14)
		container.name = "Mod" + str(index)
		vbox_container.add_child(container)
	container.get_node("Label").text = tr(type.to_upper())
	container.get_node("Value").text = str(int(100.0 * value)) + "%"
	container.show()

func update():
	var index:= 0
	
	for c in vbox_container.get_children():
		c.hide()
	
	for type in character.damage.keys():
		_add_mod(index, type, character.damage[type])
		index += 1
	for type in character.resistance.keys():
		_add_mod(index, type, character.resistance[type])
		index += 1
