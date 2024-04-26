extends Node

const MAP_SCROLL_SPEED = 30.0

var version:= "0.0.6"

var characters:= []
var main:= preload("res://gui/main.tscn")
var main_instance: Node
var thread: Thread
var tile_map_line:= 30
var import_file:= ""
var import_data: String

@onready var progress_bar:= $Loading/ProgressBar
@onready var progress_label:= $Loading/LabelProgress
@onready var tile_map:= $TileMap
@onready var import_name_override:= $ConfirmationDialog/LineEdit
@onready var import_name_warning:= $ConfirmationDialog/LabelWarning


func update_tile_map():
	for k in range(0,15):
		var pos:= Vector2i(k, tile_map_line)
		tile_map.set_cell(0, pos+Vector2i(0,35), -1)
		if randf()<0.5:
			continue
		var source:= int(randf_range(1,8.5))
		var p: Vector2i = [Vector2i(-1,0),Vector2i(1,0),Vector2i(0,-1),Vector2i(0,1)].pick_random()
		if tile_map.get_cell_source_id(0, pos+p)>=0:
			source = tile_map.get_cell_source_id(0, pos+p)
		tile_map.set_cell(0, pos, source, Vector2i(randi()%3,randi()%3))
	tile_map_line -= 1


func create_save_dir() -> DirAccess:
	var dir:= DirAccess.open("user://")
	var error:= dir.make_dir_recursive("user://saves")
	if error!=OK:
		print("Can't create save directory!")
	return dir

func load_characters():
	var dir:= DirAccess.open("user://saves")
	characters.clear()
	if dir==null || DirAccess.get_open_error()!=OK:
		create_save_dir()
		return
	
	var file_name: String
	var i:= 0
	dir.list_dir_begin()
	file_name = dir.get_next()
	for c in $Characters/ScrollContainer/VBoxContainer.get_children():
		c.hide()
	while file_name!="":
		if !dir.current_is_dir():
			var button: Button
			var file:= FileAccess.open("user://saves/"+file_name, FileAccess.READ)
			if FileAccess.get_open_error()!=OK:
				print("Can't open save file "+file_name+"!")
			else:
				var data: Dictionary = JSON.parse_string(file.get_line())
				characters.push_back(file_name)
				if has_node("Characters/ScrollContainer/VBoxContainer/Character"+str(i)):
					button = get_node("Characters/ScrollContainer/VBoxContainer/Character"+str(i))
				else:
					button = $Characters/ScrollContainer/VBoxContainer/Character0.duplicate()
					button.name = "Character"+str(i)
					$Characters/ScrollContainer/VBoxContainer.add_child(button)
				button.show()
				button.get_node("HBoxContainer/Info/LabelName").text = data.name
				button.get_node("HBoxContainer/Info/LabelRace").text = data.race
				button.get_node("HBoxContainer/Info/LabelLevel").text = tr("LEVEL")+" "+str(data.level)
				button.get_node("HBoxContainer/Info/LabelLocation").text = data.location
				if !OS.has_feature("web"):
					button.get_node("HBoxContainer/ButtonExport").hide()
				elif !button.get_node("HBoxContainer/ButtonExport").is_connected("pressed", Callable(self, "_export")):
					button.get_node("HBoxContainer/ButtonExport").connect("pressed", Callable(self, "_export").bind(i))
				if !button.is_connected("pressed", Callable(self, "_load")):
					button.connect("pressed", Callable(self, "_load").bind(i))
				i += 1
		file_name = dir.get_next()
	if $Characters/ScrollContainer/VBoxContainer/Character0.visible:
		$Characters/ScrollContainer/VBoxContainer/Character0.grab_focus()


func _quit():
	get_tree().quit()

func _new_character():
	get_tree().change_scene_to_file("res://gui/new_game.tscn")

func _show_characters():
	load_characters()
	$Characters.show()

func _load(ID: int):
	thread = Thread.new()
	$Panel.hide()
	$Characters.hide()
	$Loading/AnimationPlayer.play("fade_in")
	set_process(true)
	progress_bar.value = 0.0
	progress_label.text = tr("DAY") + " 1 / 1"
	create_instance(characters[ID].left(characters[ID].rfind('.')))

func _export(ID: int):
	var file:= FileAccess.open("user://saves/" + characters[ID], FileAccess.READ)
	if FileAccess.get_open_error()!=OK:
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
		
		var data: Dictionary = JSON.parse_string(file.get_line())
		if !data.has("level") || !data.has("location") || !data.has("name") || !data.has("race"):
			print("File " + file_name + " is not a valid save file")
			continue
		
		# store the text because the dropped files may be temporary
		import_data = file.get_as_text()
		import_file = file_name
		import_name_override.text = data.name
		import_name_warning.visible = check_character_existance()
		$ConfirmationDialog.popup_centered()
		return

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
		if import_name_override.text==file_name:
			return true
		file_name = dir.get_next()
	return false

func _import_name_override_changed(new_name: String):
	import_name_warning.visible = check_character_existance()

func _import():
	var dir:= DirAccess.open("user://saves/")
	if dir==null || DirAccess.get_open_error()!=OK:
		dir = create_save_dir()
		if dir==null:
			return
	
	var file: FileAccess
	var pos:= import_data.find("\n")
	var file_name: String = "user://saves/" + import_name_override.text + ".dat"
	var data: Dictionary = JSON.parse_string(import_data.left(pos))
	var name: String = data.name
	# replace character name
	import_data = import_data.replace(name, import_name_override.text)
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

func _process(delta: float):
	if main_instance==null:
		tile_map.position.y += delta*MAP_SCROLL_SPEED
		if -tile_map_line<2+tile_map.position.y/33:
			update_tile_map()
		return
	
	progress_bar.value = progress_bar.max_value - (Time.get_unix_time_from_system() - main_instance.current_time)
	progress_label.text = tr("DAY") + " " + str(int(round((progress_bar.value)/60/60/24))+1) + " / " + str(int(round(progress_bar.max_value/60/60/24))+1)
	
	if abs(Time.get_unix_time_from_system() - main_instance.current_time)<10:
		$Loading/AnimationPlayer.play("fade_out")
		set_process(false)

func _ready():
	$VersionLabel.text = version
	
	if OS.has_feature("web") || OS.has_feature("mobile"):
		$Panel/VBoxContainer/Button3.hide()
	
	get_window().files_dropped.connect(Callable(self, "_files_dropped"))
	
	for i in range(35):
		update_tile_map()
