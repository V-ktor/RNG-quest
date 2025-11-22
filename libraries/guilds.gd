extends Node

const GUILDS = {
	"adventurer_guild":{
		"name":"adventurer_guild",
		"rank_names":{
			"type":"name",
			"tiers":[
				"copper","tin","bronze","iron","steel","chromium","silver","gold","titanium","platinum","admanite"
			],
		},
		"exp_gain":{
			"exploration":20,
			"kill":2,
			"quest":1,
		},
		"equipment_reward":["accessoiry"],
	},
	"fighter_guild":{
		"name":"fighter_guild",
		"rank_names":{
			"type":"list",
			"tiers":[
				"rookie","cannon_fodder","greenhorn","brawler","combatant","fighter","battler",
				"challenger","champion","legend",
			],
		},
		"required":{
			"abilities":["light_weapons","heavy_weapons","archery"]
		},
		"exp_gain":{
			"sell":1,
			"craft":2,
			"kill":3,
		},
		"equipment_reward":["heavy_weapon","chain_armour"],
	},
	"fight_club":{
		"name":"fight_club",
		"rank_names":{
			"type":"list",
			"tiers":[
				"rookie","cannon_fodder","greenhorn","brawler","combatant","fighter","battler",
				"challenger","champion","legend",
			],
		},
		"required":{
			"abilities":["light_weapons","heavy_weapons","brawling"]
		},
		"exp_gain":{
			"buy":2,
			"buff":1,
			"kill":3,
		},
		"equipment_reward":["heavy_weapon","chain_armour"],
	},
	"trapper_guild":{
		"name":"trapper_guild",
		"required":{
			"abilities":["archery","trapping"]
		},
		"exp_gain":{
			"trapping":5,
			"alchemy":5,
			"kill":2,
		},
		"equipment_reward":["ranged_weapon","leather_armour"],
	},
	"mage_guild":{
		"name":"mage_guild",
		"rank_names":{
			"type":"list",
			"tiers":[
				"amateur","apprentice","novice","student","PhD",
				"spell_caster","wizard","intructor","archmage",
			],
		},
		"required":{
			"abilities":["elemental_magic","nature_magic","defensive_magic","enchanting"]
		},
		"exp_gain":{
			"identify":30,
			"enchant":2,
			"kill":1,
			"buff":1,
		},
		"equipment_reward":["magic_weapon","cloth_armour"],
	},
	"summoner_guild":{
		"name":"summoner_guild",
		"required":{
			"abilities":["summoner","necromancy"]
		},
		"exp_gain":{
			"summon":2,
			"kill":1,
			"buff":1,
			"miss":1,
		},
		"equipment_reward":["magic_weapon","cloth_armour"],
	},
	"alchemist_guild":{
		"name":"alchemist_guild",
		"required":{
			"abilities":["alchemy","enchanting"]
		},
		"exp_gain":{
			"harvest":2,
			"enchant":5,
			"alchemy":5,
		},
		"equipment_reward":["magic_weapon","material"],
	},
	"war_caster_guild":{
		"name":"war_caster_guild",
		"required":{
			"abilities":["infuse_elemental","infuse_nature"]
		},
		"exp_gain":{
			"buy":1,
			"hit":1,
			"kill":3,
		},
		"equipment_reward":["light_weapon","heavy_weapon","magic_weapon"],
	},
	"celestial_church":{
		"name":"celestial_church",
		"rank_names":{
			"type":"list",
			"tiers":[
				"layman","apprentice","novice","preacher","cleric",
				"priest","temple_priest","saint","high_priest",
			],
		},
		"required":{
			"abilities":["celestial_magic","defensive_magic","healing"]
		},
		"exp_gain":{
			"identify":10,
			"enchant":2,
			"heal":5,
			"buff":1,
			"visit_church":60,
		},
		"equipment_reward":["magic_weapon","cloth_armour"],
	},
	"celestial_order":{
		"name":"celestial_order",
		"rank_names":{
			"type":"list",
			"tiers":[
				"amateur","apprentice","novice","preacher","cleric",
				"priest","inquisitor","saint","high_inquisitor",
			],
		},
		"required":{
			"abilities":["cleric"]
		},
		"exp_gain":{
			"heal":5,
			"kill":1,
			"buff":1,
			"visit_church":40,
		},
		"equipment_reward":["heavy_weapon","shield","chain_armour"],
	},
	"thief_guild":{
		"name":"thief_guild",
		"required":{
			"abilities":["light_weapons","dirty_fighting"]
		},
		"exp_gain":{
			"loot":2,
			"debuff":2,
			"attack":1,
		},
		"equipment_reward":["light_weapon","leather_armour"],
	},
	"assassin_guild":{
		"name":"assassin_guild",
		"required":{
			"abilities":["dirty_fighting"]
		},
		"exp_gain":{
			"debuff":2,
			"hit":1,
			"kill":2,
		},
		"equipment_reward":["light_weapon","leather_armour"],
	},
	"crafter_guild":{
		"name":"crafter_guild",
		"required":{
			"abilities":["weapon_smithing","armour_smithing","woodwork","tayloring","cooking"]
		},
		"exp_gain":{
			"loot":2,
			"cook":5,
			"craft":5,
		},
		"equipment_reward":["material","accessoiry"],
	},
}

