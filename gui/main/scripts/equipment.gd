extends Panel
class_name EquipmentPanel

@export var tooltip: Tooltip

var character: Characters.Character

@onready var eq_weapons_panel:= $ScrollContainer/VBoxContainer/Weapons/VBoxContainer as VBoxContainer
@onready var eq_armour_panel:= $ScrollContainer/VBoxContainer/Armour/VBoxContainer as VBoxContainer
@onready var eq_accessoire_panel:= $ScrollContainer/VBoxContainer/Accessoires/VBoxContainer as VBoxContainer


func update(inventory:= []):
	if not visible or not get_parent().visible:
		return
	
	for c in eq_weapons_panel.get_children() + eq_armour_panel.get_children() + eq_accessoire_panel.get_children():
		(c as Control).hide()
	
	for type in character.equipment.keys():
		var ID: String = type.capitalize().replace(" ", "")
		var label:= get_node("%" + ID) as Label
		if label == null:
			continue
		label.text = character.equipment[type].name
		label.add_theme_color_override("font_color", Items.RANK_COLORS[character.equipment[type].rank])
		if !label.is_connected("mouse_entered", Callable(self, "_show_equipment_tooltip")):
			label.connect("mouse_entered", Callable(self, "_show_equipment_tooltip").bind(type))
		label.show()

# Tooltips

func _show_equipment_tooltip(type: String):
	if tooltip == null:
		return
	
	var item: Dictionary = character.equipment[type]
	if "story" in item:
		tooltip.show_texts([item.description, item.story, item.component_description], [tr("PROPERTIES"), tr("DESCRIPTION"), tr("COMPONENTS")])
	else:
		tooltip.show_texts([item.description, item.component_description], [tr("PROPERTIES"), tr("COMPONENTS")])
