extends Node

var cards:= {}
var attributes:= {}
var relations:= {}


class Card:
	var type: String
	var position: Vector2i
	var attributes: Dictionary
	var relations: Dictionary
	
	func _init(dict: Dictionary):
		for key in dict.keys():
			set(key, dict[key])
	
	func pick_random_adjective() -> String:
		var valid:= []
		for dict in attributes.values():
			if "adjective" in dict:
				valid.push_back(dict.adjective)
		if valid.size() > 0:
			return valid.pick_random()
		return ""
	
	func get_decorated_card_name(function: String, plural:= false, known:= false) -> String:
		var name_text:= ""
		var has_adjective:= false
		if not plural and "singular" not in attributes.name and "plural" in attributes.name:
			plural = true
		if plural and "plural" not in attributes.name and "singular" in attributes.name:
			plural = false
		if "singular" not in attributes.name and "plural" not in attributes.name:
			print("Warning: card without singular nor plural name: " + type)
			attributes.name.singular = type
			plural = false
		
		if plural:
			name_text = attributes.name.plural
		else:
			name_text = attributes.name.singular
		
		# prepend adjective
		if randf() < 0.5:
			var adjective:= pick_random_adjective()
			name_text = adjective + " " + name_text
			has_adjective = true
		
		# prepend article
		# TODO: replace "a" by "an" if needed
		if not plural and "article_singular" in attributes.name:
			if attributes.name.article_singular != "":
				if attributes.name.article_singular == "a":
					name_text = Utils.get_a_an(name_text) + " " + name_text
				else:
					name_text = attributes.name.article_singular + " " + name_text
		elif plural and "article_plural" in attributes.name:
			if attributes.name.article_plural != "":
				name_text = attributes.name.article_plural + " " + name_text
		elif "article" in attributes.name:
			if attributes.name.article != "":
				if attributes.name.article == "a":
					name_text = Utils.get_a_an(name_text) + " " + name_text
				else:
					name_text = attributes.name.article + " " + name_text
		else:
			if known:
				name_text = "the" + " " + name_text
			else:
				match function:
					"object":
						if has_adjective:
							name_text = Utils.get_a_an(name_text) + " " + name_text
						else:
							name_text = "the" + " " + name_text
					_:
						if not plural and not has_adjective:
							name_text = Utils.get_a_an(name_text) + " " + name_text
		
		return name_text
	
	func to_JSON_string() -> String:
		return JSON.stringify(self, "\t")


