extends Node

const NUM_CITIES = 4
const NUM_LOCATIONS = 12
const REGION_TIERS = [
	"SAFE",
	"TRANQUIL",
	"AVERAGE",
	"TUMULTUOUS",
	"DANGEROUS",
	"HAZARDOUS",
	"HOSTILE",
]

var regions:= {}

@onready
var Descriptions:= $RegionDescription


func get_location_list(region: Region, current_location: String) -> Array[Dictionary]:
	var cities: int = region.cities.size()
	var locations: int = region.locations.size()
	var city_index:= 0
	var list: Array[Dictionary] = []
	var is_current_location_listed:= false
	
	for i in range(locations):
		var key: String = region.locations.keys()[i]
		var data: Location = region.locations[key]
		if key == current_location:
			is_current_location_listed = true
		list.push_back({"name": data.name, "type": data.type})
		if float(i) / float(locations) >= float(city_index) / float(cities) && city_index < cities:
			key = region.cities.keys()[city_index]
			data = region.cities[key]
			if key == current_location:
				is_current_location_listed = true
			list.push_back({
				"name": data.name,
				"type": data.type,
			})
			city_index += 1
	for i in range(city_index, cities):
		var key: String = region.cities.keys()[city_index]
		var data: Location = region.cities[key]
		if key == current_location:
			is_current_location_listed = true
		list.push_back({
			"name": data.name,
			"type": data.type,
		})
	if not is_current_location_listed:
		list.push_back({
			"name": current_location,
			"type": "dungeon",
		})
	
	return list

func get_region_description(region: Region) -> String:
	var text: String = region.name
	text += "\n" + tr("LVL") + " " + str(region.level) + " " + \
		tr(REGION_TIERS[clamp(region.tier + 2, 0, REGION_TIERS.size() - 1)]) + " " + tr("REGION")
	if region.race.size()>0:
		text += "\n" + tr("RACE") + ": " + Names.make_list(region.race)
	return text

func get_city_data(array: Array) -> Dictionary:
	var dict: Dictionary = array.pick_random()
	var city_name: String = dict.base.pick_random()
	if dict.has("prefix"):
		var city_prefix: String = dict.prefix.pick_random()
		if city_prefix[city_prefix.length()-1] == ' ' && city_name[0] == ' ':
			name = (city_prefix + city_name.substr(1)).capitalize()
		else:
			name = (city_prefix + city_name).capitalize()
	if dict.has("suffix"):
		name += dict.suffix.pick_random()
	return {"name": name, "type": dict.type.pick_random()}

func create_region(ID: String, level:= 0, tier:= 0) -> Region:
	var dict: Dictionary = regions[ID]
	var data: Dictionary[String, Variant] = {
		"level": dict.level + level,
		"tier": dict.tier + tier,
		"race": dict.race,
		"enemy": dict.enemy,
		"cities": {},
		"locations": {},
		#"location_enemies": {},
		"enemies": dict.enemies,
		"enemy_amount": dict.enemy_amount.duplicate(),
		"local_materials": dict.local_materials.duplicate(true),
		"enchantment_chance": dict.enchantment_chance,
		"resources": dict.resources,
		#"location_resources": {},
		"resource_chance": dict.resource_chance,
		"resource_amount": dict.resource_amount,
	}
	var tier_multiplier:= 1.0
	var level_multiplier:= 1.0 + 0.1 * (level - 1)
	var region_name: String = dict.base_name.pick_random()
	var region_prefix: String = dict.name_prefix.pick_random()
	if region_prefix[region_prefix.length() - 1] == ' ' && region_name[0] == ' ':
		data.name = (region_prefix + region_name.substr(1)).capitalize()
	else:
		data.name = (region_prefix + region_name).capitalize()
	if tier<0:
		tier_multiplier = 1.0/pow(1.5, -tier)
	elif tier>0:
		tier_multiplier = pow(1.5, tier)
	for i in range(NUM_CITIES):
		var city_data: Dictionary
		for _j in range(20):
			city_data = get_city_data(dict.cities)
			if city_data.name not in data.cities:
				break
		data.cities[city_data.name] = city_data
	for i in range(NUM_LOCATIONS):
		var location_data: Dictionary = dict.locations.pick_random()
		var base: String = location_data.base.pick_random()
		var location_name: String
		for _j in range(20):
			location_name = (location_data.prefix.pick_random() + " " + base).capitalize()
			if location_name not in data.locations:
				break
		data.locations[location_name] = {
			"name": location_name,
			"type": location_data.type.pick_random(),
			"enemies": location_data.get("enemies", []),
			"resources": location_data.get("resources", []),
		}
	for array in data.local_materials.values():
		for mat in array:
			mat.quality *= tier_multiplier*level_multiplier
	var region:= Region.new(data)
	region.description = get_region_description(region)
	return region


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
		if error != OK:
			print("Can't open file " + file_name + "!")
			continue
		else:
			print("Loading region " + file_name + ".")
		
		var raw:= file.get_as_text()
		var data: Dictionary = JSON.parse_string(raw)
		var ID: String
		var from: int
		if data == null || data.size() == 0:
			printt("Error parsing " + file_name + "!")
			continue
		from = file_name.rfind('/') + 1
		ID = file_name.substr(from, file_name.rfind('.') - from)
		regions[ID] = data
		file.close()

func _ready():
	load_data(Utils.get_file_paths("res://data/regions"))
	
