extends Panel

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


func update(locations: Array[Dictionary], region_name: String, region_description: String,
		current_location: String):
	for c in $ScrollContainer/VBoxContainer.get_children():
		c.hide()
	
	$ScrollContainer/VBoxContainer/Label.text = region_name
	$ScrollContainer/VBoxContainer/Label.tooltip_text = region_description
	$ScrollContainer/VBoxContainer/Label.show()
	for i in range(locations.size()):
		var location:= locations[i]
		var container: HBoxContainer
		if has_node("ScrollContainer/VBoxContainer/Location" + str(i)):
			container = get_node("ScrollContainer/VBoxContainer/Location" + str(i))
		else:
			container = $ScrollContainer/VBoxContainer/Location0.duplicate(14)
			container.name = "Location" + str(i)
			$ScrollContainer/VBoxContainer.add_child(container)
		
		container.get_node("Label").text = location.name
		container.get_node("Inactive").visible = location.name != current_location
		container.get_node("Staying").visible = location.name == current_location
		container.get_node("Icon").texture = icons.get(location.type, icons.settlement)
		container.show()
	
