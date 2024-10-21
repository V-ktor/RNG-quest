extends CanvasLayer

var main_character: Characters.Character
var main_character_settings: Characters.CharacterSettings
var timetable: Dictionary
var characters_player: Array[Characters.Character] = []
var characters_enemy: Array[Characters.Character] = []

@onready
var title_label:= $Title/Label
@onready
var tooltip:= $Tooltip
@onready
var player_panel: Control = $Overview/Player
@onready
var enemy_panel: Control = $Overview/Enemy
@onready
var stat_chart: Control = $Character/Stats/Stats/Chart
@onready
var attribute_panel: Control = $Character/Stats/Attributes
@onready
var mod_panel: Control = $Character/Stats/Mods
@onready
var ability_panel: Control = $Character/Skills/Abilities
@onready
var skill_panel: Control = $Character/Skills/Skills
@onready
var equipment_panel: Control = $Character/Equipment/Equipment
@onready
var inventory_panel: Control = $Journal/Inventory
@onready
var gold_label: Label = $Journal/Inventory/ScrollContainer/VBoxContainer/LabelGold
@onready
var skill_module_panel: Control = $Options/SkillModules/SkillModules
@onready
var weapon_preference_panel: Control = $Options/Preferences/WeaponPreference
@onready
var armour_preference_panel: Control = $Options/Preferences/ArmourPreference
@onready
var potion_preference_panel: Control = $Options/Preferences/PotionPreference
@onready
var location_label: RichTextLabel = $Overview/HBoxContainer/Location/RichTextLabel


signal settings_changed


func _settings_changed():
	emit_signal("settings_changed")

func _toggle_1h_weapons(button_pressed: bool):
	main_character_settings.auto_update_options = false
	main_character_settings.weapon_1h_alowed = button_pressed
	emit_signal("settings_changed")

func _toggle_2h_weapons(button_pressed: bool):
	main_character_settings.auto_update_options = false
	main_character_settings.weapon_2h_alowed = button_pressed
	emit_signal("settings_changed")

func _toggle_weapon_type(button_pressed: bool, type: String):
	main_character_settings.auto_update_options = false
	if button_pressed:
		if !main_character_settings.valid_weapon_types.has(type):
			main_character_settings.valid_weapon_types.push_back(type)
	else:
		main_character_settings.valid_weapon_types.erase(type)
	emit_signal("settings_changed")

func _toggle_armour_type(button_pressed: bool, type: String):
	main_character_settings.auto_update_options = false
	if button_pressed:
		if !main_character_settings.valid_armour_types.has(type):
			main_character_settings.valid_armour_types.push_back(type)
	else:
		main_character_settings.valid_armour_types.erase(type)
	emit_signal("settings_changed")

func _toggle_potion_type(button_pressed: bool, type: String):
	main_character_settings.auto_update_options = false
	if button_pressed:
		if !main_character_settings.valid_potion_types.has(type):
			main_character_settings.valid_potion_types.push_back(type)
	else:
		main_character_settings.valid_potion_types.erase(type)
	emit_signal("settings_changed")


func _side_menu_expand_toggled(toggled_on: bool):
	if toggled_on:
		$SideMenu.offset_right = 128
		$Title.offset_left = 128
		$Title.offset_right = 192
	else:
		$SideMenu.offset_right = 58
		$Title.offset_left = 58
		$Title.offset_right = 128
	$SideMenu/VBoxContainer/SpaceTop/Button/Icon.flip_h = toggled_on


func _characters_updated(player: Array[Characters.Character], enemy: Array[Characters.Character]):
	# Update all character positions
	characters_player = player
	player_panel.characters = player
	player_panel.update_characters()
	characters_enemy = enemy
	enemy_panel.characters = enemy
	enemy_panel.update_characters()


func _show_status_tooltip(text: String):
	tooltip.show_text(text)


func _gold_changed(value: int):
	gold_label.text = Utils.format_number(value) + " " + tr("GOLD")


func update_preferences():
	weapon_preference_panel.update()
	armour_preference_panel.update()
	potion_preference_panel.update()


func update_location(region: Dictionary, current_location: String):
	var list:= Regions.get_location_list(region, current_location)
	var description:= Regions.get_region_description(region)
	$Overview/HBoxContainer/Region.update(list, region.name, description, current_location)


func _show_overview():
	$Overview.show()
	$Character.hide()
	$Journal.hide()
	$Options.hide()
	title_label.text = tr("OVERVIEW")

func _show_character():
	$Overview.hide()
	$Character.show()
	$Journal.hide()
	$Options.hide()
	title_label.text = tr("CHARACTER")
	
	stat_chart.queue_redraw()
	attribute_panel.update()
	mod_panel.update()
	ability_panel.update()
	skill_panel.update()
	equipment_panel.update()

func _show_journal():
	$Overview.hide()
	$Character.hide()
	$Journal.show()
	$Options.hide()
	title_label.text = tr("JOURNAL")

func _show_options():
	$Overview.hide()
	$Character.hide()
	$Journal.hide()
	$Options.show()
	title_label.text = tr("OPTIONS")
	
	update_preferences()
	skill_module_panel.update()


func connect_to_main(main: Node):
	# Connect signals from the main scene
	var main_log: Control = $Overview/HBoxContainer/Log
	main.connect("text_printed", Callable(main_log, "print_log_msg"))
	main.connect("characters_updated", Callable(self, "_characters_updated"))
	main.connect("gold_changed", Callable(self, "_gold_changed"))
	main.connect("inventory_changed", Callable(equipment_panel, "update"))
	main.connect("inventory_changed", Callable(inventory_panel, "update_inventory"))
	main.connect("potion_inventory_changed", Callable(inventory_panel, "update_potion_inventory"))
	main.connect("story_inventory_changed", Callable(inventory_panel, "update_story_inventory"))
	main.connect("location_changed", Callable(self, "update_location"))
	main.connect("freed", Callable(self, "queue_free"))
	
	connect("settings_changed", Callable(main, "_settings_changed"))
	
	main_character_settings = main.player_settings
	main_character = main.player
	stat_chart.character = main.player
	attribute_panel.character = main.player
	mod_panel.character = main.player
	ability_panel.character = main.player
	skill_panel.character = main.player
	equipment_panel.character = main.player
	skill_module_panel.character = main.player
	skill_module_panel.character_settings = main_character_settings
	weapon_preference_panel.character_settings = main_character_settings
	armour_preference_panel.character_settings = main_character_settings
	potion_preference_panel.character_settings = main_character_settings
	timetable = main.timetable
	
	main.gui_ready()

func _ready():
	_show_overview()