class CardSet:
	var cards: Dictionary
	var current_card: Card
	var current_sentence:= {}
	var current_used_cards:= []
	var current_plural:= false
	var last_object: Card
	var known_cards:= []
	var sentence_fragments:= {}
	var used_cards:= {}
	
	func _init(_cards:= {}):
		cards = _cards
	
	
	func new_sentence():
		if last_object != null:
			printt("last", last_object.type)
			current_card = last_object
			last_object = null
		else:
			current_card = null
		current_sentence.clear()
		sentence_fragments.clear()
	
	func get_valid_card_pos() -> Vector2i:
		var valid: Array[Vector2i] = []
		for pos in current_card.relations.keys():
			if pos in used_cards and used_cards[pos] > 1:
				# do not use cards more than two times in a paragraph
				continue
			var relation_data: Dictionary = Regions.Descriptions.relations[current_card.relations[pos]]
			var text_data: Dictionary = relation_data.texts.pick_random()
			if "predicate" in current_sentence && text_data.has("function") && \
				"subject" in text_data.function && "object" in text_data.function:
					continue
			valid.push_back(pos)
		
		if valid.size() > 0:
			return valid.pick_random()
		return current_card.relations.keys().pick_random()
	
	func get_function(type: String, function_dict: Dictionary) -> String:
		for function in function_dict:
			if function_dict[function] == type:
				return function
		return ""
	
	func add_text() -> String:
		var text:= ""
		var use_pronoun:= current_card != null
		
		if current_card != null:
			printt("current", current_card.type)
		else:
			printt("current", current_card)
		if current_card == null:
			current_card = cards.values().pick_random()
			use_pronoun = false
		while current_card.relations.size() == 0:
			current_card = cards.values().pick_random()
			use_pronoun = false
		
		var pos: Vector2i = get_valid_card_pos()
		var card_to: Card = cards[pos]
		var relation_data: Dictionary = Regions.Descriptions.relations[current_card.relations[pos]]
		var text_data: Dictionary = relation_data.texts.pick_random()
		var raw_text: String = text_data.text.pick_random()
		var format_dict:= {}
		var re:= RegEx.new()
		var results: Array[RegExMatch]
		re.compile(r"{([\w\.'/]+)}")
		results = re.search_all(raw_text)
		
		if pos in used_cards:
			used_cards[pos] += 1
		else:
			used_cards[pos] = 1
		if current_card.position in used_cards:
			used_cards[current_card.position] += 1
		else:
			used_cards[current_card.position] = 1
		
		printt(text_data, current_card.attributes, card_to.attributes, known_cards)
		
		for result in results:
			var result_string:= result.get_string(1)
			print(result.get_string(1))
			match result_string:
				"from":
					if sentence_fragments.has("subject") && text_data.function.get("subject") == "from":
						format_dict.from = sentence_fragments.subject
					else:
						if "singular" in current_card.attributes.name:
							current_plural = false
						elif "plural" in current_card.attributes.name:
							current_plural = true
						if use_pronoun:
							if current_plural:
								format_dict.from = "they"
							else:
								format_dict.from = "it"
						else:
							format_dict.from = current_card.get_decorated_card_name(
								get_function("from", text_data.function),
								current_plural,
								current_card.type in known_cards)
				"to":
					if sentence_fragments.has("subject") && text_data.function.get("subject") == "to":
						format_dict.from = sentence_fragments.subject
					else:
						var plural: bool = "plural" in card_to.attributes.name && not "singular" in card_to.attributes.name
						format_dict.to = card_to.get_decorated_card_name(
							get_function("to", text_data.function),
							plural,
							card_to.type in known_cards)
			if "/" in result_string:
				var array:= result_string.split("/")
				format_dict[result_string] = array[int(current_plural)]
		
		current_used_cards.push_back(pos)
		for key in text_data.get("function", {}):
			current_sentence[key] = text_data.function[key]
		
		if "predicate" not in text_data.function && "predicate" not in current_sentence:
			if "subject" in text_data.function:
				sentence_fragments["subject"] = raw_text.format(format_dict)
			elif "object" in text_data.function:
				sentence_fragments["object"] = raw_text.format(format_dict)
		else:
			text = raw_text.format(format_dict)
		if current_card.type not in known_cards:
			known_cards.push_back(current_card.type)
		if card_to.type not in known_cards:
			known_cards.push_back(card_to.type)
		last_object = card_to
		
		return text
	
	
	func generate_description(no_sentences: int) -> String:
		var text:= ""
		var number:= 0
		
		for i in range(no_sentences):
			new_sentence()
			while true:
				var new_text:= add_text()
				if new_text.length() > 0:
					new_text[0] = new_text[0].to_upper()
					text += new_text
				number += 1
				if ("subject" in current_sentence && "predicate" in current_sentence) || number > 2:
					if text.length() > 0 && text.right(1) != ' ':
						text += ". "
					break
				elif text.length() > 0 && text.right(1) != ' ':
					text += " "
		known_cards.clear()
		
		return text
	



func get_attribute(type: String) -> Dictionary:
	if type not in attributes:
		print("Warning: attribute " + type + " not found!")
		return attributes.values().pick_random().pick_random()
	return attributes[type].pick_random()


func create_card(type: String, position: Vector2i) -> Card:
	var data:= {
		"type": type,
		"position": position,
		"attributes": {},
	}
	if type not in cards:
		type = cards.keys().pick_random()
		data.type = type
	for key in cards[type].attributes:
		data.attributes[key] = get_attribute(key)
	data.attributes.name = cards[type].name.pick_random()
	return Card.new(data)

func add_card(card_set: CardSet, type: String, position: Vector2i) -> Card:
	var pos:= Utils.get_closest_position(position, card_set.cards.keys())
	card_set.cards[pos] = create_card(type, pos)
	return card_set.cards[pos]

func connect_cards(from: Card, to: Card):
	var valid_relations:= []
	for key in relations.keys():
		var relation: Dictionary = relations[key]
		if "from_filter" in relation && from.type not in relation.from_filter:
			continue
		if "to_filter" in relation && to.type not in relation.to_filter:
			continue
		valid_relations.push_back(key)
	if valid_relations.size() > 0:
		var key: String = valid_relations.pick_random()
		from.relations[to.position] = key


func get_empty_position(card_set: CardSet, next_to: Vector2i) -> Vector2i:
	for i in range(1, 10):
		for offset in Utils.DIRECTIONS:
			var pos: Vector2i = next_to + i * offset
			if pos not in card_set.cards:
				return pos
	return next_to + Vector2i(randi_range(-10, 10), randi_range(-10, 10))

