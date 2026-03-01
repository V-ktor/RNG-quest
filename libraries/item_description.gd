extends Node
class_name ItemDescription

const RANDOM_CARDS: Array[String] = [
	"theme",
	"shape",
	"color",
	"liquid",
	"element",
	"curse",
	"quality",
	"weakness",
	"craftmanship",
	"mental_illness",
	"stains",
	"enemy",
	"prophecy",
	"emotion",
	"origin",
	"force",
	"care",
	"crime",
]

var texts: Array[Dictionary] = []
var texts_by_type: Dictionary[String, Array] = {}
var cards: Dictionary[String, Dictionary] = {}
var properties: Dictionary[String, Array] = {}


func create_description_data(item: ItemEquipment, rank: int) -> Dictionary[Vector2i, Descriptions.Card]:
	var card_set: Dictionary[Vector2i, Descriptions.Card] = {}
	var craftmanship: Dictionary
	Descriptions.add_card(
		card_set,
		create_card("object", item.properties as Dictionary),
		Vector2i(0, 0),
	)
	
	if "enchantments" in item:
		for enchantment: Item.Enchantment in (item.enchantments as Dictionary).values():
			var quality:= []
			var elements:= []
			match enchantment.type:
				"attack", "accuracy", "armour", "penetration", "physical_resistance", \
				"physical_damage":
					match item.base_name:
						"dagger", "sword", "axe", "spellblade", "greatsword", "battleaxe", \
						"scythe", "gun_blade":
							quality.append({
								"singular": "blade",
								"plural": "blades",
								"adjective": "sharp",
							})
						"mace", "greatmaul", "quarterstaff":
							quality.append({
								"singular": "hammer",
								"plural": "hammers",
								"adjective": "blunt",
							})
						"morningstar":
							quality.append({
								"singular": "spike",
								"plural": "spikes",
								"adjective": "sharp",
							})
						"spear":
							quality.append({
								"singular": "tip",
								"plural": "tips",
								"adjective": "pointy",
							})
						"buckler", "kite_shield", "tower_shield", "chain_saw":
							quality.append({
								"singular": "metal",
								"adjective": "polished",
							})
						_:
							quality.append([
								{
									"singular": "spike",
									"plural": "spikes",
									"adjective": "sharp",
								},
								{
									"singular": "blade",
									"plural": "blades",
									"adjective": "sharp",
								},
								{
									"singular": "tip",
									"plural": "tips",
									"adjective": "pointy",
								},
								{
									"singular": "hammer",
									"plural": "hammers",
									"adjective": "blunt",
								},
								{
									"singular": "metal",
									"adjective": "polished",
								},
								{
									"singular": "barb",
									"plural": "barbs",
									"adjective": "vile",
								},
							].pick_random())
				"magic", "willpower":
					Descriptions.add_card(card_set, create_card("element"), Utils.get_closest_position(
						Vector2i(0, 0), card_set.keys()))
				"evasion", "speed":
					Descriptions.add_card(card_set, create_card("liquid"), Utils.get_closest_position(
						Vector2i(0, 0), card_set.keys()))
				"health", "health_regen", "stamina", "stamina_regen", "mana", "mana_regen", "focus":
					Descriptions.add_card(card_set, create_card("liquid"), Utils.get_closest_position(
						Vector2i(0, 0), card_set.keys()))
				"strength", "constitution", "dexterity", "cunning", "intelligence", "wisdom":
					Descriptions.add_card(card_set, create_card("stains"), Utils.get_closest_position(
						Vector2i(0, 0), card_set.keys()))
				_:
					if "elemental" in enchantment.type:
						elements.append([
							{
								"singular": "fire",
								"adjective": "fiery",
							},
							{
								"plural": "flames",
								"adjective": "flaming",
							},
							{
								"singular": "ember",
								"plural": "embers",
								"adjective": "burning",
							},
							{
								"singular": "ice",
								"adjective": "icy",
							},
							{
								"singular": "frost",
								"adjective": "cold",
							},
							{
								"singular": "lightning",
								"adjective": "sparkling",
							},
							{
								"singular": "electricity",
								"adjective": "jolting",
							},
						].pick_random())
					if "nature" in enchantment.type:
						elements.append([
							{
								"singular": "water",
								"plural": "waters",
								"adjective": "watery",
							},
							{
								"singular": "wind",
								"plural": "winds",
								"adjective": "windy",
							},
							{
								"singular": "air",
								"adjective": "airy",
							},
							{
								"singular": "earth",
								"adjective": "dirty",
							},
							{
								"singular": "rock",
								"plural": "rocks",
								"adjective": "rocky",
							},
						].pick_random())
					if "celestial" in enchantment.type:
						elements.append([
							{
								"singular": "light",
								"plural": "lights",
								"adjective": "bright",
							},
							{
								"singular": "darkness",
								"plural": "shadows",
								"adjective": "dark",
							},
							{
								"singular": "twilight",
								"adjective": "shimmering",
							},
						].pick_random())
			if quality.size() > 0:
				Descriptions.add_card(
					card_set,
					create_card(
						"quality",
						quality.pick_random() as Dictionary,
					),
					Utils.get_closest_position(Vector2i(0, 0), card_set.keys()),
				)
			if elements.size() > 0:
				Descriptions.add_card(
					card_set,
					create_card(
						"element",
						elements.pick_random() as Dictionary,
					),
					Utils.get_closest_position(Vector2i(0, 0), card_set.keys()),
				)
	
	for component in item.components:
		if typeof(component) != TYPE_DICTIONARY:
			continue
		var position:= Utils.get_closest_position(Vector2i(0, 0), card_set.keys())
		Descriptions.add_card(
			card_set,
			create_card(
				"component",
				component.properties,
			),
			position,
		)
		if "material" in component:
			var mat_pos:= Utils.get_closest_position(position + Utils.DIRECTIONS.pick_random() as Vector2i,
				card_set.keys())
			Descriptions.add_card(
				card_set,
				create_card(
					"material",
					component.material.properties,
				),
				mat_pos,
			)
	
	if rank < 2 or (rank < 6 && randf() < 0.1):
		Descriptions.add_card(
			card_set,
			create_card("weakness"),
			Utils.get_closest_position(Utils.DIRECTIONS.pick_random() as Vector2i, card_set.keys()),
		)
	
	if rank < 2:
		craftmanship = [
			{
				"singular": "amateur",
				"adjective": "amateurish",
				"adverb": "amateurishly",
			},
			{
				"singular": "unskilled craftsman",
				"adjective": "thoughtless",
				"adverb": "thoughtlessly",
			},
			{
				"singular": "novice craftsman",
				"adjective": "acceptable",
				"adverb": "acceptably",
			},
		].pick_random()
	elif rank < 4:
		craftmanship = [
			{
				"singular": "novice craftsman",
				"adjective": "acceptable",
				"adverb": "acceptably",
			},
			{
				"singular": "professional",
				"adjective": "professional",
				"adverb": "professionally",
			},
			{
				"singular": "experienced craftsman",
				"adjective": "inspiring",
				"adverb": "skillfully",
			},
		].pick_random()
	elif rank < 6:
		craftmanship = [
			{
				"singular": "skilled craftsman",
				"adjective": "skillful",
				"adverb": "skillfully",
			},
			{
				"singular": "master craftsman",
				"adjective": "masterful",
				"adverb": "masterfully",
			},
			{
				"singular": "legendary craftsman",
				"adjective": "legendary",
				"adverb": "legendaryly",
			},
		].pick_random()
	else:
		craftmanship = {
			"singular": "legendary craftsman",
			"adjective": "legendary",
			"adverb": "legendaryly",
		}
	Descriptions.add_card(card_set, create_card("craftmanship", craftmanship),
		Utils.get_closest_position(Utils.DIRECTIONS.pick_random() as Vector2i, card_set.keys()))
	
	Descriptions.add_card(card_set, create_card("color"),
		Utils.get_closest_position(Utils.DIRECTIONS.pick_random() as Vector2i, card_set.keys()))
	
	var care: Dictionary
	if rank < 2:
		care = [
			{
				"singular": "neglect",
				"adjective": "worn-down",
			},
			{
				"singular": "aging",
				"adjective": "old",
			},
			{
				"singular": "rot",
				"adjective": "rotten",
			},
		].pick_random()
	elif rank < 6:
		care = [
			{
				"singular": "polishing",
				"adjective": "polished",
			},
			{
				"singular": "sharpening",
				"adjective": "sharpened",
			},
			{
				"singular": "oiling",
				"adjective": "well oiled",
			},
		].pick_random()
	else:
		care = [
			{
				"plural": "legends",
				"adjective": "legendary",
			},
			{
				"singular": "perfection",
				"adjective": "perfect",
			},
		].pick_random()
	Descriptions.add_card(card_set, create_card("care", care),
		Utils.get_closest_position(Utils.DIRECTIONS.pick_random() as Vector2i, card_set.keys()))
	
	if "source_race" in item:
		var enemies:= []
		match item.source_race:
			"elemental":
				enemies.append({
					"singular": "elemental",
					"plural": "elementals",
					"adjective": "elemental",
				})
			"robot":
				enemies.append({
					"singular": "robot",
					"plural": "robots",
					"adjective": "computronic",
				})
			"undead":
				enemies.append({
					"plural": "undead", 
					"adjective": "undead",
				})
			"construct":
				enemies.append({
					"singular": "construct",
					"plural": "constructs",
					"adjective": "artificial",
				})
			"goblin":
				enemies.append({
					"singular": "goblin",
					"plural": "goblins",
					"adjective": "primitive",
				})
			"gnoll":
				enemies.append({
					"singular": "gnoll",
					"plural": "gnolls",
					"adjective": "aggressive",
				})
			"troll":
				enemies.append({
					"singular": "troll",
					"plural": "trolls",
					"adjective": "sturdy",
				})
			"beast":
				enemies.append({
					"singular": "beast",
					"plural": "beasts",
					"adjective": "wild",
				})
			"demon":
				enemies.append({
					"singular": "demon",
					"plural": "demons",
					"adjective": "evil",
				})
			"plant":
				enemies.append({
					"plural": "plants",
					"adjective": "phototropic",
				})
			"human":
				enemies.append({
					"singular": "human",
					"plural": "mankind",
					"adjective": "man-made",
				})
			"halfling":
				enemies.append({
					"singular": "halfling",
					"plural": "halflings",
					"adjective": "short",
				})
			"elf":
				enemies.append({
					"singular": "elf",
					"plural": "elves",
					"adjective": "elegant",
				})
			"dwarf":
				enemies.append({
					"singular": "dwarf",
					"plural": "dwarves",
					"adjective": "robust",
				})
			"naga":
				enemies.append({
					"singular": "naga",
					"plural": "naga",
					"adjective": "vile",
				})
			"orc":
				enemies.append({
					"singular": "orc",
					"plural": "orcs",
					"adjective": "brutal",
				})
			"ogre":
				enemies.append({
					"singular": "ogre",
					"adjective": "huge",
				})
			"cyborg":
				enemies.append({
					"singular": "cyborg",
					"plural": "cyborgs",
					"adjective": "cybertronic",
				})
			_:
				Descriptions.add_card(card_set, create_card("enemy"),
					Utils.get_closest_position(Utils.DIRECTIONS.pick_random() as Vector2i, card_set.keys()))
	
	if rank > 2:
		@warning_ignore("integer_division")
		for i in range(min(int((rank - 1) / 2), 2)):
			var card_pos:= Utils.get_closest_position(Utils.DIRECTIONS.pick_random() as Vector2i,
				card_set.keys())
			Descriptions.add_card(card_set, create_card(RANDOM_CARDS.pick_random() as String), card_pos)
	
	return card_set


