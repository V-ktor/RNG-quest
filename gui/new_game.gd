extends Control
class_name NewGameUi

const MAX_ABILITIES := 2
const MATERIALS: Dictionary[String, Dictionary] = {
	"metal": {
		"name": "rusty",
		"quality": 0.4,
	},
	"wood": {
		"name": "broken",
		"quality": 0.4,
	},
	"cloth": {
		"name": "old",
		"quality": 0.4,
	},
	"leather": {
		"name": "old",
		"quality": 0.4,
	},
}
const RACE_STATS: Dictionary[String, Dictionary] = {
	"human": {},
	"halfling": {
		"dexterity": 4,
		"strength": -4,
		"intelligence": -2,
		"wisdom": -1,
		"cunning": 3,
	},
	"high_elf": {
		"constitution": -4,
		"intelligence": 4,
		"wisdom": 2,
		"cunning": -2,
	},
	"wood_elf": {
		"dexterity": 4,
		"constitution": -4,
		"intelligence": -2,
		"cunning": 2,
	},
	"dwarf": {
		"strength": 2,
		"constitution": 4,
		"dexterity": -2,
		"intelligence": -4,
	},
	"ogre": {
		"strength": 6,
		"constitution": 6,
		"dexterity": -4,
		"wisdom": -2,
		"intelligence": -2,
		"cunning": -4,
	},
}

var player_name: String
var player_gender := "None"
var player_race: String
var player_alt_race: String
var player_abilities: Array[String] = []
var player_combat_abilities: Array[String] = []
var hybrid_race:= false
var player_vegan:= false
var version: String

var main := preload("res://scenes/main/main.tscn")
var main_gui := preload("res://gui/main/scenes/main_gui.tscn")



func _name_changed(new_text: String) -> void:
	player_name = new_text
	set_overwrite_warning()

func _set_gender(new_text: String) -> void:
	player_gender = new_text



func _hybrid_race_toggled(button_pressed: bool) -> void:
	hybrid_race = button_pressed
	if !hybrid_race:
		player_alt_race = ""
	($HBoxContainer/VBoxContainer1/Race/VBoxContainer/HBoxContainer/Alt as Control).visible = hybrid_race

func _race_toggled(button_pressed: bool, race: String) -> void:
	if button_pressed:
		player_race = race
		for c in $HBoxContainer/VBoxContainer1/Race/VBoxContainer/HBoxContainer/Main.get_children():
			if c is not Button || c.name == player_race:
				continue
			(c as Button).set_pressed_no_signal(false)
	($HBoxContainer/VBoxContainer1/Race/VBoxContainer/HBoxContainer/Main/LineEdit/CheckButton as Button).set_pressed_no_signal(false)

func _alt_race_toggled(button_pressed: bool, race: String) -> void:
	if !hybrid_race:
		return
	if button_pressed:
		player_alt_race = race
		for c in $HBoxContainer/VBoxContainer1/Race/VBoxContainer/HBoxContainer/Alt.get_children():
			if c is not Button || c.name == player_alt_race:
				continue
			(c as Button).set_pressed_no_signal(false)
	($HBoxContainer/VBoxContainer1/Race/VBoxContainer/HBoxContainer/Main/LineEdit/CheckButton as Button).set_pressed_no_signal(false)

func _set_custom_race(string: String) -> void:
	hybrid_race = false
	($HBoxContainer/VBoxContainer1/Race/VBoxContainer/HBoxContainer/Alt as Control).hide()
	player_race = string
	player_alt_race = ""
	for c in $HBoxContainer/VBoxContainer1/Race/VBoxContainer/HBoxContainer/Main.get_children():
		if c is not Button:
			continue
		(c as Button).set_pressed_no_signal(false)
	($HBoxContainer/VBoxContainer1/Race/VBoxContainer/HBoxContainer/Main/LineEdit/CheckButton as Button).set_pressed_no_signal(true)

func _custom_race_toggled(toggled_on: bool) -> void:
	if toggled_on:
		_set_custom_race(($HBoxContainer/VBoxContainer1/Race/VBoxContainer/HBoxContainer/Main/LineEdit as LineEdit).text)
	else:
		player_race = ""
		player_alt_race = ""

func _vegan_toggled(button_pressed: bool) -> void:
	player_vegan = button_pressed

func _ability_toggled(button_pressed: bool, type: String) -> void:
	if player_abilities.size() >= MAX_ABILITIES && type not in player_abilities:
		for c in $HBoxContainer/VBoxContainer3/Abilities/VBoxContainer.get_children():
			if c is not Button || c.name in player_abilities:
				continue
			(c as Button).set_pressed_no_signal(false)
		return
	if button_pressed:
		player_abilities.push_back(type)
	else:
		player_abilities.erase(type)
	($HBoxContainer/VBoxContainer3/Abilities/VBoxContainer/LabelNumber as Label).text = str(player_abilities.size()) + "/" + str(MAX_ABILITIES)

