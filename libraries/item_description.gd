extends Node

const MAX_TEXT_LENGTH = 500
const RANDOM_CARDS = [
	"theme", "shape", "color", "liquid", "element", "curse", "quality", "weakness", "craftmanship",
	"mental_illness", "stains", "enemy", "prophecy", "emotion", "origin", "force", "care", "crime",
]

var texts: Array[Dictionary] = []
var texts_by_type:= {}
var cards:= {}
var attributes:= {}


class TextState:
	var text: String
	var card_set: Dictionary
	var state: String
	var transition: Array
	var sentence: Array
	var plural: bool
	var subject_gender: int
	var last_subject: String
	var last_cards: Array[Vector2i]
	
	func _init(_card_set: Dictionary, _transition: Array):
		card_set = _card_set
		transition = _transition
		state = "sentence_end"
		text = ""
		plural = false
		subject_gender = -1
	
	func reset():
		state = "sentence_end"
		sentence.clear()
		plural = false
		subject_gender = -1
#		last_cards.clear()


func create_item_data() -> Dictionary:
	var recipe: String = Items.equipment_recipes.keys().pick_random()
	var recipe_data: Dictionary = Items.equipment_recipes[recipe]
	var item_name:= tr(recipe.to_upper())
	var item: Dictionary = Items.create_random_standard_equipment(recipe, {
		"level": 1,
		"tier": 1,
		"local_materials": Items.DEFAULT_MATERIALS,
	})
	
	item.attributes = {}
	if item_name.right(1) == 's' && item_name.right(2) != "ss":
		item.attributes.plural = item_name
	else:
		item.attributes.singular = item_name
	for i in range(item.components.size()):
		var component_name: String = tr(recipe_data.components[i].to_upper())
		item.components[i] = {
			"name": component_name,
			"type": recipe_data.components[i],
			"attributes": {},
			"material": item.components[i].duplicate(true),
		}
		if component_name.right(1) == 's' && component_name.right(2) != "ss":
			item.components[i].attributes.plural = component_name
		else:
			item.components[i].attributes.singular = component_name
		if "attributes" in item.components[i].material:
			for key in item.components[i].material.attributes:
				if typeof(item.components[i].material.attributes[key]) == TYPE_ARRAY:
					item.components[i].material.attributes[key] = \
						item.components[i].material.attributes[key].pick_random()
		else:
			item.components[i].material.attributes = {}
		if item.components[i].material.name.right(1) == 's' && \
			item.components[i].material.name.right(2) != "ss":
				item.components[i].material.attributes.plural = item.components[i].material.name
		else:
				item.components[i].material.attributes.singular = item.components[i].material.name
	
	return item

