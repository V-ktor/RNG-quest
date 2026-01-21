extends Node

const MAP_SCROLL_SPEED = 30.0

var version:= "0.2.0"

var characters:= []
var main:= preload("res://scenes/main/main.tscn")
var main_gui:= preload("res://gui/main/scenes/main_gui.tscn")
var new_character_gui:= preload("res://gui/new_game.tscn")
var main_instance: Node
var main_gui_instance: Node
var tile_map_line:= 30
var import_file:= ""
var import_data: String
var settings:= Settings.new()

@onready var progress_bar:= $Loading/ProgressBar as ProgressBar
@onready var progress_label:= $Loading/LabelProgress
@onready var tile_map:= $TileMap as TileMap
@onready var confirmation_dialog:= $ConfirmationDialog as ConfirmationDialog
@onready var import_name_override:= $ConfirmationDialog/LineEdit as LineEdit
@onready var import_name_warning:= $ConfirmationDialog/LabelWarning as Label
@onready var ui_scale_slider:= $Options/ScrollContainer/VBoxContainer/Resolution/HBoxContainer/HSlider as HSlider
@onready var ui_scale_spinbox:= $Options/ScrollContainer/VBoxContainer/Resolution/HBoxContainer/SpinBox as SpinBox
@onready var theme_button:= $Options/ScrollContainer/VBoxContainer/Theme/HBoxContainer/OptionButton as OptionButton
@onready var menu_panel:= $Panel as Panel
@onready var character_panel:= $Characters as Panel
@onready var option_panel:= $Options as Panel
@onready var loading_panel:= $Loading as Panel



var themes: Array[Theme] = [
	preload("res://themes/light_theme.tres"),
	preload("res://themes/dark_theme.tres"),
]


class Settings:
	var scaling := 1.0
	var theme := 0
	
	func to_json() -> String:
		var data:= {
			"scaling": scaling,
			"theme": theme,
		}
		return JSON.stringify(data)


func update_tile_map():
	for k in range(0, 15):
		var pos:= Vector2i(k, tile_map_line)
		tile_map.set_cell(0, pos + Vector2i(0, 35), -1)
		if randf() < 0.5:
			continue
		var source:= int(randf_range(1, 8.5))
		var p: Vector2i = [Vector2i(-1, 0), Vector2i(1, 0), Vector2i(0, -1),\
			Vector2i(0, 1)].pick_random()
		if tile_map.get_cell_source_id(0, pos + p)>=0:
			source = tile_map.get_cell_source_id(0, pos + p)
		tile_map.set_cell(0, pos, source, Vector2i(randi()%3, randi()%3))
	tile_map_line -= 1


func get_dict_text(file: FileAccess) -> String:
	var text:= ""
	var brackets:= 0
	while true:
		var new_line:= file.get_line()
		text += new_line
		brackets += clampi(int(new_line.find("{") >= 0), 0, 1)\
			- clampi(int(new_line.find("}") >= 0), 0, 1)
		if brackets <= 0:
			break
	return text

func create_save_dir() -> DirAccess:
	var dir:= DirAccess.open("user://")
	var error:= dir.make_dir_recursive("user://saves")
	if error!=OK:
		print("Can't create save directory!")
	return dir

func load_characters():
	var dir:= DirAccess.open("user://saves")
	characters.clear()
	if dir == null || DirAccess.get_open_error() != OK:
		create_save_dir()
		return
	
	var file_name: String
	var i:= 0
	dir.list_dir_begin()
	file_name = dir.get_next()
	for c in $Characters/ScrollContainer/VBoxContainer.get_children():
		(c as Control).hide()
	while file_name != "":
		if !dir.current_is_dir():
			var button: Button
			var file:= FileAccess.open("user://saves/" + file_name, FileAccess.READ)
			if FileAccess.get_open_error() != OK:
				print("Can't open save file " + file_name + "!")
			else:
				var data: Dictionary = JSON.parse_string(get_dict_text(file))
				if data == null:
					continue
				characters.push_back(file_name)
				if has_node("Characters/ScrollContainer/VBoxContainer/Character" + str(i)):
					button = get_node("Characters/ScrollContainer/VBoxContainer/Character" + str(i)) as Button
				else:
					button = $Characters/ScrollContainer/VBoxContainer/Character0.duplicate() as Button
					button.name = "Character" + str(i)
					$Characters/ScrollContainer/VBoxContainer.add_child(button)
				button.show()
				(button.get_node("HBoxContainer/Info/LabelName") as Label).text = data.name
				(button.get_node("HBoxContainer/Info/LabelRace") as Label).text = data.race
				(button.get_node("HBoxContainer/Info/LabelLevel") as Label).text = tr("LEVEL") + " " + str(int(data.level))
				(button.get_node("HBoxContainer/Info/LabelLocation") as Label).text = data.location
				if !OS.has_feature("web"):
					(button.get_node("HBoxContainer/ButtonExport") as Control).hide()
				elif !button.get_node("HBoxContainer/ButtonExport").is_connected("pressed", Callable(self, "_export")):
					button.get_node("HBoxContainer/ButtonExport").connect("pressed", Callable(self, "_export").bind(i))
				if !button.is_connected("pressed", Callable(self, "_load")):
					button.connect("pressed", Callable(self, "_load").bind(i))
				i += 1
		file_name = dir.get_next()
	var first_character:= $Characters/ScrollContainer/VBoxContainer/Character0 as Control
	if first_character.visible:
		first_character.grab_focus()


