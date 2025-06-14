extends Node

var texts:= []

var state: String
var data:= {
	"location":"test city",
	"region":"test region",
	"target_region":"new region",
	"guards":true,
}


@warning_ignore("unused_signal")
signal travel_text(String)


func pick_text(type: String) -> Dictionary:
	var valid:= []
	for text_data in texts:
		if text_data.type != type:
			continue
		if "required" in text_data:
			for k in text_data.required:
				if k not in data:
					continue
		valid.push_back(text_data)
	if valid.size() > 0:
		return valid.pick_random()
	return {}

func format_text(text: String, keys: Array) -> String:
	var format_map:= {}
	for key in keys:
		format_map[key] = data.get(key, "")
	return text.format(format_map)


# additional format methods

func add_ration_list(required: Array):
	data.ration_list = Names.make_list(["to", "do"])
	required.push_back("ration_list")

func the_price_is(required: Array):
	data.the_price_is = tr("THE_PRICE_IS").format({"price":tr([
		"MODEST","ADEQUATE","RIDICULOUS","OUTRAGEOUS"].pick_random())})
	required.push_back("the_price_is")



func do_transition(type: String):
	var text_data:= pick_text(type)
	state = type
	if text_data.size() == 0:
		return
	
	var text_string: String
	var required: Array = text_data.get("required", [])
	if "format_methods" in text_data && text_data.format_methods.size() > 0:
		call(text_data.format_methods.pick_random(), required)
	text_string = format_text(text_data.text.pick_random(), required)
	
	emit_signal("travel_text", text_string)
	
	if "transitions" in text_data && text_data.transitions.size() > 0:
		do_transition(text_data.transitions.pick_random())


func get_file_paths(path: String) -> Array:
	var array:= []
	var dir:= DirAccess.open(path)
	var error:= DirAccess.get_open_error()
	if error != OK:
		print("Error when accessing " + path + "!")
		return array
	
	dir.list_dir_begin()
	var file_name:= dir.get_next()
	while file_name != "":
		if !dir.current_is_dir():
			array.push_back(path + "/" + file_name)
		file_name = dir.get_next()
	
	return array

func load_data(paths: Array):
	for file_name in paths:
		var file:= FileAccess.open(file_name, FileAccess.READ)
		var error:= FileAccess.get_open_error()
		if error!=OK:
			print("Can't open file " + file_name + "!")
			continue
		else:
			print("Loading items " + file_name + ".")
		
		var raw:= file.get_as_text()
		var array: Array = JSON.parse_string(raw)
		if array==null || array.size()==0:
			printt("Error parsing " + file_name + "!")
			continue
		for text_data in array:
			texts.push_back(text_data)
		file.close()

func load_text_data(path: String):
	load_data(get_file_paths(path))

func _ready():
	load_text_data("res://data/texts/travel")
	
	
#	connect("travel_text", Callable(self, "print_log_msg"))
	
	
#	do_transition("embark")
	
