extends RefCounted
class_name Guild

var is_available: bool
var name: String
var ID: String
var base_name: String
var level: int
var experience: int
var subject: String
var organization: String
var specialization: String
var distance: int
var max_range: int
var revival_chance: float
var rank_carry_over: float
var give_welcome_gift: bool
var give_parting_gift: bool
var description: String
var addendum: Array[String]
var abilities: Array[String]
var tags: Array[String]
var god: String
var ranks: Array[String]
var locations: Array[String]
var relics: Array[String]
var race: Array[String]
var exp_gain: Dictionary[String, int]


func on_travel(region: Region):
	self.distance += 1
	if self.revival_chance > 0.0 and randf() < self.revival_chance:
		self.is_available = true
	elif self.max_range > 0 && self.distance > self.max_range:
		self.is_available = false
	else:
		self.is_available = true
	if self.is_available:
		if self.addendum.size() > 0:
			self.name = self.base_name + " " + self.addendum.pick_random().format({
				"region": region.name,
				"city": region.cities.values().pick_random().name,
			})
		self.level = ceili(self.level * self.rank_carry_over)


func get_max_exp() -> int:
	return 600 + 400 * self.level * self.level


func add_exp(amount: float, type: String = "") -> void:
	self.experience += ceili(amount * self.exp_gain.get(type, 1.0))


func level_up() -> void:
	self.experience -= self.get_max_exp()
	self.level += 1


func get_rank() -> String:
	if self.ranks.size() == 0:
		return tr("UNKNOWN")
	if self.level >= self.ranks.size():
		return self.ranks[self.ranks.size() - 1] + " " + Skills.convert_to_roman_number(self.level - self.ranks.size() + 2)
	return self.ranks[self.level]


func _init(dict: Dictionary) -> void:
	var exp_gain_dict: Dictionary
	
	self.is_available = dict.get("is_available", true) as bool
	self.name = dict.get("name", "guild") as String
	self.base_name = dict.get("base_name", "guild" + str(randi())) as String
	self.ID = dict.get("ID", self.base_name) as String
	self.level = dict.get("level", 1) as int
	self.experience = dict.get("experience", 0) as int
	self.subject = dict.get("subject", "adventure") as String
	self.organization = dict.get("organization", "") as String
	self.specialization = dict.get("specialization", "") as String
	self.distance = dict.get("distance", 0) as int
	self.max_range = dict.get("max_range", 0) as int
	self.rank_carry_over = dict.get("rank_carry_over", 0.5) as float
	self.revival_chance = dict.get("revival_chance", 0.0) as float
	self.give_welcome_gift = dict.get("give_welcome_gift", false) as bool
	self.give_parting_gift = dict.get("give_parting_gift", false) as bool
	self.description =  dict.get("description", "")
	self.addendum = []
	for add in dict.get("addendum", []):
		self.addendum.push_back(add)
	self.abilities = []
	for ability in dict.get("abilities", []):
		self.abilities.push_back(ability)
	self.tags = []
	for tag in dict.get("tags", []):
		self.tags.push_back(tag)
	self.god = dict.get("god", "") as String
	self.ranks = []
	for rank in dict.get("ranks", []):
		self.ranks.push_back(rank)
	self.locations = []
	for location in dict.get("locations", []):
		self.locations.push_back(location)
	self.relics = []
	for relic in dict.get("relics", []):
		self.relics.push_back(relic)
	self.race = []
	for r in dict.get("race", []):
		self.race.push_back(r)
	exp_gain_dict = dict.get("exp_gain", {})
	self.exp_gain = {}
	for key in exp_gain_dict:
		if typeof(key) != TYPE_STRING:
			continue
		self.exp_gain[key] = int(exp_gain_dict[key])

func to_dict() -> Dictionary[String, Variant]:
	return {
		"is_available": self.is_available,
		"name": self.name,
		"ID": self.ID,
		"base_name": self.base_name,
		"level": self.level,
		"experience": self.experience,
		"subject": self.subject,
		"organization": self.organization,
		"specialization": self.specialization,
		"distance": self.distance,
		"max_range": self.max_range,
		"rank_carry_over": self.rank_carry_over,
		"give_welcome_gift": self.give_welcome_gift,
		"give_parting_gift": self.give_parting_gift,
		"description": self.description,
		"addendum": self.addendum,
		"abilities": self.abilities,
		"tags": self.tags,
		"god": self.god,
		"ranks": self.ranks,
		"locations": self.locations,
		"relics": self.relics,
		"race": self.race,
		"exp_gain": self.exp_gain,
	}