func _quit():
	get_tree().quit()

func _new_character():
	#get_tree().change_scene_to_file("res://gui/new_game.tscn")
	var new_game:= new_character_gui.instantiate()
	new_game.theme = themes[settings.theme]
	get_parent().add_child(new_game)
	queue_free()

func _show_characters():
	load_characters()
	character_panel.show()
	option_panel.hide()

func _show_options() -> void:
	character_panel.hide()
	option_panel.show()

func _load(ID: int):
	menu_panel.hide()
	character_panel.hide()
	$Loading/AnimationPlayer.play("fade_in")
	set_process(true)
	progress_bar.value = 0.0
	progress_label.text = tr("DAY") + " 1 / 1"
	create_instance(characters[ID].left(characters[ID].rfind('.')))

func _export(ID: int):
	var file:= FileAccess.open("user://saves/" + characters[ID], FileAccess.READ)
	if FileAccess.get_open_error() != OK:
		print("Can't open save file " + characters[ID])
		return
	
	var text:= file.get_as_text()
	file.close()
	JavaScriptBridge.download_buffer(text.to_utf8_buffer(), characters[ID], "text/plain")

func _files_dropped(file_names: Array[String]):
	for file_name in file_names:
		var file:= FileAccess.open(file_name, FileAccess.READ)
		if not file:
			print("Can't open file " + file_name)
			continue
		
		var data: Dictionary = JSON.parse_string(get_dict_text(file))
		if !data.has("level") || !data.has("location") || !data.has("name") || !data.has("race"):
			print("File " + file_name + " is not a valid save file")
			continue
		
		# store the text because the dropped files may be temporary
		import_data = file.get_as_text()
		import_file = file_name
		import_name_override.text = data.name
		import_name_warning.visible = check_character_existance()
		confirmation_dialog.popup_centered()
		return

func check_character_existance() -> bool:
	var dir:= DirAccess.open("user://saves")
	if dir == null || DirAccess.get_open_error() != OK:
		print("Can't open save dir!")
		return false
	
	var file_name: String
	dir.list_dir_begin()
	file_name = dir.get_next()
	while file_name != "":
		file_name = file_name.left(file_name.rfind('.'))
		if import_name_override.text==file_name:
			return true
		file_name = dir.get_next()
	return false

func _import_name_override_changed(_new_name: String):
	import_name_warning.visible = check_character_existance()

func _import():
	var dir:= DirAccess.open("user://saves/")
	if dir == null || DirAccess.get_open_error() != OK:
		dir = create_save_dir()
		if dir == null:
			return
	
	var file: FileAccess
	var pos:= import_data.find("\n")
	var file_name: String = "user://saves/" + import_name_override.text + ".dat"
	var data: Dictionary = JSON.parse_string(import_data.left(pos))
	var character_name: String = data.name
	# replace character name
	import_data = import_data.replace(character_name, import_name_override.text)
	file = FileAccess.open(file_name, FileAccess.WRITE)
	if not file:
		print("Can't open file " + file_name)
		return
	file.store_string(import_data)
	file.close()
	print("Imported file " + import_file)
	
	load_characters()

