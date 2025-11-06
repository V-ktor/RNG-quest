extends Panel
class_name ModPanel

var character: Characters.Character

@onready
var vbox_container:= $ScrollContainer/VBoxContainer


func _add_mod(index: int, type: String, value: float):
	var container: HBoxContainer
	var color: Color
	if value <= 0.0:
		color = Color(1.0, 1.0, 1.0).lerp(Color(1.0, 0.0, 0.0), -value)
	elif value <= 1.0:
		color = Color(1.0, 1.0, 1.0).lerp(Color(1.0, 1.0, 0.0), value)
	else:
		color = Color(1.0, 1.0, 0.0).lerp(Color(0.0, 1.0, 0.0), (value - 1.0)/4.0)
	if vbox_container.has_node("Mod" + str(index)):
		container = vbox_container.get_node("Mod" + str(index)) as HBoxContainer
	else:
		container = vbox_container.get_node("Mod0").duplicate(14) as HBoxContainer
		container.name = "Mod" + str(index)
		vbox_container.add_child(container)
	(container.get_node("Label") as Label).text = type
	(container.get_node("Value") as Label).text = str(int(100.0 * value)) + "%"
	(container.get_node("Label") as Label).add_theme_color_override("font_color", color)
	container.show()

func update():
	var index:= 0
	
	for c in vbox_container.get_children():
		(c as Control).hide()
	
	for type in character.damage.keys():
		_add_mod(index, tr(type.to_upper()) + " " + tr("DAMAGE"), character.damage[type])
		index += 1
	for type in character.resistance.keys():
		_add_mod(index, tr(type.to_upper()) + " " + tr("RESISTANCE"), character.resistance[type])
		index += 1
