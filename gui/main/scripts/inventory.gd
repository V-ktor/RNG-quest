extends Panel
class_name InventoryPanel

@export var tooltip: Tooltip

var main_inventory: Array
var potion_inventory: Array
var story_inventory: Array

@onready var inventory_panel := $ScrollContainer/VBoxContainer/Inventory as VBoxContainer
@onready var potion_inventory_panel := $ScrollContainer/VBoxContainer/Potions as VBoxContainer
@onready var story_inventory_panel := $ScrollContainer/VBoxContainer/Quest as VBoxContainer


func summarize_inventory(array: Array) -> Dictionary:
	var dict := {}
	for item in array:
		if item.name in dict:
			dict[item.name] += 1
		else:
			dict[item.name] = 1
	return dict

func update_inventory(inventory: Array[Item]) -> void:
	var items := summarize_inventory(inventory)
	main_inventory = inventory
	
	for c in inventory_panel.get_children():
		(c as Control).hide()
	
	for i in range(items.size()):
		var label: Label
		var item: Item
		var item_name := items.keys()[i] as String
		for it in inventory:
			if it.name == item_name:
				item = it
				break
		if inventory_panel.has_node("Label" + str(i)):
			label = inventory_panel.get_node("Label" + str(i)) as Label
		else:
			label = inventory_panel.get_node("Label0").duplicate(14) as Label
			label.name = "Label" + str(i)
			inventory_panel.add_child(label)
		if label.is_connected("mouse_entered", Callable(self, "_show_inventory_tooltip")):
			label.disconnect("mouse_entered", Callable(self, "_show_inventory_tooltip"))
		label.connect("mouse_entered", Callable(self, "_show_inventory_tooltip").bind(item))
		label.text = str(items.values()[i]) + "x " + item_name
		label.add_theme_color_override("font_color", Items.RANK_COLORS[item.rank])
		label.show()

func update_potion_inventory(inventory: Array[ItemPotion]) -> void:
	var potions := summarize_inventory(inventory)
	potion_inventory = inventory
	
	for c in potion_inventory_panel.get_children():
		(c as Control).hide()
	
	for i in range(potions.size()):
		var label: Label
		var item: Item
		var _name := potions.keys()[i] as String
		for it in inventory:
			if it.name == _name:
				item = it
				break
		if potion_inventory_panel.has_node("Label" + str(i)):
			label = potion_inventory_panel.get_node("Label" + str(i)) as Label
		else:
			label = potion_inventory_panel.get_node("Label0").duplicate(14) as Label
			label.name = "Label" + str(i)
			potion_inventory_panel.add_child(label)
		if !label.is_connected("mouse_entered", Callable(self, "_show_potion_tooltip")):
			label.connect("mouse_entered", Callable(self, "_show_potion_tooltip").bind(i))
		label.text = str(potions.values()[i]) + "x " + _name
		label.add_theme_color_override("font_color", Items.RANK_COLORS[item.rank])
		label.show()

func update_story_inventory(inventory: Array[ItemQuest]) -> void:
	for c in story_inventory_panel.get_children():
		(c as Control).hide()
	story_inventory = inventory
	
	for i in range(inventory.size()):
		var label: Label
		if story_inventory_panel.has_node("Label" + str(i)):
			label = story_inventory_panel.get_node("Label" + str(i)) as Label
		else:
			label = story_inventory_panel.get_node("Label0").duplicate(14) as Label
			label.name = "Label" + str(i)
			story_inventory_panel.add_child(label)
		if !label.is_connected("mouse_entered", Callable(self, "_show_story_inventory_tooltip")):
			label.connect("mouse_entered", Callable(self, "_show_story_inventory_tooltip").bind(i))
		if inventory[i].amount != 1:
			label.text = str(inventory[i].amount) + "x " + inventory[i].name
		else:
			label.text = inventory[i].name
		label.show()

# Tooltips

func _show_inventory_tooltip(item: Dictionary) -> void:
	if tooltip == null:
		return
	
	if "story" in item:
		if "component_description" in item:
			tooltip.show_texts([item.description, item.story, item.component_description], [tr("PROPERTIES"), tr("DESCRIPTION"), tr("COMPONENTS")])
		else:
			tooltip.show_texts([item.description, item.story], [tr("PROPERTIES"), tr("DESCRIPTION")])
	elif "component_description" in item:
		tooltip.show_texts([item.description, item.component_description], [tr("PROPERTIES"), tr("COMPONENTS")])
	else:
		tooltip.show_text(item.description)

func _show_potion_tooltip(index: int) -> void:
	if tooltip == null or index >= potion_inventory.size():
		return
	
	var item: Dictionary = potion_inventory[index]
	tooltip.show_text(item.description)

func _show_story_inventory_tooltip(index: int) -> void:
	if tooltip == null or index >= story_inventory.size():
		return
	
	var item: Dictionary = story_inventory[index]
	tooltip.show_text(item.description)
