extends Panel
class_name TimetablePanel

@onready var spin_box:= $ScrollContainer/VBoxContainer/HBoxContainer/SpinBox as SpinBox

@warning_ignore("unused_signal")
signal timetable_modified(ID: int, index: int)

func update(timetable: Dictionary, time_offset: int):
	for i in range(18):
		var button: HBoxContainer
		var option_button: OptionButton
		var time:= i + 5
		if has_node("ScrollContainer/VBoxContainer/HBoxContainer" + str(i)):
			button = get_node("ScrollContainer/VBoxContainer/HBoxContainer" + str(i)) as HBoxContainer
		else:
			button = $ScrollContainer/VBoxContainer/HBoxContainer0.duplicate(14) as HBoxContainer
			button.name = "HBoxContainer" + str(i)
			$ScrollContainer/VBoxContainer.add_child(button)
		option_button = button.get_node("OptionButton") as OptionButton
		(button.get_node("Label") as Label).text = str(posmod(time + time_offset, 24)).pad_zeros(2) + ":00"
		if !option_button.is_connected("item_selected", Callable(self, "_set_timetable")):
			option_button.connect("item_selected", Callable(self, "_set_timetable").bind(i))
		if time in timetable:
			option_button.selected = Main.ACTIONS.find(timetable[time])
		else:
			option_button.selected = 5
			for j in range(1, time - 4):
				if time - j in timetable:
					option_button.selected = Main.ACTIONS.find(timetable[time - j])
					break
	spin_box.value = time_offset

func _set_timetable(ID: int, index: int):
	emit_signal("timetable_modified", ID, index)
