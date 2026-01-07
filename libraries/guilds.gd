extends Node

var organization_data: Dictionary[String, Dictionary] = {}
var subject_data: Dictionary[String, Dictionary] = {}
var specialization_data: Dictionary[String, Dictionary] = {}

var guilds: Dictionary[String, Guild] = {}

@onready
var descriptions := $Description


func create_guild(region: Region, player: Characters.Character) -> Guild:
	var data: Dictionary
	var organization := organization_data.keys().pick_random() as String
	var subject := pick_subject(player)
	var specialization := specialization_data.keys().pick_random() as String
	var guild_data := Utils.merge_dicts(Utils.merge_dicts(organization_data[organization].duplicate(true),
		subject_data[subject].duplicate(true)), specialization_data[specialization].duplicate(true))
	var guild_name := tr(guild_data.names.pick_random().to_upper()).capitalize()
	if "suffixes" in guild_data and guild_data.suffixes.size() > 0:
		guild_name += " " + guild_data.suffixes.pick_random()
	elif "prefixes" in guild_data and guild_data.prefixes.size() > 0:
		guild_name = tr(guild_data.prefixes.pick_random().to_upper()).capitalize() + " " + guild_name
	
	data = {
		"is_available": true,
		"base_name": guild_name,
		"level": 1,
		"experience": 0,
		"subject": subject,
		"organization": organization,
		"specialization": specialization,
		"distance": 0,
		"max_range": guild_data.get("max_range", 0),
		"rank_carry_over": guild_data.get("rank_carry_over", 1.0),
		"give_welcome_gift": guild_data.get("give_welcome_gift", false),
		"give_parting_gift": guild_data.get("give_parting_gift", false),
		"addendum": guild_data.get("addendum", []),
		"locations": [],
		"ranks": create_guild_ranks(guild_data.get("ranks", {}), guild_data.get("rank_prefixes", {})),
		"relics": guild_data.get("relics", ["artifact"]),
		"race": region.race,
		"exp_gain": guild_data.get("exp_gain", {"quest": 10}),
		"abilities": guild_data.get("abilities", []),
		"tags": guild_data.get("tags", []) + [organization, subject, specialization] + region.race,
	}
	if data.abilities.size() == 0:
		data.abilities = [Skills.ABILITIES.keys().pick_random()]
	data.tags += data.abilities
	
	for i in range(region.cities.size()):
		if i == 0 || randf() < 0.333:
			data.locations.push_back(region.name + " - " + region.cities.values()[i].name)
	
	var index := 1
	var ID := (data.get("base_name", "guild") as String).to_lower().replace(" ", "_")
	while ID + str(index) in self.guilds:
		index += 1
	data.ID = ID + str(index)
	
	var guild := Guild.new(data)
	self.guilds[guild.ID] = guild
	descriptions.format_guild_name(guild, region)
	if data.addendum.size() > 0:
		guild.name = data.base_name + " " + data.addendum.pick_random().format({"region": region.name,
			"city": region.cities.values().pick_random().name})
	else:
		guild.name = data.base_name
	guild.description = descriptions.create_guild_description(guild, region)
	return guild

func create_guild_ranks(base_ranks: Dictionary, rank_prefixes: Dictionary) -> Array[String]:
	var ranks: Array[String] = []
	if "-1" in rank_prefixes and "0" in base_ranks:
		ranks.push_back(rank_prefixes.get("-1").pick_random() + " " + base_ranks.get("0").pick_random())
	for i in range(10):
		if str(i) not in base_ranks:
			continue
		
		if i < 5 and "-1" in rank_prefixes:
			ranks.push_back(rank_prefixes.get("-1").pick_random() + " " + base_ranks.get(str(i + 1)).pick_random())
		if "0" in rank_prefixes:
			ranks.push_back(rank_prefixes.get("0").pick_random() + " " + base_ranks.get(str(i)).pick_random())
		if i > 3 and "1" in rank_prefixes:
			ranks.push_back(rank_prefixes.get("1").pick_random() + " " + base_ranks.get(str(i)).pick_random())
	return ranks