func create_description_data(item: Dictionary, rank: int) -> Dictionary:
	var card_set:= {}
	var craftmanship: Dictionary
	add_card(card_set, create_card("object", item.get("attributes", {})), Vector2i(0, 0))
	
	if "enchantments" in item:
		for enchantment in item.enchantments.values():
			var quality:= []
			var elements:= []
			match enchantment.type:
				"attack", "accuracy", "armour", "penetration", "physical_resistance", \
				"physical_damage":
					match item.get("base_type", ""):
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
					add_card(card_set, create_card("element"), Utils.get_closest_position(
						Vector2i(0, 0), card_set.keys()))
				"evasion", "speed":
					add_card(card_set, create_card("liquid"), Utils.get_closest_position(
						Vector2i(0, 0), card_set.keys()))
				"health", "health_regen", "stamina", "stamina_regen", "mana", "mana_regen", "focus":
					add_card(card_set, create_card("liquid"), Utils.get_closest_position(
						Vector2i(0, 0), card_set.keys()))
				"strength", "constitution", "dexterity", "cunning", "intelligence", "wisdom":
					add_card(card_set, create_card("stains"), Utils.get_closest_position(
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
				add_card(card_set, create_card("quality", quality.pick_random()),
					Utils.get_closest_position(Vector2i(0, 0), card_set.keys()))
			if elements.size() > 0:
				add_card(card_set, create_card("element", elements.pick_random()),
					Utils.get_closest_position(Vector2i(0, 0), card_set.keys()))
	
	for component in item.components:
		if typeof(component) != TYPE_DICTIONARY:
			continue
		var position:= Utils.get_closest_position(Vector2i(0, 0), card_set.keys())
		add_card(card_set, create_card("component", component.get("attributes", {})), position)
		if "material" in component:
			var mat_pos:= Utils.get_closest_position(position + Utils.DIRECTIONS.pick_random(),
				card_set.keys())
			add_card(card_set, create_card("material", component.material.get("attributes", {})),
				mat_pos)
	
	if rank < 2 or (rank < 6 && randf() < 0.1):
		add_card(card_set, create_card("weakness"),
			Utils.get_closest_position(Utils.DIRECTIONS.pick_random(), card_set.keys()))
	
	if rank < 2:
		craftmanship = [
			{
				"singular": "amateur",
				"adjective": "amateurish",
				"adverb": "amateurishly",
			},
			{
				"singular": "unskilled craftman",
				"adjective": "thoughtless",
				"adverb": "thoughtlessly",
			},
			{
				"singular": "novice craftman",
				"adjective": "acceptable",
				"adverb": "acceptably",
			},
		].pick_random()
	elif rank < 4:
		craftmanship = [
			{
				"singular": "novice craftman",
				"adjective": "acceptable",
				"adverb": "acceptably",
			},
			{
				"singular": "professional",
				"adjective": "professional",
				"adverb": "professionally",
			},
			{
				"singular": "experienced craftman",
				"adjective": "inspiring",
				"adverb": "skillfully",
			},
		].pick_random()
	elif rank < 6:
		craftmanship = [
			{
				"singular": "skilled craftman",
				"adjective": "skillful",
				"adverb": "skillfully",
			},
			{
				"singular": "master craftman",
				"adjective": "masterful",
				"adverb": "masterfully",
			},
			{
				"singular": "legendary craftman",
				"adjective": "legendary",
				"adverb": "legendaryly",
			},
		].pick_random()
	else:
		craftmanship = {
			"singular": "legendary craftman",
			"adjective": "legendary",
			"adverb": "legendaryly",
		}
	add_card(card_set, create_card("craftmanship", craftmanship),
		Utils.get_closest_position(Utils.DIRECTIONS.pick_random(), card_set.keys()))
	
	add_card(card_set, create_card("color"),
		Utils.get_closest_position(Utils.DIRECTIONS.pick_random(), card_set.keys()))
	
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
	add_card(card_set, create_card("care", care),
		Utils.get_closest_position(Utils.DIRECTIONS.pick_random(), card_set.keys()))
	
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
				add_card(card_set, create_card("enemy"),
					Utils.get_closest_position(Utils.DIRECTIONS.pick_random(), card_set.keys()))
	
	if rank > 2:
		@warning_ignore("integer_division")
		for i in range(min(int((rank - 1) / 2), 2)):
			var card_pos:= Utils.get_closest_position(Utils.DIRECTIONS.pick_random(),
				card_set.keys())
			add_card(card_set, create_card(RANDOM_CARDS.pick_random()), card_pos)
	
	return card_set


func pick_attribute(attribute: String) -> String:
	var data = attributes[attribute].pick_random()
	if typeof(data) == TYPE_DICTIONARY:
		if "adjective" in data:
			return tr(data.adjective)
		else:
			return tr(data.values()[0])
	else:
		return tr(data)

func create_card(type: String, attributes_override:= {}) -> Dictionary:
	var card:= {
		"type": type,
		"attributes": attributes_override.duplicate(true),
	}
	if type in cards:
		var definition: Dictionary = cards[type]
		for attribute in definition.get("attributes", []):
			if attribute in attributes_override:
				card.attributes[attribute] = tr(attributes_override[attribute])
			elif attribute in attributes:
				var data = attributes[attribute].pick_random()
				if typeof(data) == TYPE_DICTIONARY:
					card.attributes[attribute] = tr(
						data.get("default", data.values().pick_random()))
					for key in data.keys():
						if key == "default":
							continue
						if key not in card.attributes or key == attribute:
							card.attributes[key] = tr(data[key])
				else:
					card.attributes[attribute] = tr(data)
			else:
				# fallback: just use some random word lol
				card.attributes[attribute] = pick_attribute(attributes.keys().pick_random())
	if "singular" not in card.attributes && "plural" not in card.attributes:
		if "name" in attributes_override:
			card.attributes.singular = tr(attributes.name)
		elif "recipe" in attributes_override:
			card.attributes.singular = tr(attributes.recipe)
		elif type in attributes:
			var data = attributes[type].pick_random()
			if typeof(data) == TYPE_DICTIONARY:
				if "singular" in data:
					card.attributes.singular = tr(data.singular)
				if "plural" in data:
					card.attributes.plural = tr(data.plural)
				if "singular" not in data && "plural" not in data:
					card.attributes.singular = tr(data.get("default", data.values().pick_random()))
				for key in data.keys():
					if key == "default":
						continue
					if key in data && key not in card.attributes:
						card.attributes[key] = tr(data[key])
			else:
				card.attributes.singular = tr(data)
	if "adjective" not in card.attributes:
		if "singular" in card.attributes:
			card.attributes.adjective = card.attributes.singular.replace(" ", "-") + "-like"
		elif "plural" in card.attributes:
			card.attributes.adjective = card.attributes.plural.replace(" ", "-") + "-like"
	return card

func add_card(dict: Dictionary, card: Dictionary, position: Vector2i) -> Dictionary:
	dict[position] = card
	card.position = position
	return card




func create_card_set(item: Dictionary) -> Dictionary:
	var card_set:= {}
	add_card(card_set, create_card("object", item.get("attributes", {})), Vector2i(0, 0))
	add_card(card_set, create_card(RANDOM_CARDS.pick_random()), Utils.DIRECTIONS.pick_random())
	
	for component in item.components:
		var position:= Utils.get_closest_position(Vector2i(0, 0), card_set.keys())
		# card_set[position] = create_card(component.type, component.get("attributes", {}))
		add_card(card_set, create_card("component", component.get("attributes", {})), position)
		if "material" in component:
			var mat_pos:= Utils.get_closest_position(position + Utils.DIRECTIONS.pick_random(),
				card_set.keys())
			add_card(card_set, create_card("material", component.material.get("attributes", {})),
				mat_pos)
			
			var card_pos:= Utils.get_closest_position(mat_pos, card_set.keys())
			add_card(card_set, create_card(RANDOM_CARDS.pick_random()), card_pos)
	
	for i in range(3):
		var card_pos:= Utils.get_closest_position(Utils.DIRECTIONS.pick_random(), card_set.keys())
		add_card(card_set, create_card(RANDOM_CARDS.pick_random()), card_pos)
	
	return card_set

func pick_valid_card_set(type_set: Array, current_position: Vector2i,
		current_cards: Dictionary, card_set:= []) -> Array:
	var index:= card_set.size()
	if index >= type_set.size():
		return card_set
	if index == 0:
		for pos in current_cards.keys():
			if current_cards[pos].type != type_set[index] || \
				Utils.get_distance(current_position, pos) > Utils.MAX_DIST:
					continue
			var array:= pick_valid_card_set(type_set, current_position, current_cards, [pos])
			if array.size() == type_set.size():
				return array
	else:
		for pos in card_set:
			var directions:= Utils.DIRECTIONS.duplicate(true)
			directions.shuffle()
			for offset in directions:
				if current_cards.has(pos + offset) && \
					current_cards[pos+offset].type == type_set[index] && \
					Utils.get_distance(current_position, pos + offset) <= Utils.MAX_DIST:
						var array:= pick_valid_card_set(type_set, current_position, current_cards,
							card_set + [pos + offset])
						if array.size() == type_set.size():
							return array
	# no valid combinations found
	return []

func pick_valid_text(available_texts: Array, current_card_set: Dictionary) -> Dictionary:
	if current_card_set.size() == 0:
		return {}
	
	available_texts.shuffle()
	for type in available_texts:
		if type in texts_by_type:
			texts_by_type[type].shuffle()
			for text_data in texts_by_type[type]:
				var required: Array = text_data.get("required", [])
				var card_pos:= pick_valid_card_set(required, current_card_set.keys().pick_random(),
					current_card_set)
				if card_pos.size() == required.size():
					var mapping:= {}
					for req in required:
						for pos in card_pos:
							if current_card_set[pos].type == req:
								mapping[req] = current_card_set[pos]
								card_pos.erase(pos)
								break
					text_data = text_data.duplicate(true)
					text_data.required = mapping
					return text_data
	return {}

func append_text(text_state: TextState) -> TextState:
	var card_set:= text_state.card_set.duplicate()
	var text_data:= pick_valid_text(text_state.transition, card_set)
	if text_data.size() == 0:
		print("Warning: no valid texts available.")
		for i in range(4):
			var card_pos: Vector2i
			if text_state.card_set.size() > 0:
				card_pos = Utils.get_closest_position(text_state.card_set.keys().pick_random(),
					text_state.card_set.keys())
			else:
				card_pos = Utils.get_closest_position(Vector2(0, 0), text_state.card_set.keys())
			add_card(text_state.card_set, create_card(RANDOM_CARDS.pick_random()), card_pos)
		text_data = pick_valid_text(text_state.transition, text_state.card_set)
		if text_data.size() == 0:
			print("Warning: still no valid texts available after adding random cards")
			text_state.reset()
			text_state.state = "error"
			text_state.transition = texts_by_type.sentence_end.pick_random().transition
			return text_state
	
	for card in text_data.required.values():
		if card.position not in text_state.last_cards:
			text_state.last_cards.push_back(card.position)
	if text_state.last_cards.size() > 0:
		for i in range(randi() % int(max(text_state.last_cards.size() / 2.0 - 0.5, 1))):
			text_state.last_cards.remove_at(randi() % text_state.last_cards.size())
	
	var text:= ""
	var re:= RegEx.new()
	var results: Array[RegExMatch]
	var format_dict:= {}
	var add_text: String
	var repeated_subject:= false
	var subject_key:= ""
	var skip:= false
	if "text" in text_data:
		text = text_data.text.pick_random()
	re.compile(r"{([\w\.'/]+)}")
	results = re.search_all(text)
	if results.size() > 0 && "sentence" in text_data:
		var has_subject:= false
		if "subject" in text_data:
			for result in results:
				var res_str:= result.get_string(1)
				if text_data.subject in res_str:
					has_subject = true
					if "plural" in res_str:
						text_state.plural = true
						break
					elif "singular" in res_str:
						text_state.plural = false
						break
		if not has_subject && "object" in text_data:
			for result in results:
				var res_str:= result.get_string(1)
				if text_data.object in res_str:
					if "plural" in res_str:
						text_state.plural = true
						break
	for result in results:
		var key:= result.get_string(1)
		if "/" in key:
			var array:= key.split("/")
			if text_state.plural && array.size() > 1:
				format_dict[key] = array[1]
			else:
				format_dict[key] = array[0]
		elif '.' in key:
			var array:= key.split('.')
			var topic:= array[0]
			var attribute:= array[1]
			if topic not in text_data.required:
				print("Warning: key " + topic + " missing in text data")
				format_dict[key] = pick_attribute(attributes.keys().pick_random())
				continue
			
			var data: Dictionary = text_data.required[topic].attributes
			if attribute not in data:
				if attribute == "singular" && "plural" in data:
					attribute = "plural"
					text_state.plural = true
				elif attribute == "plural" && "singular" in data:
					attribute = "singular"
			if attribute in data:
				format_dict[key] = data[attribute]
				if "sentence" in text_data && "subject" in text_data.sentence && \
					text_data.sentence.subject == topic:
						if data[attribute] == text_state.last_subject:
							repeated_subject = true
						subject_key = key
						text_state.last_subject = data[attribute]
			else:
				print("Warning: key " + key + " missing in text data")
				format_dict[key] = data.values().pick_random()
			if "is_name" in data and data.is_name && attribute in ["singular", "plural"]:
				var pos:= result.get_start(1)
				if text.substr(pos - 3, 1) == 'a':
					text = text.left(pos - 4) + text.substr(pos - 1)
				elif text.substr(pos - 4, 1) == 'an':
					text = text.left(pos - 5) + text.substr(pos - 1)
				elif text.substr(pos - 5, 1) == 'the':
					text = text.left(pos - 6) + text.substr(pos - 1)
			elif attribute == "plural":
				var pos:= result.get_start(1)
				if text.substr(pos - 3, 1) == 'a':
					text = text.left(pos - 3) + "the" + text.substr(pos - 2)
				elif text.substr(pos - 4, 1) == 'an':
					text = text.left(pos - 4) + "the" + text.substr(pos - 2)
		else:
			print("Warning: key " + key +
				" has invalid format. Use topic.attribute or singular/plural")
			format_dict[key] = pick_attribute(attributes.keys().pick_random())
			continue
		
	
	for s in text_data.get("sentence", {}):
		if s in text_state.sentence:
			if "predicate" in text_data.sentence and "predicate" in text_state.sentence:
				skip = true
				print("Info: skipping text part")
			if !skip && text_state.text.length() > 0 && \
				text_state.text[text_state.text.length() - 1] != " ":
					text_state.text += " "
	for s in text_data.get("sentence", {}):
		if s not in text_state.sentence:
			text_state.sentence.push_back(s)
	if "termination" in text_state.sentence:
		if text_state.text.right(1) not in ['.', ',', '!', '?', ':', '-']:
			if "subordinate" in text_state.sentence:
				text_state.text += ','
			else:
				text_state.text += '.'
		text_state.reset()
	if text_state.text.length() > 0 && text_state.text[text_state.text.length() - 1] != " " && \
		text.length() > 0 && text[0] != '.' && !skip:
			text_state.text += " "
	if repeated_subject && !skip:
		var pos:= text.find(subject_key) - 1
		var lpos:= text.rfind(" ", pos - 2)
		var sub_str: String
		if lpos < 0:
			lpos = 0
		sub_str = text.substr(lpos, pos - lpos)
		if "the " in sub_str || "The " in sub_str || "a " in sub_str || "A " in sub_str || \
			"an " in sub_str || "An " in sub_str:
			text = text.substr(0, lpos) + text.substr(pos)
			if text_state.plural:
				format_dict[subject_key] = "they"
			else:
				format_dict[subject_key] = "it"
			text_state.last_subject = ""
	if !skip:
		add_text = text.format(format_dict)
		if text_state.state == "sentence_end" && add_text.length() > 0 && \
			(text_state.text.length() == 0 || \
			text_state.text[max(text_state.text.length() - 2, 0)] not in [',', ':', '-']):
				add_text[0] = add_text[0].to_upper()
		text_state.text += add_text
	text_state.transition = text_data.get("transition",
		texts_by_type.sentence_end.pick_random().transition)
	text_state.state = text_data.type
	
	for key in text_data.get("remove", []):
		text_state.card_set.erase(text_data.required[key].position)
	for key in text_data.get("add", []):
		add_card(text_state.card_set, create_card(key), Utils.get_closest_position(
			text_state.card_set.keys().pick_random(), text_state.card_set.keys()))
	for key in text_data.get("replace", {}):
		text_state.card_set.erase(text_data.required[key].position)
		add_card(text_state.card_set, create_card(text_data.replace[key]),
			text_data.required[key].position)
	
	return text_state



func generate_test_description(item: Dictionary, max_sentences:= 3) -> String:
	var card_set:= create_card_set(item)
	return generate_description(card_set, max_sentences)

func generate_description(card_set: Dictionary, max_sentences:= 3) -> String:
	var available_texts: Array = texts_by_type.sentence_end.pick_random().transition
	var text_state:= TextState.new(card_set, available_texts)
	var no_sentences:= 0
	var failures:= 0
	
	while no_sentences < max_sentences:
		text_state = append_text(text_state)
		if text_state.state == "error":
			var pos: int = max(max(text_state.text.rfind('.'), text_state.text.rfind('!')),
				text_state.text.rfind('?')) + 1
			text_state.text = text_state.text.left(pos)
		elif text_state.state == "sentence_end":
			var pos:= text_state.text.rfind('.', text_state.text.length() - 2)
			if pos > 0:
				var length: int = min(text_state.text.length() - pos - 1, MAX_TEXT_LENGTH)
				if Utils.compare_strings(text_state.text.right(pos + 1),
					text_state.text.substr(max(pos - length, 0), length)) > 0.75:
						print("Warning: text rejected because too repetetive")
						text_state.text = text_state.text.left(pos + 1)
						failures += 1
						if failures > 3:
							no_sentences += 1
							failures = 0
				elif text_state.text.right(1) not in [',', ';', ':', '-']:
					no_sentences += 1
			elif text_state.text.right(1) not in [',', ';', ':', '-']:
				no_sentences += 1
		if text_state.text.length() > MAX_TEXT_LENGTH:
			if text_state.text[text_state.text.length() - 1] != '.':
				text_state.text += "..."
			break
	
	return sanitize_string(text_state.text)



func sanitize_string(string: String) -> String:
	if string.length() == 0:
		return string
	
	var pos:= 0
	var start:= true
	string[0] = string[0].to_upper()
	if string[0] == 'A' && string[1] == ' ':
		var pos2:= string.find(' ', 2)
		if string[pos2 - 1] == 's':
			string = "The" + string.substr(1)
		elif string[2].to_lower() in Names.VOVELS:
			string = "An" + string.substr(1)
	
	while pos >= 0 && pos < string.length():
		var pos2: int
		pos = string.findn(" a ", pos)
		if pos == -1:
			break
		pos2 = string.find(' ', pos+3)
		if string[pos2 - 1] == 's':
			string = string.left(pos) + " the " + string.substr(pos + 3)
		elif string[pos + 3].to_lower() in Names.VOVELS:
			string = string.left(pos) + " an " + string.substr(pos + 3)
		elif string[pos + 3] == '[':
			var p:= string.find(']', pos + 3)
			if string[p + 1].to_lower() in Names.VOVELS:
				string = string.left(pos) + " an " + string.substr(pos+3)
		pos += 3
	string = string.replace("The the", "The").replace("the the", "the")
	
	for p in range(string.length()):
		if start && string[p] != " ":
			string[p] = string[p].to_upper()
			start = false
		if string[p] in ['.', '!', '?']:
			start = true
	return string


func load_text_data(path: String):
	for file_name in Utils.get_file_paths(path):
		var file:= FileAccess.open(file_name, FileAccess.READ)
		var error:= FileAccess.get_open_error()
		if error != OK:
			print("Can't open file " + file_name + "!")
			continue
		else:
			print("Loading items " + file_name + '.')
		
		var raw:= file.get_as_text()
		var array: Array = JSON.parse_string(raw) as Array
		if array == null || array.size() == 0:
			print("Error parsing " + file_name + "!")
			continue
		for text_data in array:
			texts.push_back(text_data)
			if "type" in text_data:
				if text_data.type in texts_by_type:
					texts_by_type[text_data.type].push_back(text_data)
				else:
					texts_by_type[text_data.type] = [text_data]
		file.close()

func load_card_data(path: String):
	for file_name in Utils.get_file_paths(path):
		var file:= FileAccess.open(file_name, FileAccess.READ)
		var error:= FileAccess.get_open_error()
		if error != OK:
			print("Can't open file " + file_name + "!")
			continue
		else:
			print("Loading items " + file_name + '.')
		
		var raw:= file.get_as_text()
		var dict: Dictionary = JSON.parse_string(raw)
		if dict == null || dict.size() == 0:
			print("Error parsing " + file_name + "!")
			continue
		for key in dict:
			cards[key] = dict[key]
		file.close()

func load_attribute_data(path: String):
	for file_name in Utils.get_file_paths(path):
		var file:= FileAccess.open(file_name, FileAccess.READ)
		var error:= FileAccess.get_open_error()
		if error != OK:
			print("Can't open file " + file_name + "!")
			continue
		else:
			print("Loading items " + file_name + '.')
		
		var raw:= file.get_as_text()
		var dict: Dictionary = JSON.parse_string(raw)
		if dict == null || dict.size() == 0:
			print("Error parsing " + file_name + "!")
			continue
		for key in dict:
			attributes[key] = dict[key]
		file.close()


func _ready():
	load_text_data("res://data/items/texts")
	load_card_data("res://data/items/cards")
	load_attribute_data("res://data/items/attributes")
