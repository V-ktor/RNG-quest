extends Panel

@export
var tooltip: Control

var icons:= {
	"settlement": preload("res://images/gui/tent.svg"),
	"town": preload("res://images/gui/house.svg"),
	"outpost": preload("res://images/gui/tower.svg"),
	"castle": preload("res://images/gui/castle.svg"),
	"slum": preload("res://images/gui/tent.svg"),
	"graveyard": preload("res://images/gui/tomb_stone.svg"),
	"dungeon": preload("res://images/gui/dungeon.svg"),
	"river": preload("res://images/gui/river.svg"),
	"cave": preload("res://images/gui/cave.svg"),
	"dunes": preload("res://images/gui/dunes.svg"),
	"coast": preload("res://images/gui/coast.svg"),
	"field": preload("res://images/gui/field.svg"),
	"factory": preload("res://images/gui/factory.svg"),
	"sea": preload("res://images/gui/sea.svg"),
	"mountain": preload("res://images/gui/mountain.svg"),
	"volcano": preload("res://images/gui/volcano.svg"),
	"forest": preload("res://images/gui/tree.svg"),
	"swamp": preload("res://images/gui/swamp.svg"),
	"floating_island": preload("res://images/gui/floating_island.svg"),
	"cloud": preload("res://images/gui/cloud.svg"),
}
var colors:= {
	"settlement": Color(0.2, 0.8, 0.2),
	"town": Color(0.2, 0.8, 0.2),
	"castle": Color(0.2, 0.8, 0.2),
	"graveyard": Color(0.7, 0.6, 0.1),
	"dungeon": Color(0.7, 0.6, 0.1),
	"river": Color(0.7, 0.6, 0.1),
	"cave": Color(0.7, 0.6, 0.1),
	"dunes": Color(0.7, 0.6, 0.1),
	"coast": Color(0.7, 0.6, 0.1),
	"field": Color(0.7, 0.6, 0.1),
	"factory": Color(0.7, 0.6, 0.1),
	"sea": Color(0.7, 0.6, 0.1),
	"mountain": Color(0.7, 0.6, 0.1),
	"volcano": Color(0.7, 0.6, 0.1),
	"forest": Color(0.7, 0.6, 0.1),
	"swamp": Color(0.7, 0.6, 0.1),
	"floating_island": Color(0.7, 0.6, 0.1),
	"cloud": Color(0.7, 0.6, 0.1),
}
var region_description:= ""
var location_descriptions: Array[String] = []


func update(locations: Array[Dictionary], region_name: String, description: String,
		current_location: String):
	for c in $ScrollContainer/VBoxContainer.get_children():
		c.hide()
	
	region_description = description
	location_descriptions.resize(locations.size())
	
	$ScrollContainer/VBoxContainer/Label.text = region_name
	$ScrollContainer/VBoxContainer/Label.show()
	for i in range(locations.size()):
		var location:= locations[i]
		var container: HBoxContainer
		var color: Color = Color(0.5, 0.5, 0.5)
		if location.type in colors:
			color = colors[location.type]
		if has_node("ScrollContainer/VBoxContainer/Location" + str(i)):
			container = get_node("ScrollContainer/VBoxContainer/Location" + str(i))
		else:
			container = $ScrollContainer/VBoxContainer/Location0.duplicate(14)
			container.name = "Location" + str(i)
			$ScrollContainer/VBoxContainer.add_child(container)
		
		if !container.is_connected("mouse_entered", Callable(self, "_show_location_tooltip")):
			container.connect("mouse_entered", Callable(self, "_show_location_tooltip").bind(i))
		location_descriptions[i] = location.name + "\n" + tr(location.type.to_upper())
		
		(container.get_node("Label") as Label).text = location.name
		(container.get_node("Label") as Label).add_theme_color_override("font_color", color)
		container.get_node("Inactive").visible = location.name != current_location
		container.get_node("Staying").visible = location.name == current_location
		(container.get_node("Icon") as TextureRect).texture = icons.get(location.type, icons.settlement)
		(container.get_node("Icon") as TextureRect).modulate = color
		container.show()


func _show_region_tooltip():
	if tooltip == null:
		return
	
	tooltip.show_text(region_description)


func _show_location_tooltip(index: int):
	if tooltip == null:
		return
	
	tooltip.show_text(location_descriptions[index])