func calc_guild_subject_score(subject: Dictionary, ability_levels: Dictionary[String, int]) -> int:
	var score:= 0
	for ability in subject.get("abilities", []):
		if ability not in ability_levels:
			continue
		score += ability_levels[ability]
	return score

func abilities_to_ability_levels(abilities: Dictionary[String, Ability]) -> Dictionary[String, int]:
	var ability_levels: Dictionary[String, int] = {}
	for ability in abilities:
		ability_levels[ability] = abilities[ability].level
	return ability_levels

func pick_subject(player: Characters.Character) -> String:
	var ability_levels := abilities_to_ability_levels(player.abilities)
	var subjects: Array[Array] = []
	for subject in subject_data:
		subjects.push_back([subject, calc_guild_subject_score(subject_data[subject], ability_levels)])
	subjects.sort_custom(sort_by_score)
	var index := 0
	var rnd := randf()
	if rnd < 0.25:
		@warning_ignore("integer_division")
		index = randi()%ceili(subjects.size() / 3)
	elif rnd < 0.25:
		@warning_ignore("integer_division")
		index = randi()%ceili(subjects.size() / 2)
	elif rnd < 0.75:
		index = randi()%subjects.size()
	return subjects[index][0]

func sort_by_score(a: Array, b: Array) -> bool:
	if a.size() < 2 or b.size() < 2:
		return false
	return a[1] > b[1]


### Saving ###

func to_dict() -> Dictionary:
	var data := {}
	for guild_id in self.guilds:
		data[guild_id] = self.guilds[guild_id].to_dict()
	return data


### Load definitions ###

func load_organization_data(paths: Array[String]):
	for file_name in paths:
		var file:= FileAccess.open(file_name, FileAccess.READ)
		var error:= FileAccess.get_open_error()
		if error != OK:
			print("Can't open file " + file_name)
			continue
		else:
			print("Loading skill module " + file_name)
		
		var raw:= file.get_as_text()
		var data: Dictionary = JSON.parse_string(raw)
		if data == null || data.size() == 0:
			printt("Error parsing " + file_name)
			continue
		var organization_name:= data.get("name", "") as String
		if organization_name == null or organization_name == "":
			printt("Organization " + file_name + " has no name")
			continue
		organization_data[organization_name] = data
		file.close()

func load_subject_data(paths: Array[String]):
	for file_name in paths:
		var file:= FileAccess.open(file_name, FileAccess.READ)
		var error:= FileAccess.get_open_error()
		if error != OK:
			print("Can't open file " + file_name)
			continue
		else:
			print("Loading skill module " + file_name)
		
		var raw:= file.get_as_text()
		var data: Dictionary = JSON.parse_string(raw)
		if data == null || data.size() == 0:
			printt("Error parsing " + file_name)
			continue
		var subject_name:= data.get("name", "") as String
		if subject_name == null or subject_name == "":
			printt("Subject " + file_name + " has no name")
			continue
		subject_data[subject_name] = data
		file.close()

func load_specialization_data(paths: Array[String]):
	for file_name in paths:
		var file:= FileAccess.open(file_name, FileAccess.READ)
		var error:= FileAccess.get_open_error()
		if error != OK:
			print("Can't open file " + file_name)
			continue
		else:
			print("Loading skill module " + file_name)
		
		var raw:= file.get_as_text()
		var data: Dictionary = JSON.parse_string(raw)
		if data == null || data.size() == 0:
			printt("Error parsing " + file_name)
			continue
		var specialization_name:= data.get("name", "") as String
		if specialization_name == null or specialization_name == "":
			printt("Specialization " + file_name + " has no name")
			continue
		specialization_data[specialization_name] = data
		file.close()


func _init() -> void:
	load_organization_data(Utils.get_file_paths("res://data/guilds/organization"))
	load_subject_data(Utils.get_file_paths("res://data/guilds/subject"))
	load_specialization_data(Utils.get_file_paths("res://data/guilds/specialization"))
	
