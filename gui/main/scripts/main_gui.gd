extends CanvasLayer

var main_character: Characters.Character
var main_character_settings: Characters.CharacterSettings
var characters_player: Array[Characters.Character] = []
var characters_enemy: Array[Characters.Character] = []
var theme: Theme

@onready var title_label:= $Title/Label as Label
@onready var tooltip:= $Tooltip as Tooltip
@onready var player_panel:= $Overview/Player as CharacterPanel
@onready var enemy_panel:= $Overview/Enemy as CharacterPanel
@onready var stat_chart:= $Character/Stats/Stats/Chart as RadialChart
@onready var attribute_panel:= $Character/Stats/Attributes as AttributePanel
@onready var mod_panel:= $Character/Stats/Mods as ModPanel
@onready var ability_panel:= $Character/Skills/Abilities as AbilityPanel
@onready var skill_panel:= $Character/Skills/Skills as SkillPanel
@onready var equipment_panel:= $Character/Equipment/Equipment as EquipmentPanel
@onready var inventory_panel:= $Inventory/Inventory as InventoryPanel
@onready var recipe_panel:= $Inventory/Recipes as RecipePanel
@onready var gold_label:= $Inventory/Inventory/ScrollContainer/VBoxContainer/LabelGold as Label
@onready var skill_module_panel:= $Options/SkillModules/SkillModules as SkillModulePanel
@onready var weapon_preference_panel:= $Options/Preferences/WeaponPreference as WeaponPreferencePanel
@onready var armour_preference_panel:= $Options/Preferences/ArmourPreference as ArmourPreferencePanel
@onready var potion_preference_panel:= $Options/Preferences/PotionPreference as PotionPreferencePanel
@onready var quest_log:= $Overview/HBoxContainer/Quest/RichTextLabel as RichTextLabel
@onready var journal_log:= $Journal/Journal/RichTextLabel as RichTextLabel
@onready var guild_panel:= $Journal/Guilds
@onready var statistics:= $Statistics/Statistics/Statistics as StatisticsPanel
@onready var timetable_panel:= $Options/Timetable/Timetable as TimetablePanel
@onready var time_offset_spinbox := $Options/Timetable/Timetable/ScrollContainer/VBoxContainer/HBoxContainer/SpinBox as SpinBox
@onready var page_overview:= $Overview as Control
@onready var page_character:= $Character as Control
@onready var page_journal:= $Journal as Control
@onready var page_inventory:= $Inventory as Control
@onready var page_statistics:= $Statistics as Control
@onready var page_options:= $Options as Control
@onready var title:= $Title as Panel
@onready var side_menu:= $SideMenu as Panel


@warning_ignore("unused_signal")
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
		side_menu.offset_right = 128
		title.offset_left = 128
		title.offset_right = 192
	else:
		side_menu.offset_right = 58
		title.offset_left = 58
		title.offset_right = 128
	($SideMenu/VBoxContainer/SpaceTop/Button/Icon as TextureRect).flip_h = toggled_on


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


func update_location(region: Region, current_location: String):
	var list:= Regions.get_location_list(region, current_location)
	var description:= Regions.get_region_description(region)
	$Overview/HBoxContainer/Region.update(list, region.name, description, current_location)


func update_quest_log(text: String):
	quest_log.parse_bbcode(text)

func update_journal_log(text: String):
	journal_log.parse_bbcode(text)


func _show_overview():
	page_overview.show()
	page_character.hide()
	page_journal.hide()
	page_inventory.hide()
	page_options.hide()
	page_statistics.hide()
	title_label.text = tr("OVERVIEW")

func _show_character():
	page_overview.hide()
	page_character.show()
	page_journal.hide()
	page_inventory.hide()
	page_options.hide()
	page_statistics.hide()
	title_label.text = tr("CHARACTER")
	
	stat_chart.queue_redraw()
	attribute_panel.update()
	mod_panel.update()
	ability_panel.update()
	skill_panel.update()
	equipment_panel.update()

