extends Control

const MAX_ABILITIES = 2
const MATERIALS = {
	"metal":{
		"name":"rusty",
		"quality":0.4,
	},
	"wood":{
		"name":"broken",
		"quality":0.4,
	},
	"cloth":{
		"name":"old",
		"quality":0.4,
	},
	"leather":{
		"name":"old",
		"quality":0.4,
	},
}
const RACE_STATS = {
	"human":{},
	"halfling":{
		"dexterity":4,
		"strength":-4,
		"intelligence":-2,
		"wisdom":-1,
		"cunning":3,
	},
	"high_elf":{
		"constitution":-4,
		"intelligence":4,
		"wisdom":2,
		"cunning":-2,
	},
	"wood_elf":{
		"dexterity":4,
		"constitution":-4,
		"intelligence":-2,
		"cunning":2,
	},
	"dwarf":{
		"strength":2,
		"constitution":4,
		"dexterity":-2,
		"intelligence":-4,
	},
	"ogre":{
		"strength":6,
		"constitution":6,
		"dexterity":-4,
		"wisdom":-2,
		"intelligence":-2,
		"cunning":-4,
	},
	
}

var player_name: String
var player_gender:= "None"
var player_race: String
var player_alt_race: String
var player_abilities:= []
var player_combat_abilities:= []
var hybrid_race:= false
var player_vegan:= false

var main:= preload("res://gui/main.tscn")



func _name_changed(new_text: String):
	player_name = new_text
	set_overwrite_warning()

func _set_gender(new_text: String):
	player_gender = new_text



func _hybrid_race_toggled(button_pressed: bool):
	hybrid_race = button_pressed
	if !hybrid_race:
		player_alt_race = ""
	$HBoxContainer/VBoxContainer1/Race/VBoxContainer/HBoxContainer/Alt.visible = hybrid_race

func _race_toggled(button_pressed: bool, race: String):
	if button_pressed:
		player_race = race
		for c in $HBoxContainer/VBoxContainer1/Race/VBoxContainer/HBoxContainer/Main.get_children():
			if !(c is Button) || c.name==player_race:
				continue
			c.set_pressed_no_signal(false)
	$HBoxContainer/VBoxContainer1/Race/VBoxContainer/HBoxContainer/Main/LineEdit/CheckButton.set_pressed_no_signal(false)

func _alt_race_toggled(button_pressed: bool, race: String):
	if !hybrid_race:
		return
	if button_pressed:
		player_alt_race = race
		for c in $HBoxContainer/VBoxContainer1/Race/VBoxContainer/HBoxContainer/Alt.get_children():
			if !(c is Button) || c.name==player_alt_race:
				continue
			c.set_pressed_no_signal(false)
	$HBoxContainer/VBoxContainer1/Race/VBoxContainer/HBoxContainer/Main/LineEdit/CheckButton.set_pressed_no_signal(false)

func _set_custom_race(string: String):
	hybrid_race = false
	$HBoxContainer/VBoxContainer1/Race/VBoxContainer/HBoxContainer/Alt.hide()
	player_race = string
	player_alt_race = ""
	for c in $HBoxContainer/VBoxContainer1/Race/VBoxContainer/HBoxContainer/Main.get_children():
		if !(c is Button):
			continue
		c.set_pressed_no_signal(false)
	$HBoxContainer/VBoxContainer1/Race/VBoxContainer/HBoxContainer/Main/LineEdit/CheckButton.set_pressed_no_signal(true)

func _custom_race_toggled(toggled_on: bool):
	if toggled_on:
		_set_custom_race($HBoxContainer/VBoxContainer1/Race/VBoxContainer/HBoxContainer/Main/LineEdit.text)
	else:
		player_race = ""
		player_alt_race = ""

func _vegan_toggled(button_pressed: bool):
	player_vegan = button_pressed

func _ability_toggled(button_pressed: bool, type: String):
	if player_abilities.size()>=MAX_ABILITIES && !(type in player_abilities):
		for c in $HBoxContainer/VBoxContainer3/Abilities/VBoxContainer.get_children():
			if !(c is Button) || c.name in player_abilities:
				continue
			c.set_pressed_no_signal(false)
		return
	if button_pressed:
		player_abilities.push_back(type)
	else:
		player_abilities.erase(type)
	$HBoxContainer/VBoxContainer3/Abilities/VBoxContainer/LabelNumber.text = str(player_abilities.size()) + "/" + str(MAX_ABILITIES)

func _combat_ability_toggled(button_pressed: bool, type: String):
	if player_combat_abilities.size()>=MAX_ABILITIES && !(type in player_combat_abilities):
		for c in $HBoxContainer/VBoxContainer2/Combat/VBoxContainer.get_children():
			if !(c is Button) || c.name in player_combat_abilities:
				continue
			c.set_pressed_no_signal(false)
		return
	if button_pressed:
		player_combat_abilities.push_back(type)
	else:
		player_combat_abilities.erase(type)
	$HBoxContainer/VBoxContainer2/Combat/VBoxContainer/LabelNumber.text = str(player_combat_abilities.size()) + "/" + str(MAX_ABILITIES)