func create_card(type: String, attributes_override:= {}) -> Descriptions.Card:
	var card := {
		"type": type,
		"properties": attributes_override.duplicate(true),
	}
	if type in self.cards:
		var definition: Dictionary = self.cards[type]
		for attribute: String in definition.get("properties", []):
			if attribute in attributes_override:
				card.properties[attribute] = tr(attributes_override[attribute] as String)
			elif attribute in self.properties:
				var data: Variant = properties[attribute].pick_random()
				if typeof(data) == TYPE_DICTIONARY:
					card.properties[attribute] = tr(
						(data as Dictionary).get("default", (data as Dictionary).values().pick_random()) as String,
					)
					for key: String in (data as Dictionary).keys():
						if key == "default":
							continue
						if key not in card.properties or key == attribute:
							card.properties[key] = tr(data[key] as String)
				else:
					card.properties[attribute] = tr(data as String)
			else:
				# fallback: just use some random word lol
				card.properties[attribute] = Descriptions.pick_attribute(self.properties.values().pick_random())
	if "singular" not in card.properties and "plural" not in card.properties:
		if "name" in attributes_override:
			card.properties.singular = tr(card.properties.name as String)
		elif "recipe" in attributes_override:
			card.properties.singular = tr(card.properties.recipe as String)
		elif type in properties:
			var data: Variant = properties[type].pick_random()
			if typeof(data) == TYPE_DICTIONARY:
				if "singular" in data:
					card.properties.singular = tr(data.singular as String)
				if "plural" in data:
					card.properties.plural = tr(data.plural as String)
				if "singular" not in data && "plural" not in data:
					card.properties.singular = tr(
						(data as Dictionary).get("default", (data as Dictionary).values().pick_random()) as String,
					)
				for key: String in (data as Dictionary).keys():
					if key == "default":
						continue
					if key in data && key not in card.properties:
						card.properties[key] = tr(data[key] as String)
			else:
				card.properties.singular = tr(data as String)
	if "adjective" not in card.properties:
		if "singular" in card.properties:
			card.properties.adjective = (card.properties.singular as String).replace(" ", "-") + "-like"
		elif "plural" in card.properties:
			card.properties.adjective = (card.properties.plural as String).replace(" ", "-") + "-like"
	return Descriptions.Card.new(card)