var organization_data: Dictionary[String, Dictionary] = {}
var subject_data: Dictionary[String, Dictionary] = {}
var specialization_data: Dictionary[String, Dictionary] = {}

var guilds: Dictionary[String, Guild] = {}


#class Organization:
	#var name: String
	#var organization: String
	#var names: Array[String]
	#var preamble: Array[String]
	#var addendum: Array[String]
	#var rank_carry_over: float
	#var max_range: int
	#var give_welcome_gift: bool
	#var give_parting_gift: bool
	#var tags: Array[String]
	#
	#func _init(data: Dictionary) -> void:
		#self.name = data.get("name", "unknown guild") as String
		#self.organization = data.get("organization", "organization") as String
		#self.names = []
		#for s in data.get("names", []):
			#self.names.push_back(s as String)
		#self.preamble = []
		#for s in data.get("preamble", []):
			#self.preamble.push_back(s as String)
		#self.addendum = []
		#for s in data.get("addendum", []):
			#self.addendum.push_back(s as String)
		#self.rank_carry_over = data.get("rank_carry_over", 1.0) as float
		#self.max_range = data.get("max_range", 0) as int
		#self.give_welcome_gift = data.get("give_welcome_gift", false) as bool
		#self.give_parting_gift = data.get("give_parting_gift", false) as bool
		#self.tags = []
		#for s in data.get("tags", []):
			#self.tags.push_back(s as String)
	#
	#func to_dict() -> Dictionary:
		#return {
			#"name": self.name,
			#"organization": self.organization,
			#"names": self.names,
			#"preamble": self.preamble,
			#"addendum": self.addendum,
			#"rank_carry_over": self.rank_carry_over,
			#"max_range": self.max_range,
			#"give_welcome_gift": self.give_welcome_gift,
			#"give_parting_gift": self.give_parting_gift,
			#"tags": self.tags,
		#}


func get_max_exp(lvl: int) -> int:
	return 600 + 400 * lvl * lvl

func get_rank(level: int, guild: String) -> String:
	if GUILDS[guild].has("rank_names"):
		var dict: Dictionary = GUILDS[guild].rank_names
		match dict.type:
			"name":
				var rank:= ""
				var digits: int = dict.tiers.size()
				for i in range(digits-1,-1,-1):
					var lvl: int = int(level/pow(dict.tiers.size()+1, i))%(dict.tiers.size()+1)
					if lvl<=0:
						continue
					rank += tr(dict.tiers[lvl-1].to_upper())
					if i>0:
						rank += "-"
				return rank + " " + tr("RANK")
			"list":
				var rank: String = tr(dict.tiers[min(level-1, dict.tiers.size()-1)].to_upper())
				if level>=dict.tiers.size():
					rank += " " + Skills.convert_to_roman_number(level+2-dict.tiers.size())
				return rank
	return "rank " + Skills.convert_to_roman_number(level)

func pick_guild(abilities: Array, excluded: Array) -> String:
	var valid:= []
	for guild in GUILDS.keys():
		if guild in excluded:
			continue
		if GUILDS[guild].required.has("abilities"):
			for k in GUILDS[guild].required.abilities:
				if k in abilities:
					valid.push_back(guild)
					break
		else:
			valid.push_back(guild)
	if valid.size()>0:
		return valid.pick_random()
	for guild in GUILDS.keys():
		if guild in excluded:
			continue
		valid.push_back(guild)
	if valid.size()>0:
		return valid.pick_random()
	return ""


func create_guild(region: Region, player: Characters.Character) -> Guild:
	var organization := organization_data.keys().pick_random() as String
	var subject := pick_subject(player)
	var specialization := specialization_data.keys().pick_random() as String
	var guild_data := Utils.merge_dicts(Utils.merge_dicts(organization_data[organization].duplicate(true),
		subject_data[subject].duplicate(true)), specialization_data[specialization].duplicate(true))
	var data := {
		"is_available": true,
		"base_name": tr(guild_data.prefixes.pick_random().to_upper()).capitalize() + " " + \
			tr(guild_data.names.pick_random().to_upper()).capitalize(),
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
	
	if data.addendum.size() > 0:
		data.name = data.base_name + " " + data.addendum.pick_random().format({"region": region.name,
			"city": region.cities.values().pick_random().name})
	else:
		data.name = data.base_name
	
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
	