func _randomize():
	var button = $HBoxContainer/VBoxContainer1/Race/VBoxContainer/HBoxContainer/Main.get_child(randi()%$HBoxContainer/VBoxContainer1/Race/VBoxContainer/HBoxContainer/Main.get_child_count())
	var gender:= 2*(randi()%2)-1
	var race: String
	$HBoxContainer/VBoxContainer1/Race/VBoxContainer/CheckButton.button_pressed = false
	if button is BaseButton:
		button.button_pressed = true
	race = player_race
	if "_" in race && "elf" in race:
		race = "elf"
	$HBoxContainer/VBoxContainer1/Gender/VBoxContainer/LineEdit.text = tr({-1:"MALE",1:"FEMALE"}[gender])
	$HBoxContainer/VBoxContainer1/Name/VBoxContainer/LineEdit.text = Names.create_name(race, gender)
	_name_changed($HBoxContainer/VBoxContainer1/Name/VBoxContainer/LineEdit.text)
	for c in $HBoxContainer/VBoxContainer2/Combat/VBoxContainer.get_children():
		if c is BaseButton:
			c.button_pressed = false
	for c in $HBoxContainer/VBoxContainer3/Abilities/VBoxContainer.get_children():
		if c is BaseButton:
			c.button_pressed = false
	for i in range(2):
		button = $HBoxContainer/VBoxContainer2/Combat/VBoxContainer.get_child(randi()%$HBoxContainer/VBoxContainer2/Combat/VBoxContainer.get_child_count())
		while !(button is BaseButton && !button.button_pressed):
			button = $HBoxContainer/VBoxContainer2/Combat/VBoxContainer.get_child(randi()%$HBoxContainer/VBoxContainer2/Combat/VBoxContainer.get_child_count())
		button.button_pressed = true
	for i in range(2):
		button = $HBoxContainer/VBoxContainer3/Abilities/VBoxContainer.get_child(randi()%$HBoxContainer/VBoxContainer3/Abilities/VBoxContainer.get_child_count())
		while !(button is BaseButton && !button.button_pressed):
			button = $HBoxContainer/VBoxContainer3/Abilities/VBoxContainer.get_child(randi()%$HBoxContainer/VBoxContainer3/Abilities/VBoxContainer.get_child_count())
		button.button_pressed = true

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

func set_overwrite_warning():
	$HBoxContainer/VBoxContainer1/Name/VBoxContainer/Label/LabelWarning.visible = check_character_existance()


func start_game():
	if player_name.length()==0 || player_race.length()==0 || player_abilities.size()!=MAX_ABILITIES || player_combat_abilities.size()!=MAX_ABILITIES:
		return
	
	player_abilities += player_combat_abilities
	
	var main_instance: Node = main.instantiate()
	var player_stats:= Characters.DEFAULT_STATS.duplicate()
	var player_equipment:= []
	var magical:= "elemental_magic" in player_abilities || "nature_magic" in player_abilities || "celestial_magic" in player_abilities || "defensive_magic" in player_abilities
	var healer:= "healing" in player_abilities && !magical
	main_instance.player_name = player_name
	if player_race==player_alt_race:
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
			for k in RACE_STATS[player_race].keys():
				player_stats[k] += RACE_STATS[player_race][k]/2
		for k in RACE_STATS[player_alt_race].keys():
			player_stats[k] += RACE_STATS[player_alt_race][k]/2
	elif RACE_STATS.has(player_race):
		for k in RACE_STATS[player_race].keys():
			player_stats[k] += RACE_STATS[player_race][k]
	main_instance.player_ability_exp = {}
	for k in player_abilities:
		main_instance.player_ability_exp[k] = 0
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
	
	main_instance.player = Characters.Character.new({
		"name":player_name,
		"level":1,
		"experience":0,
		"stats":player_stats,
		"abilities":player_abilities,
		"delay":0.0,
	})
	main_instance.player.recover()
	main_instance.learn_new_skill("strike", true)
	for i in range(2):
		main_instance.learn_new_skill()
	for type in player_equipment:
		var item:= Items.create_random_standard_equipment(type, {"level":1,"tier":0,"local_materials":{}})
		if Items.EQUIPMENT_RECIPES[type].has("name"):
			item.source = tr("OLD_ITEM").format({"name":tr(Items.EQUIPMENT_RECIPES[type].name.to_upper())})
		else:
			item.source = tr("OLD_ITEM").format({"name":tr(type.to_upper())})
		item.description = Items.create_tooltip(item)
		main_instance.equip(item)
	
	if "elf" in player_race && (player_alt_race=="" || "elf" in player_alt_race):
		main_instance.set_region("elven_forest")
	elif "dwarf" in player_race || "dwarf" in player_alt_race:
		main_instance.set_region("dwarven_mine")
	else:
		main_instance.set_region("farmland")
	main_instance.current_location = main_instance.current_region.cities[0]
	main_instance.join_guild("adventurer_guild")
	main_instance.current_time = Time.get_unix_time_from_system()
	main_instance.player_vegan = player_vegan
	main_instance.player_creation_time = main_instance.current_time
	
	get_parent().add_child(main_instance)
	main_instance._save()
	queue_free()


func _back_to_menu():
	get_tree().change_scene_to_file("res://gui/menu.tscn")