func create_card_set(item: ItemEquipment) -> Dictionary[Vector2i, Descriptions.Card]:
	var card_set: Dictionary[Vector2i, Descriptions.Card] = {}
	Descriptions.add_card(
		card_set,
		self.create_card("object", item.properties),
		Vector2i(0, 0),
	)
	Descriptions.add_card(
		card_set,
		self.create_card(RANDOM_CARDS.pick_random() as String),
		Utils.DIRECTIONS.pick_random() as Vector2i,
	)
	
	for component in item.components:
		var position := Utils.get_closest_position(Vector2i(0, 0), card_set.keys())
		Descriptions.add_card(card_set, create_card("component", component.properties), position)
		
		var mat_pos := Utils.get_closest_position(
			position + Utils.DIRECTIONS.pick_random() as Vector2i,
			card_set.keys(),
		)
		Descriptions.add_card(card_set, create_card("material", component.material.properties), mat_pos)
			
		var card_pos := Utils.get_closest_position(mat_pos, card_set.keys())
		Descriptions.add_card(card_set, create_card(RANDOM_CARDS.pick_random() as String), card_pos)
	
	for i in range(3):
		var card_pos := Utils.get_closest_position(Utils.DIRECTIONS.pick_random() as Vector2i, card_set.keys())
		Descriptions.add_card(card_set, create_card(RANDOM_CARDS.pick_random() as String), card_pos)
	
	return card_set


