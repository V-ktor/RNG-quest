extends Node

var description_data: Array[Dictionary] = []
var attribute_data: Dictionary[String, Array] = {}

@onready
var god_description := $"../Gods"


func create_guild_description(guild: Guild, region: Region) -> Array [String]:
	var descriptions: Array[String] = []
	var valid_descriptions:= self.get_valid_descriptions(guild.tags)
	
	for i in range(3):
		var text:= valid_descriptions.pop_at(randi()%valid_descriptions.size()) as String
		var required_attributes:= self.get_required_attributes(text)
		var format_dict:= self.construct_format_dict(required_attributes, guild, region)
		var final_text:= text.format(format_dict) + "."
		final_text[0] = final_text[0].to_upper()
		descriptions.push_back(final_text)
	
	return descriptions

func get_valid_descriptions(tags: Array[String]) -> Array[String]:
	var valid_descriptions: Array[String] = []
	
	var contains:= func contains(tag: String):
		return tag in tags
	
	for description in self.description_data:
		if "tags" not in description:
			valid_descriptions += Array(description.get("texts", []), TYPE_STRING, "", null)
			continue
		if description.tags.any(contains):
			valid_descriptions += Array(description.get("texts", []), TYPE_STRING, "", null)
	
	return valid_descriptions

func get_required_attributes(text: String) -> Array[String]:
	var attributes: Array[String] = []
	var regex = RegEx.new()
	var regex_matches: Array[RegExMatch]
	regex.compile("\\{([\\w0-9_-]+)\\}")
	regex_matches = regex.search_all(text)
	for regex_match in regex_matches:
		attributes.push_back(regex_match.get_string(1))
	return attributes

func construct_format_dict(required_attributes: Array[String], guild: Guild, region: Region) -> \
		Dictionary[String, String]:
	var format_dict: Dictionary[String, String] = {}
	for attribute in required_attributes:
		match attribute:
			"guild_name":
				format_dict[attribute] = guild.base_name
			"region":
				format_dict[attribute] = region.name
			"city":
				format_dict[attribute] = region.cities.values().pick_random().name
			"founder":
				var founder_name:= Names.create_name(guild.race.pick_random(), randi_range(-1, 1))
				# TODO: add a last name
				# TODO: add a title
				format_dict[attribute] = founder_name
			"god":
				if guild.god != "" and guild.god in god_description.gods:
					format_dict[attribute] = (god_description.gods[guild.god] as God).name
				else:
					var god := god_description.create_god(guild.tags) as God
					guild.god = god.ID
					format_dict[attribute] = god.name
			_:
				var req_attributes: Array[String]
				format_dict[attribute] = pick_attribute(attribute, guild)
				req_attributes = self.get_required_attributes(format_dict[attribute])
				Utils.merge_dicts(format_dict, construct_format_dict(req_attributes, guild, region))
	return format_dict

func pick_attribute(attribute_type: String, guild: Guild) -> String:
	if attribute_type not in self.attribute_data:
		return "unknown"
	
	var valid_attribute_texts: Array[String] = []
	var contains:= func contains(tag: String):
		return tag in guild.tags
	for attribute in self.attribute_data[attribute_type]:
		if not attribute.tags.any(contains):
			continue
		valid_attribute_texts += Array(attribute.get("texts", []), TYPE_STRING, "", null)
	
	if valid_attribute_texts.size() > 0:
		return valid_attribute_texts.pick_random()
	return "unknown"


### Loading definitions ###

func load_description_data(paths: Array[String]):
	for file_name in paths:
		var file:= FileAccess.open(file_name, FileAccess.READ)
		var error:= FileAccess.get_open_error()
		if error != OK:
			print("Can't open file " + file_name)
			continue
		else:
			print("Loading skill module " + file_name)
		
		var raw:= file.get_as_text()
		var data: Array = JSON.parse_string(raw)
		if data == null || data.size() == 0:
			printt("Error parsing " + file_name)
			continue
		
		for dict in data:
			if typeof(dict) != TYPE_DICTIONARY:
				printt("Description " + file_name + " not a dictionary")
				continue
			
			description_data.push_back(dict)
		
		file.close()

func load_attribute_data(paths: Array[String]):
	for file_name in paths:
		var file:= FileAccess.open(file_name, FileAccess.READ)
		var error:= FileAccess.get_open_error()
		if error != OK:
			print("Can't open file " + file_name)
			continue
		else:
			print("Loading skill module " + file_name)
		
		var raw:= file.get_as_text()
		var data: Array = JSON.parse_string(raw)
		if data == null || data.size() == 0:
			printt("Error parsing " + file_name)
			continue
		
		var lpos:= file_name.rfind("/") + 1
		var type:= file_name.substr(lpos, file_name.rfind(".") - lpos)
		attribute_data[type] = data
		file.close()

func _init() -> void:
	load_description_data(Utils.get_file_paths("res://data/guilds/descriptions"))
	load_attribute_data(Utils.get_file_paths("res://data/guilds/attributes"))
	