func _combat_ability_toggled(button_pressed: bool, type: String) -> void:
	if player_combat_abilities.size() >= MAX_ABILITIES && type not in player_combat_abilities:
		for c in $HBoxContainer/VBoxContainer2/Combat/VBoxContainer.get_children():
			if !(c is Button) || c.name in player_combat_abilities:
				continue
			(c as Button).set_pressed_no_signal(false)
		return
	if button_pressed:
		player_combat_abilities.push_back(type)
	else:
		player_combat_abilities.erase(type)
	($HBoxContainer/VBoxContainer2/Combat/VBoxContainer/LabelNumber as Label).text = str(player_combat_abilities.size()) + "/" + str(MAX_ABILITIES)

func _randomize() -> void:
	var button := $HBoxContainer/VBoxContainer1/Race/VBoxContainer/HBoxContainer/Main.get_child(randi()%$HBoxContainer/VBoxContainer1/Race/VBoxContainer/HBoxContainer/Main.get_child_count()) as Button
	var gender := 2 * (randi()%2) - 1
	var race: String
	($HBoxContainer/VBoxContainer1/Race/VBoxContainer/CheckButton as Button).button_pressed = false
	if button is BaseButton:
		button.button_pressed = true
	race = player_race
	if "_" in race && "elf" in race:
		race = "elf"
	($HBoxContainer/VBoxContainer1/Gender/VBoxContainer/LineEdit as LineEdit).text = tr({-1: "MALE", 1: "FEMALE"}[gender] as String)
	($HBoxContainer/VBoxContainer1/Name/VBoxContainer/LineEdit as LineEdit).text = Names.create_name(race, gender)
	_name_changed(($HBoxContainer/VBoxContainer1/Name/VBoxContainer/LineEdit as LineEdit).text)
	for c in $HBoxContainer/VBoxContainer2/Combat/VBoxContainer.get_children():
		if c is BaseButton:
			(c as BaseButton).button_pressed = false
	for c in $HBoxContainer/VBoxContainer3/Abilities/VBoxContainer.get_children():
		if c is BaseButton:
			(c as BaseButton).button_pressed = false
	for i in range(2):
		var node := $HBoxContainer/VBoxContainer2/Combat/VBoxContainer.get_child(randi()%$HBoxContainer/VBoxContainer2/Combat/VBoxContainer.get_child_count())
		while node is not BaseButton or node.button_pressed:
			node = $HBoxContainer/VBoxContainer2/Combat/VBoxContainer.get_child(randi()%$HBoxContainer/VBoxContainer2/Combat/VBoxContainer.get_child_count())
		(node as BaseButton).button_pressed = true
	for i in range(2):
		var node := $HBoxContainer/VBoxContainer3/Abilities/VBoxContainer.get_child(randi()%$HBoxContainer/VBoxContainer3/Abilities/VBoxContainer.get_child_count())
		while node is not BaseButton or node.button_pressed:
			node = $HBoxContainer/VBoxContainer3/Abilities/VBoxContainer.get_child(randi()%$HBoxContainer/VBoxContainer3/Abilities/VBoxContainer.get_child_count())
		(node as BaseButton).button_pressed = true

func check_character_existance() -> bool:
	var dir:= DirAccess.open("user://saves")
	if dir==null || DirAccess.get_open_error()!=OK:
		print("Can't open save dir!")
		return false
	
	var file_name: String
	dir.list_dir_begin()
	file_name = dir.get_next()
	while file_name!="":
		file_name = file_name.left(file_name.rfind('.'))
		if player_name==file_name:
			return true
		file_name = dir.get_next()
	return false

func set_overwrite_warning() -> void:
	($HBoxContainer/VBoxContainer1/Name/VBoxContainer/Label/LabelWarning as Control).visible = check_character_existance()


