extends Panel

@export
var tooltip: Control

var character: Characters.Character

@onready
var eq_weapons_panel: VBoxContainer = $ScrollContainer/VBoxContainer/Weapons/VBoxContainer
@onready
var eq_armour_panel: VBoxContainer = $ScrollContainer/VBoxContainer/Armour/VBoxContainer
@onready
var eq_accessoire_panel: VBoxContainer = $ScrollContainer/VBoxContainer/Accessoires/VBoxContainer


func update():
	for c in eq_weapons_panel.get_children() + eq_armour_panel.get_children() + eq_accessoire_panel.get_children():
		c.hide()
	
	for type in character.equipment.keys():
		var ID: String = type.capitalize().replace(" ", "")
		var label: Label = get_node("%" + ID)
		if label == null:
			continue
		label.text = character.equipment[type].name
		label.modulate = Items.RANK_COLORS[character.equipment[type].rank]
		if !label.is_connected("mouse_entered", Callable(self, "_show_equipment_tooltip")):
			label.connect("mouse_entered", Callable(self, "_show_equipment_tooltip").bind(type))
		label.show()

# Tooltips

func _show_equipment_tooltip(type: String):
	if tooltip == null:
		return
	
	var item: Dictionary = character.equipment[type]
	tooltip.show_texts([item.description, item.component_description], [tr("PROPERTIES"), tr("COMPONENTS")])