func _show_journal():
	page_overview.hide()
	page_character.hide()
	page_journal.show()
	page_inventory.hide()
	page_options.hide()
	page_statistics.hide()
	title_label.text = tr("JOURNAL")

func _show_inventory() -> void:
	page_overview.hide()
	page_character.hide()
	page_journal.hide()
	page_inventory.show()
	page_options.hide()
	page_statistics.hide()
	title_label.text = tr("INVENTORY")

func _show_options():
	page_overview.hide()
	page_character.hide()
	page_journal.hide()
	page_inventory.hide()
	page_options.show()
	page_statistics.hide()
	title_label.text = tr("OPTIONS")
	
	update_preferences()
	skill_module_panel.update()

func _show_statistics() -> void:
	page_overview.hide()
	page_character.hide()
	page_journal.hide()
	page_inventory.hide()
	page_options.hide()
	page_statistics.show()
	title_label.text = tr("STATISTICS")
	
	statistics.show_level()


func connect_to_main(main: Main):
	# Connect signals from the main scene
	var main_log:= $Overview/HBoxContainer/Log as Control
	main.connect("text_printed", Callable(main_log, "print_log_msg"))
	main.connect("characters_updated", Callable(self, "_characters_updated"))
	main.connect("gold_changed", Callable(self, "_gold_changed"))
	main.connect("inventory_changed", Callable(equipment_panel, "update"))
	main.connect("inventory_changed", Callable(inventory_panel, "update_inventory"))
	main.connect("potion_inventory_changed", Callable(inventory_panel, "update_potion_inventory"))
	main.connect("story_inventory_changed", Callable(inventory_panel, "update_story_inventory"))
	main.connect("location_changed", Callable(self, "update_location"))
	main.connect("quest_log_updated", Callable(self, "update_quest_log"))
	main.connect("summary_updated", Callable(self, "update_journal_log"))
	main.connect("skills_updated", Callable(skill_panel, "update"))
	main.connect("abilities_updated", Callable(recipe_panel, "update"))
	main.connect("guilds_updated", Callable(guild_panel, "update"))
	main.connect("freed", Callable(self, "queue_free"))
	
	timetable_panel.connect("timetable_modified", Callable(main, "_set_timetable"))
	time_offset_spinbox.connect("value_changed", Callable(main, "_set_time_offset"))
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
	recipe_panel.character = main_character
	recipe_panel.character_settings = main_character_settings
	weapon_preference_panel.character_settings = main_character_settings
	armour_preference_panel.character_settings = main_character_settings
	potion_preference_panel.character_settings = main_character_settings
	statistics.historical_data = main.historical_data
	guild_panel.guild_lvl = main.player_guild_lvl
	guild_panel.guild_exp = main.player_guild_exp
	
	main.gui_ready()
	timetable_panel.update(main.timetable, main.time_offset)

func _ready():
	var schedule_option_button:= $Options/Timetable/Timetable/ScrollContainer/VBoxContainer/HBoxContainer0/OptionButton as OptionButton
	schedule_option_button.set_item_tooltip(0, tr("TRAINING_TOOLTIP"))
	schedule_option_button.set_item_tooltip(1, tr("GRINDING_TOOLTIP"))
	schedule_option_button.set_item_tooltip(2, tr("QUESTING_TOOLTIP"))
	schedule_option_button.set_item_tooltip(3, tr("SHOPPING_TOOLTIP"))
	schedule_option_button.set_item_tooltip(4, tr("CRAFTING_TOOLTIP"))
	schedule_option_button.set_item_tooltip(5, tr("RESTING_TOOLTIP"))
	
	page_overview.theme = theme
	page_character.theme = theme
	page_journal.theme = theme
	page_inventory.theme = theme
	page_statistics.theme = theme
	page_options.theme = theme
	side_menu.theme = theme
	title.theme = theme
	tooltip.theme = theme
	
	_show_overview()
