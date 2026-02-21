extends Node
class_name GuildDescriptions

const TRANSITIONS: Dictionary[String, Array] = {
	"start": [
		"founding"
	],
	"founding": [
		"details",
		"symbol",
		"goal"
	],
	"details": [
		"convictions",
		"goal",
		"symbol"
	],
	"goal": [
		"convictions"
	],
	"convictions": [
		"goal"
	]
}
const ALL_STAGES: Array[String] = [
	"founding",
	"details",
	"symbol",
	"convictions",
	"goal"
]

var description_data: Array[Dictionary] = []
var attribute_data: Dictionary[String, Array] = {}

@onready
var gods := $"../Gods" as GodDescriptions


func format_guild_name(guild: Guild, region: Region) -> String:
	var required_attributes:= self.get_required_attributes(guild.base_name)
	var format_dict:= self.construct_format_dict(required_attributes, guild, region)
	guild.name = guild.name.format(format_dict)
	guild.base_name = guild.base_name.format(format_dict)
	return guild.base_name

func create_guild_description(guild: Guild, region: Region) -> String:
	var description := ""
	var stage := "start"
	var past_stages: Array[String] = []
	
	for i in range(3):
		stage = get_next_stage(stage, past_stages, guild.tags)
		past_stages.push_back(stage)
		
		var valid_descriptions := self.get_valid_descriptions(guild.tags, stage)
		var text := valid_descriptions.pick_random() as String
		var required_attributes := self.get_required_attributes(text)
		var format_dict := self.construct_format_dict(required_attributes, guild, region)
		var final_text := text.format(format_dict) + "."
		final_text[0] = final_text[0].to_upper()
		description += final_text + " "
	if "symbol" not in past_stages:
		var valid_descriptions := self.get_valid_descriptions(guild.tags, "symbol")
		var text := valid_descriptions.pick_random() as String
		var required_attributes := self.get_required_attributes(text)
		var format_dict := self.construct_format_dict(required_attributes, guild, region)
		var final_text := text.format(format_dict) + "."
		final_text[0] = final_text[0].to_upper()
		description += final_text + " "
	elif "god" in guild.tags and "convictions" not in past_stages:
		var valid_descriptions := self.get_valid_descriptions(guild.tags, "convictions")
		var text := valid_descriptions.pick_random() as String
		var required_attributes := self.get_required_attributes(text)
		var format_dict := self.construct_format_dict(required_attributes, guild, region)
		var final_text := text.format(format_dict) + "."
		final_text[0] = final_text[0].to_upper()
		description += final_text + " "
	
	return sanitize_string(description)

func get_next_stage(current_stage: String, invalid_stages: Array[String], tags: Array[String]) -> String:
	var valid_stages: Array[String] = Array(TRANSITIONS.get(current_stage, []), TYPE_STRING, "", null)
	for s in invalid_stages:
		valid_stages.erase(s)
	for s in valid_stages:
		if self.get_valid_descriptions(tags, s as String).size() == 0:
			valid_stages.erase(s)
	
	if valid_stages.size() == 0:
		return ALL_STAGES.pick_random()
	return valid_stages.pick_random()

func get_valid_descriptions(tags: Array[String], type: String) -> Array[String]:
	var valid_descriptions: Array[String] = []
	
	var contains:= func contains(tag: String):
		return tag in tags
	
	for description in self.description_data:
		if "type" in description and type not in description.type:
			continue
		if "tags" not in description:
			valid_descriptions += Array(description.get("texts", []), TYPE_STRING, "", null)
			continue
		if description.tags.any(contains):
			valid_descriptions += Array(description.get("texts", []), TYPE_STRING, "", null)
	
	if valid_descriptions.size() == 0:
		printt("No valid descriptions found for", type, "with tags", tags)
		return Array(self.description_data.pick_random().get("texts", []), TYPE_STRING, "", null)
	
	return valid_descriptions

func get_required_attributes(text: String) -> Array[String]:
	var attributes: Array[String] = []
	var regex = RegEx.new()
	var regex_matches: Array[RegExMatch]
	regex.compile("\\{([\\w0-9._-]+)\\}")
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
			"organization":
				format_dict[attribute] = guild.organization
			"god":
				if guild.god != "" and guild.god in gods.gods:
					format_dict[attribute] = (gods.gods[guild.god] as God).name
				else:
					var god := gods.create_god(guild.tags) as God
					guild.god = god.ID
					format_dict[attribute] = god.name
			_:
				if attribute.contains("god"):
					if guild.god == "" or guild.god not in gods.gods:
						var god := gods.create_god(guild.tags) as God
						guild.god = god.ID
					var attr := attribute.substr(4)
					format_dict[attribute] = gods.pick_property(guild.god, attr)
				else:
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
	
	printt(attribute_type)
	match attribute_type:
		"saying":
			return Utils.get_random_saying()
	
	return "unknown"


func sanitize_string(string: String) -> String:
	var pos:= 0
	if string[0]=='A' && string[1]==' ':
		var pos2:= string.find(' ', 2)
		if string[pos2-1]=="s":
			string = "The" + string.substr(1)
		elif string[2].to_lower() in Names.VOVELS:
			string = "An" + string.substr(1)
	while pos>=0 && pos<string.length():
		var pos2: int
		pos = string.find(" a ", pos)
		if pos==-1:
			break
		pos2 = string.find(' ', pos+3)
		if string[pos2-1]=='s':
			string = string.left(pos) + " the " + string.substr(pos+3)
		elif string[pos+3].to_lower() in Names.VOVELS:
			string = string.left(pos) + " an " + string.substr(pos+3)
		elif string[pos+3]=='[':
			var p:= string.find(']', pos+3)
			if string[p+1].to_lower() in Names.VOVELS:
				string = string.left(pos) + " an " + string.substr(pos+3)
		pos += 3
	
	return string


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
	
