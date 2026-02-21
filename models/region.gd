extends RefCounted
class_name Region

var name: String
var level: int
var tier: int
var description: String
var enchantment_chance: float
var resource_chance: float
var race: Array[String]
var enemy: Array[String]
var cities: Dictionary[String, Location]
var locations: Dictionary[String, Location]
var enemies: Array[String]
var enemy_amount: Array[int]
var resource_amount: Array[int]
var resources: Array[String]
var local_materials: Dictionary[String, Array]
var setting: String


func _init(dict: Dictionary) -> void:
	var city_dict: Dictionary
	var location_dict: Dictionary
	var material_dict: Dictionary
	
	self.name = dict.get("name", "unknown region") as String
	self.level = dict.get("level", 1) as int
	self.tier = dict.get("tier", 0) as int
	self.description = dict.get("description", "") as String
	self.enchantment_chance = dict.get("enchantment_chance", 0.1) as float
	self.resource_chance = dict.get("resource_chance", 0.1) as float
	self.race = []
	for r: String in dict.get("race", ["human"]):
		self.race.push_back(r)
	self.enemy = []
	for e: String in dict.get("enemy", ["orc"]):
		self.enemy.push_back(e)
	self.cities = {}
	city_dict = dict.get("cities", {})
	for city: String in city_dict:
		var data: Dictionary[String, Variant] = {}
		for key: String in city_dict[city]:
			if typeof(key) != TYPE_STRING:
				continue
			data[key] = city_dict[city][key]
		self.cities[city] = Location.new(data)
	self.locations = {}
	location_dict = dict.get("locations", {})
	for location: String in location_dict:
		var data: Dictionary[String, Variant] = {}
		for key: String in location_dict[location]:
			if typeof(key) != TYPE_STRING:
				continue
			data[key] = location_dict[location][key]
		self.locations[location] = Location.new(data)
	self.enemies = []
	for e in dict.get("enemies", []):
		self.enemies.push_back(e)
	self.enemy_amount = []
	for a in dict.get("enemy_amount", [1, 4]):
		self.enemy_amount.push_back(int(a))
	self.resource_amount = []
	for a in dict.get("resource_amount", [1, 4]):
		self.resource_amount.push_back(int(a))
	self.resources = []
	for r in dict.get("resources", []):
		self.resources.push_back(r)
	self.local_materials = {}
	material_dict = dict.get("local_materials", {})
	for key in material_dict:
		self.local_materials[key] = material_dict[key]
	self.setting = dict.get("setting", "fantasy") as String

func to_dict() -> Dictionary[String, Variant]:
	var city_dict: Dictionary[String, Dictionary] = {}
	var location_dict: Dictionary[String, Dictionary] = {}
	for key in self.cities:
		city_dict[key] = self.cities[key].to_dict()
	for key in self.locations:
		location_dict[key] = self.locations[key].to_dict()
	return {
		"name": self.name,
		"level": self.level,
		"tier": self.tier,
		"description": self.description,
		"enchantment_chance": self.enchantment_chance,
		"resource_chance": self.resource_chance,
		"race": self.race,
		"enemy": self.enemy,
		"cities": city_dict,
		"locations": location_dict,
		"enemies": self.enemies,
		"enemy_amount": self.enemy_amount,
		"resource_amount": self.resource_amount,
		"resources": self.resources,
		"local_materials": self.local_materials,
		"setting": self.setting,
	}