func is_related(card_a: Card, card_b: Card) -> bool:
	if card_a.type == card_b.type:
		return false
	for relation in relations.values():
		var has_a:= false
		var has_b:= false
		if "from_filter" in relation:
			if card_a.type in relation.from_filter:
				has_a = true
			if card_b.type in relation.from_filter:
				has_b = true
		if "to_filter" in relation:
			if card_a.type in relation.to_filter:
				has_a = true
			if card_b.type in relation.to_filter:
				has_b = true
		if has_a and has_b:
			return true
	return false

func get_valid_cards(card_set: CardSet, position: Vector2i) -> Array:
	var valid_cards:= []
	var neighbor_cards:= []
	for pos in Utils.DIRECTIONS:
		if position + pos in card_set.cards:
			neighbor_cards.push_back(card_set.cards[position + pos].type)
	for relation in relations.values():
		var valid:= false
		if "from_filter" in relation:
			for type in neighbor_cards:
				if type in relation.from_filter:
					valid = true
					break
		if "to_filter" in relation:
			for type in neighbor_cards:
				if type in relation.to_filter:
					valid = true
					break
		if !valid:
			continue
		if "from_filter" in relation:
			for type in relation.from_filter:
				if type in neighbor_cards:
					continue
				valid_cards.push_back(type)
		if "to_filter" in relation:
			for type in relation.to_filter:
				if type in neighbor_cards:
					continue
	return valid_cards

func place_random_card(card_set: CardSet, position: Vector2i) -> Card:
	var valid_cards:= get_valid_cards(card_set, position)
	var type: String
	var card: Card
	if valid_cards.size() == 0:
		type = cards.keys().pick_random()
	else:
		type = valid_cards.pick_random()
	
	card = add_card(card_set, type, position)
	for pos in Utils.DIRECTIONS:
		if position + pos not in card_set.cards:
			continue
		connect_cards(card, card_set.cards[position + pos])
	return card

func create_card_set(allowed_cards: Array) -> CardSet:
	var card_set:= CardSet.new()
	var position:= Utils.DIRECTIONS.pick_random() as Vector2i
	var last_card: Card
	allowed_cards.shuffle()
	
	last_card = add_card(card_set, allowed_cards[0], Vector2i(0, 0))
	for i in range(1, allowed_cards.size()):
		var card_type:= allowed_cards[i] as String
		var new_card:= add_card(card_set, card_type, position)
		for offset in Utils.DIRECTIONS:
			if position + offset not in card_set.cards:
				continue
			connect_cards(new_card, card_set.cards[position + offset])
		
		position = get_empty_position(card_set, position)
		
		if not is_related(last_card, new_card):
			var rng_card:= place_random_card(card_set, position)
			connect_cards(last_card, rng_card)
			connect_cards(rng_card, new_card)
			position = get_empty_position(card_set, position)
	
	return card_set



func load_data(path: String, store_dict: Dictionary):
	for file_name in Utils.get_file_paths(path):
		var file:= FileAccess.open(file_name, FileAccess.READ)
		var error:= FileAccess.get_open_error()
		if error!=OK:
			print("Can't open file " + file_name + "!")
			continue
		else:
			print("Loading descriptions " + file_name + '.')
		
		var raw:= file.get_as_text()
		var dict: Dictionary = JSON.parse_string(raw)
		if dict==null || dict.size()==0:
			printt("Error parsing " + file_name + "!")
			continue
		for key in dict:
			store_dict[key] = dict[key]
		file.close()

func load_card_data(path: String):
	load_data(path, cards)

func load_attribute_data(path: String):
	load_data(path, attributes)

func load_relation_data(path: String):
	load_data(path, relations)


#func _process(_delta: float):
	#var card_set := create_card_set(["cave_entrance", "cave", "cave_floor", "rock_wall",
		#"stalagmites", "shadow", "vegetation_underground", "ceiling", "bridge", "web", "darkness"])
	#printt(card_set.cards)
	#printt(card_set.generate_description(3))
	#
	##var card_set:= CardSet.new()
	##var hill:= add_card(card_set, "hill", Vector2i(0, 0))
	##var vegetation:= add_card(card_set, "vegetation", Vector2i(0, 1))
	##var horizon:= add_card(card_set, "horizon", Vector2i(-1, 0))
	##connect_cards(vegetation, hill)
	##connect_cards(hill, horizon)
	##
	##place_random_card(card_set, Vector2i(1, 0))
	##place_random_card(card_set, Vector2i(1, 1))
	##place_random_card(card_set, Vector2i(0, -1))
	##place_random_card(card_set, Vector2i(-1, -1))
	##
	##printt(card_set.generate_description(3))
	#
	#set_process(false)

func _ready():
	load_card_data("res://data/region_descriptions/cards")
	load_attribute_data("res://data/region_descriptions/attributes")
	load_relation_data("res://data/region_descriptions/relations")
