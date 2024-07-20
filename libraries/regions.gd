extends Node

const NUM_CITIES = 4
const NUM_LOCATIONS = 12

var regions:= {}

@onready
var Descriptions:= $RegionDescription


func get_region_description(region: Dictionary) -> String:
	var text: String = region.name
	if region.race.size()>0:
		text += "\n" + tr("RACE") + ": " + Names.make_list(region.race)
	text += "\n" + tr("CITIES") + ":"
	for c in region.cities:
		text += "\n  " + c
	text += "\n" + tr("LOCATIONS") + ":"
	for l in region.locations:
		text += "\n  " + l
	return text

func get_city_name(array: Array) -> String:
	var name_dict: Dictionary = array.pick_random()
	var city_name: String = name_dict.base.pick_random()
	if name_dict.has("prefix"):
		var city_prefix: String = name_dict.prefix.pick_random()
		if city_prefix[city_prefix.length()-1]==' ' && city_name[0]==' ':
			name = (city_prefix + city_name.substr(1)).capitalize()
		else:
			name = (city_prefix + city_name).capitalize()
	if name_dict.has("suffix"):
		name += name_dict.suffix.pick_random()
	return name

func create_region(ID: String, level:= 0, tier:= 0) -> Dictionary:
	var dict: Dictionary = regions[ID]
	var data:= {
		"level":dict.level + level,
		"tier":dict.tier + tier,
		"race":dict.race,
		"enemy":dict.enemy,
		"cities":[],
		"locations":[],
		"location_enemies":{},
		"enemies":dict.enemies,
		"enemy_amount":dict.enemy_amount.duplicate(),
		"local_materials":dict.local_materials.duplicate(true),
		"enchantment_chance":dict.enchantment_chance,
		"resources":dict.resources,
		"location_resources":{},
		"resource_chance":dict.resource_chance,
		"resource_amount":dict.resource_amount,
	}
	var tier_multiplier:= 1.0
	var level_multiplier:= 1.0 + 0.1*(level-1)
	var region_name: String = dict.base_name.pick_random()
	var region_prefix: String = dict.name_prefix.pick_random()
	if region_prefix[region_prefix.length()-1]==' ' && region_name[0]==' ':
		data.name = (region_prefix + region_name.substr(1)).capitalize()
	else:
		data.name = (region_prefix + region_name).capitalize()
	if tier<0:
		tier_multiplier = 1.0/pow(1.5, -tier)
	elif tier>0:
		tier_multiplier = pow(1.5, tier)
	for i in range(NUM_CITIES):
		var city_name: String
		for _j in range(20):
			city_name = get_city_name(dict.city_name)
			if !(city_name in data.cities):
				break
		data.cities.push_back(city_name)
	for i in range(NUM_LOCATIONS):
		var base: String = dict.location_name.pick_random()
		var location_name: String
		for _j in range(20):
			location_name = (dict.location_prefix.pick_random()+" "+base).capitalize()
			if !(location_name in data.locations):
				break
		data.locations.push_back(location_name)
		if dict.has("location_enemies") && dict.location_enemies.has(base):
			data.location_enemies[location_name] = dict.location_enemies[base]
		else:
			data.location_enemies[location_name] = dict.enemies
		if dict.location_resources.has(base):
			data.location_resources[location_name] = dict.location_resources[base]
		else:
			data.location_resources[location_name] = dict.resources
	for array in data.local_materials.values():
		for mat in array:
			mat.quality *= tier_multiplier*level_multiplier
	data.description = get_region_description(data)
	return data


func select_next_region(level: int) -> String:
	var valid:= []
	var level_cap:= 5
	
	while valid.size()==0:
		for k in regions.keys():
			if abs(regions[k].level-level)<level_cap:
				valid.push_back(k)
		level_cap += randi_range(4,8)
	
	if valid.size()>0:
		return valid.pick_random()
	return regions.keys().pick_random()


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
		var data: Dictionary = JSON.parse_string(raw)
		var ID: String
		var from: int
		if data==null || data.size()==0:
			printt("Error parsing " + file_name + "!")
			continue
		from = file_name.rfind('/') + 1
		ID = file_name.substr(from, file_name.rfind('.') - from)
		regions[ID] = data
		file.close()

func _ready():
	load_data(Skills.get_file_paths("res://data/regions"))
	