func generate_description(card_set: Dictionary[Vector2i, Descriptions.Card], max_sentences:= 3) -> String:
	return Descriptions.generate_description(
		card_set,
		Callable(self, "create_card"),
		self.texts_by_type,
		self.RANDOM_CARDS,
		self.properties,
		max_sentences,
	)


func load_text_data(path: String) -> void:
	for file_name in Utils.get_file_paths(path):
		var file := FileAccess.open(file_name, FileAccess.READ)
		var error := FileAccess.get_open_error()
		if error != OK:
			print("Can't open file " + file_name + "!")
			continue
		else:
			print("Loading items " + file_name + '.')
		
		var raw := file.get_as_text()
		var array : Array = JSON.parse_string(raw) as Array
		if array == null || array.size() == 0:
			print("Error parsing " + file_name + "!")
			continue
		for text_data: Dictionary in array:
			self.texts.push_back(text_data)
			if "type" in text_data:
				if text_data.type in self.texts_by_type:
					self.texts_by_type[text_data.type].push_back(text_data)
				else:
					self.texts_by_type[text_data.type] = [text_data]
		file.close()

func load_card_data(path: String) -> void:
	for file_name in Utils.get_file_paths(path):
		var file := FileAccess.open(file_name, FileAccess.READ)
		var error := FileAccess.get_open_error()
		if error != OK:
			print("Can't open file " + file_name + "!")
			continue
		else:
			print("Loading items " + file_name + '.')
		
		var raw := file.get_as_text()
		var dict : Dictionary = JSON.parse_string(raw)
		if dict == null || dict.size() == 0:
			print("Error parsing " + file_name + "!")
			continue
		for key: String in dict:
			self.cards[key] = dict[key]
		file.close()

func load_property_data(path: String) -> void:
	for file_name in Utils.get_file_paths(path):
		var file := FileAccess.open(file_name, FileAccess.READ)
		var error := FileAccess.get_open_error()
		if error != OK:
			print("Can't open file " + file_name + "!")
			continue
		else:
			print("Loading items " + file_name + '.')
		
		var raw := file.get_as_text()
		var dict: Dictionary = JSON.parse_string(raw)
		if dict == null || dict.size() == 0:
			print("Error parsing " + file_name + "!")
			continue
		for key: String in dict:
			self.properties[key] = dict[key]
		file.close()


func _ready() -> void:
	load_text_data("res://data/items/texts")
	load_card_data("res://data/items/cards")
	load_property_data("res://data/items/properties")