func create_instance(player_name: String):
	main_instance = main.instantiate()
	main_instance.version = version
	main_instance.player_name = player_name
	main_instance._load()
	progress_bar.max_value = Time.get_unix_time_from_system() - main_instance.current_time
	get_parent().add_child(main_instance)
	
	main_gui_instance = main_gui.instantiate()
	main_gui_instance.theme = themes[settings.theme]
	get_parent().add_child(main_gui_instance)
	main_gui_instance.connect_to_main(main_instance)


func _on_scaling_changed(value_changed: bool) -> void:
	if not value_changed:
		return
	
	var value : float = ui_scale_slider.value / 100.0
	ui_scale_spinbox.value = ui_scale_slider.value
	settings.scaling = value
	get_tree().root.content_scale_factor = settings.scaling
	tile_map.scale = Vector2(2.0, 2.0) / settings.scaling
	tile_map.position = Vector2(16, 32 - 32 * settings.scaling)
	
	save_config()

func _on_scaling_changed_value(value: float) -> void:
	value /= 100.0
	ui_scale_slider.value = ui_scale_spinbox.value
	settings.scaling = value
	get_tree().root.content_scale_factor = settings.scaling
	tile_map.scale = Vector2(2.0, 2.0) / settings.scaling
	tile_map.position = Vector2(16, 32 - 32 * settings.scaling)
	
	save_config()

func _on_theme_selected(index: int) -> void:
	settings.theme = index
	tile_map.scale = Vector2(2.0, 2.0) / settings.scaling
	tile_map.position = Vector2(16, 32 - 32 * settings.scaling)
	menu_panel.theme = themes[index]
	character_panel.theme = themes[index]
	option_panel.theme = themes[index]
	loading_panel.theme = themes[index]
	
	save_config()


func _process(delta: float):
	if main_instance == null:
		tile_map.position.y += delta*MAP_SCROLL_SPEED
		if -tile_map_line < 2 + tile_map.position.y / 33:
			update_tile_map()
		return
	
	progress_bar.value = progress_bar.max_value - (Time.get_unix_time_from_system()\
		- main_instance.current_time)
	progress_label.text = tr("DAY") + " " + str(roundi((progress_bar.value) / 60 / 60 / 24) + 1)\
		+ " / " + str(roundi(progress_bar.max_value / 60 / 60 / 24) + 1)
	
	if abs(Time.get_unix_time_from_system() - main_instance.current_time) < 10:
		($Loading/AnimationPlayer as AnimationPlayer).play("fade_out")
		set_process(false)

func load_config():
	var file:= FileAccess.open("user://config.json", FileAccess.READ)
	var error:= FileAccess.get_open_error()
	if error != OK:
		error = DirAccess.make_dir_absolute("user://")
		if error != OK:
			print("Failed to create the user directory")
		# set default scaling to be proportional to the screen DPI
		settings.scaling = clampf(DisplayServer.screen_get_dpi() / 80.0, 0.5, 2.5)
		settings.theme = int(DisplayServer.is_dark_mode())
	
	else:
		var raw:= file.get_as_text()
		var json:= JSON.new()
		error = json.parse(raw)
		if error != OK:
			print("Failed to parse the config file")
			return
		
		for key in json.data:
			settings.set(key, json.data[key])
	
	var theme:= themes[settings.theme]
	ui_scale_slider.value = settings.scaling * 100
	ui_scale_spinbox.value = settings.scaling * 100
	theme_button.selected = settings.theme
	menu_panel.theme = theme
	character_panel.theme = theme
	option_panel.theme = theme
	loading_panel.theme = theme
	confirmation_dialog.theme = theme

func save_config():
	var file:= FileAccess.open("user://config.json", FileAccess.WRITE)
	var error:= FileAccess.get_open_error()
	if error != OK:
		error = DirAccess.make_dir_absolute("user://")
		if error != OK:
			print("Failed to create the user directory")
			return
		file = FileAccess.open("user://config.json", FileAccess.WRITE)
		error = FileAccess.get_open_error()
		if error != OK:
			print("Failed to open the config file")
			return
	
	var data:= settings.to_json()
	file.store_string(data)
	file.close()

func _ready():
	($VersionLabel as Label).text = version
	
	if OS.has_feature("web") || OS.has_feature("mobile"):
		($Panel/VBoxContainer/Button3 as Button).hide()
	
	load_config()
	get_window().files_dropped.connect(Callable(self, "_files_dropped"))
	
	for i in range(35):
		update_tile_map()