func start_game() -> void:
	if player_name.length() == 0 || player_race.length() == 0 || player_abilities.size() != MAX_ABILITIES || player_combat_abilities.size() != MAX_ABILITIES:
		return
	
	player_abilities += player_combat_abilities
	
	var main_instance := main.instantiate() as Main
	var player_stats:= Characters.DEFAULT_STATS.duplicate()
	var player_equipment: Array[String] = []
	var magical:= "elemental_magic" in player_abilities || "nature_magic" in player_abilities || "celestial_magic" in player_abilities || "defensive_magic" in player_abilities
	var healer:= "healing" in player_abilities && !magical
	main_instance.version = version
	main_instance.player_name = player_name
	main_instance.current_time = Time.get_unix_time_from_system()
	main_instance.player_creation_time = floori(main_instance.current_time)
	if player_race == player_alt_race:
		player_alt_race = ""
		hybrid_race = false
	if player_alt_race!="":
		main_instance.player_race = tr(player_race.to_upper()) + " / " + tr(player_alt_race.to_upper()) + " (" + player_gender + ")"
	elif RACE_STATS.has(player_race):
		main_instance.player_race = tr(player_race.to_upper()) + " (" + player_gender + ")"
	else:
		main_instance.player_race = player_race + " (" + player_gender + ")"
	if RACE_STATS.has(player_alt_race):
		if RACE_STATS.has(player_race):
			for k: String in RACE_STATS[player_race]:
				player_stats[k] += RACE_STATS[player_race][k]/2
		for k: String in RACE_STATS[player_alt_race]:
			player_stats[k] += RACE_STATS[player_alt_race][k]/2
	elif RACE_STATS.has(player_race):
		for k: String in RACE_STATS[player_race]:
			player_stats[k] += RACE_STATS[player_race][k]
	if "heavy_weapons" in player_abilities:
		if "light_weapons" in player_abilities || "shield" in player_abilities || "archery" in player_abilities || magical || healer:
			player_equipment.push_back("axe")
		else:
			player_equipment.push_back("greatsword")
	if "light_weapons" in player_abilities || "dirty_fighting" in player_abilities:
		if "heavy_weapons" in player_abilities || "shield" in player_abilities || "archery" in player_abilities || magical || healer:
			player_equipment.push_back("sword")
		else:
			player_equipment += ["dagger", "dagger"]
	if "archery" in player_abilities:
		if "heavy_weapons" in player_abilities || "light_weapons" in player_abilities || "shield" in player_abilities || magical || healer:
			player_equipment.push_back("sling")
		else:
			player_equipment.push_back("bow")
	if magical:
		if "heavy_weapons" in player_abilities || "light_weapons" in player_abilities || "shield" in player_abilities || "archery" in player_abilities:
			player_equipment.push_back("tome")
		else:
			player_equipment.push_back("magestaff")
	if healer:
		if "heavy_weapons" in player_abilities || "light_weapons" in player_abilities || "shield" in player_abilities || "archery" in player_abilities:
			player_equipment.push_back("orb")
		else:
			player_equipment.push_back("quarterstaff")
	if "shield" in player_abilities:
		player_equipment.push_back("buckler")
	if "armour" in player_abilities && "evasion" in player_abilities:
		player_equipment += ["leather_chest","leather_pants","leather_hat","leather_boots","leather_gloves"]
	elif "armour" in player_abilities:
		if ("shield" in player_abilities || "heavy_weapons" in player_abilities) && !("defensive_magic" in player_abilities):
			player_equipment += ["plate_cuirass","plate_greaves","plate_helm","plate_boots","plate_gauntlets"]
		else:
			player_equipment += ["chain_cuirass","chain_greaves","chain_coif","chain_boots","chain_gauntlets"]
	elif "evasion" in player_abilities:
		player_equipment += ["leather_chest","leather_pants","cloth_hat","cloth_sandals","cloth_sleeves"]
	else:
		player_equipment += ["cloth_shirt","cloth_pants","cloth_hat","cloth_sandals","cloth_sleeves"]
	
	var ability_dict:= {}
	for ability in player_abilities:
		ability_dict[ability] = {
			"name": ability,
			"level": 1,
			"experience": 0,
		}
	
	main_instance.player = Characters.Character.new({
		"name": player_name,
		"level": 1,
		"experience": 0,
		"stats": player_stats,
		"abilities": ability_dict,
		"delay": 0.0,
	})
	main_instance.player.recover()
	main_instance.learn_new_skill("strike", true)
	for i in range(2):
		main_instance.learn_new_skill()
	for type in player_equipment:
		var item:= Items.create_random_standard_equipment(type, Region.new({
			"level": 1,
			"tier": 0,
			"local_materials": {},
		}))
		if Items.equipment_recipes[type].has("name"):
			item.source = tr("OLD_ITEM").format({
				"name": tr((Items.equipment_recipes[type].name as String).to_upper()),
			})
		else:
			item.source = tr("OLD_ITEM").format({
				"name":tr(type.to_upper()),
			})
		item.description = item.create_tooltip()
		item.component_description = item.create_component_tooltip()
		item.story = item.create_description()
		main_instance.equip(item)
	
	if "elf" in player_race && (player_alt_race == "" || "elf" in player_alt_race):
		main_instance.set_region("elven_forest")
	elif "dwarf" in player_race || "dwarf" in player_alt_race:
		main_instance.set_region("dwarven_mine")
	else:
		main_instance.set_region("farmland")
	main_instance.current_location = main_instance.current_region.cities.keys().pick_random()
	main_instance.player_vegan = player_vegan
	main_instance.store_historical_data("level", main_instance.player.level)
	for k in player_abilities:
		main_instance.store_historical_data("abilities", main_instance.player.abilities[k].level, k)
	for stat in main_instance.player.stats:
		main_instance.store_historical_data("stats", main_instance.player.stats[stat], stat)
	get_parent().add_child(main_instance)
	
	var main_gui_instance := main_gui.instantiate() as MainGui
	main_gui_instance.theme = theme
	get_parent().add_child(main_gui_instance)
	main_gui_instance.connect_to_main(main_instance)
	
	main_instance._save()
	queue_free()


func _back_to_menu() -> void:
	get_tree().change_scene_to_file("res://gui/menu.tscn")
	queue_free()
