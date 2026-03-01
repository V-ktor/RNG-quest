extends Node
class_name RegionDescription

const MAX_TEXT_LENGTH := 500
const RANDOM_CARDS: Array[String] = [
	"vegetation",
	"landmark",
	"ground",
	"air",
	"scent",
]

var texts: Array[Dictionary] = []
var texts_by_type: Dictionary[String, Array] = {}
var cards: Dictionary[String, Dictionary] = {}
var properties: Dictionary[String, Array] = {}


func check_tags_overlap(tags: Array[String], valid_tags: Array[String]) -> bool:
	for tag in tags:
		if tag in valid_tags:
			return true
	return false

func get_valid_cards_for_region(region: Region) -> Array[String]:
	var valid_cards: Array[String] = []
	for card_id in self.cards:
		if self.check_tags_overlap(Array(self.cards[card_id].get("tags", []) as Array, TYPE_STRING, "", null), region.tags):
			valid_cards.push_back(card_id)
	if valid_cards.size() == 0:
		print("Warning: no valid cards found for region " + region.name)
		return self.cards.keys()
	return valid_cards

func get_valid_attribute_for_region(data: Array[Dictionary], region: Region) -> String:
	var valid_attributes: Array[String] = []
	for dict in data:
		if "tags" in dict and not self.check_tags_overlap(Array(dict.tags, TYPE_STRING, "", null), region.tags):
			continue
		valid_attributes += Array(dict.get("names", []) as Array, TYPE_STRING, "", null)
	
	if valid_attributes.size() > 0:
		return valid_attributes.pick_random()
	# Fallback: just use some random word
	return Descriptions.pick_attribute(self.properties.values().pick_random())


func create_card(type: String, region: Region, attributes_override := {}) -> Descriptions.Card:
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
				var data: Variant = self.properties[attribute].pick_random()
				if typeof(data) == TYPE_DICTIONARY:
					var dict := data as Dictionary
					card.properties[attribute] = tr(
						dict.get("default", dict.values().pick_random()) as String,
					)
					for key: String in (data as Dictionary).keys():
						if key == "default":
							continue
						if key not in card.properties or key == attribute:
							card.properties[key] = tr(data[key] as String)
				else:
					card.properties[attribute] = tr(data as String)
			else:
				# Fallback: just use some random word
				card.properties[attribute] = Descriptions.pick_attribute(self.properties.values().pick_random())
		for attribute: String in definition.get("properties_by_tags", {}):
			if attribute in attributes_override:
				card.properties[attribute] = tr(attributes_override[attribute] as String)
			else:
				card.properties[attribute] = self.get_valid_attribute_for_region(Array(definition.properties_by_tags[attribute], TYPE_DICTIONARY, "", null), region)
	if "singular" not in card.properties and "plural" not in card.properties:
		if "name" in attributes_override:
			card.properties.singular = tr(card.properties.name as String)
		else:
			card.properties.singular = tr(type.to_upper())
	if "adjective" not in card.properties:
		if "singular" in card.properties:
			card.properties.adjective = (card.properties.singular as String).replace(" ", "-") + "ish"
		elif "plural" in card.properties:
			card.properties.adjective = (card.properties.plural as String).replace(" ", "-") + "ish"
	return Descriptions.Card.new(card)


func create_card_set(region: Region) -> Dictionary[Vector2i, Descriptions.Card]:
	var card_set: Dictionary[Vector2i, Descriptions.Card] = {}
	var valid_cards := self.get_valid_cards_for_region(region)
	Descriptions.add_card(
		card_set,
		self.create_card(self.RANDOM_CARDS.pick_random() as String, region),
		Vector2i(0, 0),
	)
	
	for i in range(12):
		var position := Utils.get_closest_position(Vector2i(0, 0), card_set.keys())
		Descriptions.add_card(
			card_set,
			self.create_card(valid_cards.pick_random() as String, region),
			position,
		)
	
	return card_set

func generate_description(card_set: Dictionary[Vector2i, Descriptions.Card], region: Region,
		max_sentences:= 3) -> String:
	var cc := func(type: String, attributes_override := {}) -> Descriptions.Card:
		return self.create_card(type, region, attributes_override)
	return Descriptions.generate_description(
		card_set,
		cc,
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
	load_text_data("res://data/regions/texts")
	load_card_data("res://data/regions/cards")
	load_property_data("res://data/regions/properties")
