extends Panel

@export
var tooltip: Control

var main_inventory: Array
var potion_inventory: Array
var story_inventory: Array

@onready
var inventory_panel: VBoxContainer = $ScrollContainer/VBoxContainer/Inventory
@onready
var potion_inventory_panel: VBoxContainer = $ScrollContainer/VBoxContainer/Potions
@onready
var story_inventory_panel: VBoxContainer = $ScrollContainer/VBoxContainer/Quest


func summarize_inventory(array: Array) -> Dictionary:
	var dict:= {}
	for item in array:
		if dict.has(item.name):
			dict[item.name] += 1
		else:
			dict[item.name] = 1
	return dict

func update_inventory(inventory: Array):
	var items:= summarize_inventory(inventory)
	main_inventory = inventory
	
	for c in inventory_panel.get_children():
		c.hide()
	
	for i in range(items.size()):
		var label: Label
		var item: Dictionary
		var item_name: String = items.keys()[i]
		for it in inventory:
			if it.name==item_name:
				item = it
				break
		if inventory_panel.has_node("Label" + str(i)):
			label = inventory_panel.get_node("Label" + str(i))
		else:
			label = inventory_panel.get_node("Label0").duplicate(14)
			label.name = "Label" + str(i)
			inventory_panel.add_child(label)
		if label.is_connected("mouse_entered", Callable(self, "_show_inventory_tooltip")):
			label.disconnect("mouse_entered", Callable(self, "_show_inventory_tooltip"))
		label.connect("mouse_entered", Callable(self, "_show_inventory_tooltip").bind(item))
		label.text = str(items.values()[i]) + "x " + item_name
		if !item.has("description"):
			item.description = Items.create_tooltip(item)
			item.description_plain = Skills.tooltip_remove_bb_code(item.description)
		if "rank" not in item:
			item.rank = Items.get_item_rank(item)
		label.modulate = Items.RANK_COLORS[item.rank]
		label.show()

func update_potion_inventory(inventory: Array):
	var potions:= summarize_inventory(inventory)
	potion_inventory = inventory
	
	for c in potion_inventory_panel.get_children():
		c.hide()
	
	for i in range(potions.size()):
		var label: Label
		var item: Dictionary
		var _name: String = potions.keys()[i]
		for it in inventory:
			if it.name==_name:
				item = it
				break
		if potion_inventory_panel.has_node("Label" + str(i)):
			label = potion_inventory_panel.get_node("Label" + str(i))
		else:
			label = potion_inventory_panel.get_node("Label0").duplicate(14)
			label.name = "Label" + str(i)
			potion_inventory_panel.add_child(label)
		if !label.is_connected("mouse_entered", Callable(self, "_show_potion_tooltip")):
			label.connect("mouse_entered", Callable(self, "_show_potion_tooltip").bind(i))
		label.text = str(potions.values()[i]) + "x " + _name
		if "rank" not in item:
			item.rank = Items.get_item_rank(item)
		label.modulate = Items.RANK_COLORS[item.rank]
		label.show()

func update_story_inventory(inventory: Array):
	for c in story_inventory_panel.get_children():
		c.hide()
	story_inventory = inventory
	
	for i in range(inventory.size()):
		var label: Label
		if story_inventory_panel.has_node("Label" + str(i)):
			label = story_inventory_panel.get_node("Label" + str(i))
		else:
			label = story_inventory_panel.get_node("Label0").duplicate(14)
			label.name = "Label" + str(i)
			story_inventory_panel.add_child(label)
		if !label.is_connected("mouse_entered", Callable(self, "_show_story_inventory_tooltip")):
			label.connect("mouse_entered", Callable(self, "_show_story_inventory_tooltip").bind(i))
		if inventory[i].amount!=1:
			label.text = str(inventory[i].amount) + "x " + inventory[i].name
		else:
			label.text = inventory[i].name
		label.show()

# Tooltips

func _show_inventory_tooltip(item: Dictionary):
	if tooltip == null:
		return
	
	if "component_description" in item:
		tooltip.show_texts([item.description, item.component_description], [tr("PROPERTIES"), tr("COMPONENTS")])
	else:
		tooltip.show_text(item.description)

func _show_potion_tooltip(index: int):
	if tooltip == null:
		return
	
	var item: Dictionary = potion_inventory[index]
	tooltip.show_text(item.description)

func _show_story_inventory_tooltip(index: int):
	if tooltip == null:
		return
	
	var item: Dictionary = story_inventory[index]
	tooltip.show_text(item.description)
