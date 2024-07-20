extends Node

const MAX_TEXT_LENGTH = 500
const ATTRIBUTES = {
	"color": [
		{"default": "white", "adjective": "white"},
		{"default": "grey", "adjective": "grey"},
		{"default": "black", "adjective": "black"},
		{"default": "brown", "adjective": "brown"},
		{"default": "red", "adjective": "red"},
		{"default": "orange", "adjective": "orange"},
		{"default": "yellow", "adjective": "yellow"},
		{"default": "green", "adjective": "green"},
		{"default": "cyan", "adjective": "cyan"},
		{"default": "blue", "adjective": "blue"},
		{"default": "violet", "adjective": "violet"},
		{"default": "purple", "adjective": "purple"},
		{"default": "pink", "adjective": "pink"},
		{"default": "magenta", "adjective": "magenta"},
		{"default": "crimson", "adjective": "crimson"},
		{"default": "indigo", "adjective": "indigo"},
		{"default": "silver", "adjective": "silver"},
		{"default": "beige", "adjective": "beige"},
		{"default": "aquamarine", "adjective": "aquamarine"},
		{"default": "orchid", "adjective": "orchid"},
		{"default": "turquoise", "adjective": "turquoise"},
		{"default": "teal", "adjective": "teal"},
		{"default": "gold", "adjective": "golden"},
		{"adjective": "colorless"},
	],
	"liquid": [
		{"singular": "water", "plural": "waters", "adjective": "watery"},
		{"singular": "poison", "plural": "poisons", "adjective": "poisonous"},
		{"singular": "acid", "plural": "acids", "adjective": "acidic"},
		{"default": "blood", "adjective": "bloody"},
		{"default": "oil", "adjective": "oily"},
		{"default": "syrup", "adjective": "sweet"},
		{"default": "resin", "adjective": "sticky"},
	],
	"weight": [
		"heavy", "massive", "light", "lightweight",
	],
	"thickness": [
		"viscous", "thick", "thin",
	],
	"shape": [
		{"singular": "ball", "plural": "balls", "adjective": "round"},
		{"singular": "sphere", "plural": "spheres", "adjective": "spherical"},
		{"singular": "cube", "plural": "cubes", "adjective": "cubic"},
		{"singular": "triangle", "plural": "triangles", "adjective": "triangular"},
		{"singular": "rectangle", "plural": "rectangles", "adjective": "rectangular"},
		{"singular": "pentagon", "plural": "pentagons", "adjective": "pentagonal"},
		{"singular": "hexagon", "plural": "hexagons", "adjective": "hexagonal"},
		{"singular": "octagon", "plural": "octagons", "adjective": "octagonal"},
		{"singular": "odd shape", "plural": "odd shapes", "adjective": "irregular"},
	],
	"theme": [
		{"singular": "life", "adjective": "vital"},
		{"singular": "hope", "adjective": "hoping"},
		{"singular": "determination", "adjective": "determined"},
		{"singular": "will", "adjective": "willful"},
		{"singular": "bravery", "adjective": "brave"},
		{"singular": "day", "adjective": "illuminated"},
		{"singular": "harmony", "adjective": "harmonious"},
		{"singular": "death", "adjective": "undead"},
		{"singular": "torment", "adjective": "tormented"},
		{"singular": "pain", "adjective": "painful"},
		{"singular": "agony", "adjective": "agonizing"},
		{"singular": "despair", "adjective": "hopeless"},
		{"singular": "devastation", "adjective": "devastating"},
		{"singular": "night", "adjective": "dark"},
		{"singular": "mercy", "adjective": "mercyful"},
		{"singular": "discord", "adjective": "quarrelsome"},
		{"singular": "war", "adjective": "savage"},
		{"singular": "destruction", "adjective": "destructive"},
		{"singular": "obliteration", "adjective": "obliterating"},
		{"singular": "entropy", "adjective": "entropic"},
		{"singular": "chaos", "adjective": "chaotic"},
		{"singular": "order", "adjective": "ordered"},
		{"singular": "sky", "plural": "skies", "adjective": "skyward"},
		{"singular": "space", "adjective": "celestial"},
		{"plural": "stars", "adjective": "faintly glowing"},
		{"singular": "heaven", "plural": "heavens", "adjective": "heavenly"},
		{"singular": "aether", "adjective": "aetheral"},
		{"singular": "abyss", "adjective": "abyssal"},
		{"plural": "oceans", "adjective": "oceanic"},
		{"singular": "deep sea", "adjective": "submerged"},
		{"singular": "dawn", "adjective": "dawning"},
		{"singular": "twilight", "adjective": "twilight"},
		{"singular": "light", "adjective": "bright"},
		{"singular": "darkness", "adjective": "dark"},
		{"singular": "blight", "adjective": "blighted"},
	],
	"mental_illness": [
		{"singular": "madness", "adjective": "mad"},
		{"singular": "agony", "adjective": "agonizing"},
		{"singular": "despair", "adjective": "hopeless"},
		{"singular": "nightmares", "adjective": "haunted"},
	],
	"element": [
		{"singular": "fire", "adjective": "fiery"},
		{"plural": "flames", "adjective": "flaming"},
		{"singular": "ice", "adjective": "icy"},
		{"singular": "frost", "adjective": "cold"},
		{"singular": "lightning", "adjective": "sparkling"},
		{"singular": "water", "plural": "waters", "adjective": "watery"},
		{"singular": "wind", "plural": "winds", "adjective": "windy"},
		{"singular": "earth", "adjective": "dirty"},
		{"singular": "light", "plural": "lights", "adjective": "bright"},
		{"singular": "darkness", "plural": "shadows", "adjective": "dark"},
	],
	"curse": [
		{"singular": "curse", "plural": "curses", "adjective": "cursed"},
		{"singular": "blessing", "plural": "blessings", "adjective": "blessed"},
	],
	"quality": [
		{"singular": "spike", "plural": "spikes", "adjective": "sharp"},
		{"singular": "blade", "plural": "blades", "adjective": "sharp"},
		{"singular": "hammer", "plural": "hammers", "adjective": "blunt"},
		{"singular": "metal", "adjective": "polished"},
		{"plural": "barbs", "adjective": "vile"},
	],
	"weakness": [
		{"singular": "weakness", "adjective": "weak"},
		{"singular": "dullness", "adjective": "dull"},
		{"singular": "bluntness", "adjective": "blunt"},
		{"singular": "brittleness", "adjective": "brittle"},
		{"singular": "age", "adjective": "old"},
	],
	"craftmanship": [
		{"singular": "amateur", "adjective": "amateurish", "adverb": "amateurishly"},
		{"singular": "unskilled craftman", "adjective": "thoughtless", "adverb": "thoughtlessly"},
		{"singular": "novice craftman", "adjective": "acceptable", "adverb": "acceptably"},
		{"singular": "professional", "adjective": "professional", "adverb": "professionally"},
		{"singular": "experienced craftman", "adjective": "inspiring", "adverb": "skillfully"},
		{"singular": "skilled craftman", "adjective": "skillful", "adverb": "skillfully"},
		{"singular": "legendary craftman", "adjective": "legendary", "adverb": "legendary"},
	],
	"stains": [
		{"singular": "blood stains", "adjective": "blood stained"},
		{"singular": "grease stains", "adjective": "grease stained"},
		{"singular": "water stains", "adjective": "water stained"},
	],
	"enemy": [
		{"singular": "beast", "plural": "beasts", "adjective": "wild"},
		{"singular": "demon", "plural": "demons", "adjective": "evil"},
		{"singular": "angel", "plural": "angels", "adjective": "radiant"},
		{"singular": "elemental", "plural": "elementals", "adjective": "elemental"},
		{"plural": "undead", "adjective": "undead"},
		{"singular": "orc", "plural": "orcs", "adjective": "brutal"},
		{"singular": "cyborg", "plural": "cyborgs", "adjective": "cybertronic"},
		{"singular": "robot", "plural": "robots", "adjective": "computronic"},
		{"singular": "archon", "plural": "archons", "adjective": "mighty"},
		{"plural": "plants", "adjective": "phototropic"},
	],
	"prophecy": [
		{"singular": "prophecy", "plural": "prophecies", "adjective": "prophesied"},
		{"singular": "oracle", "plural": "oracles", "adjective": "prophesied"},
		{"singular": "fate", "adjective": "fated"},
		{"singular": "destiny", "adjective": "destined"},
	],
	"emotion": [
		{"singular": "care", "adjective": "careful", "adverb": "carefully"},
		{"singular": "joy", "adjective": "joyful", "adverb": "joyfully"},
		{"singular": "precision", "adjective": "precise", "adverb": "precisely"},
		{"singular": "dedication", "adjective": "dedicated", "adverb": "decisively"},
		{"singular": "determination", "adjective": "determined", "adverb": "mindfully"},
		{"singular": "hate", "adjective": "fierce", "adverb": "fiercely"},
		{"singular": "haste", "adjective": "improvised", "adverb": "hastily"},
		{"singular": "sorrow", "adjective": "sorrowful", "adverb": "sorrowfully"},
	],
}
const RANDOM_CARDS = [
	"theme", "shape", "color", "liquid", "element", "curse", "quality", "weakness", "craftmanship",
	"mental_illness", "stains", "enemy", "prophecy", "emotion",
]

var texts: Array[Dictionary] = []
var texts_by_type:= {}
var cards:= {}



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
	var recipe: String = Items.EQUIPMENT_RECIPES.keys().pick_random()
	var recipe_data: Dictionary = Items.EQUIPMENT_RECIPES[recipe]
	var item_name:= tr(recipe.to_upper())
	var item: Dictionary = Items.create_random_standard_equipment(recipe, {"level":1,"tier":1,"local_materials":Items.DEFAULT_MATERIALS})
	
	item.attributes = {}
	if item_name.right(1) == 's' && item_name.right(2) != "ss":
		item.attributes.plural = item_name
	else:
		item.attributes.singular = item_name
	item.attributes.adjective = item.components.pick_random().attributes.adjective
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
					item.components[i].material.attributes[key] = item.components[i].material.attributes[key].pick_random()
		else:
			item.components[i].material.attributes = {}
		if item.components[i].material.name.right(1) == 's' && item.components[i].material.name.right(2) != "ss":
			item.components[i].material.attributes.plural = item.components[i].material.name
		else:
			item.components[i].material.attributes.singular = item.components[i].material.name
	
	return item



func pick_attribute(attribute: String) -> String:
	var data = ATTRIBUTES[attribute].pick_random()
	if typeof(data) == TYPE_DICTIONARY:
		if "adjective" in data:
			return tr(data.adjective)
		else:
			return tr(data.values()[0])
	else:
		return tr(data)

func create_card(type: String, attributes:= {}) -> Dictionary:
	var card:= {
		"type": type,
		"attributes": attributes.duplicate(true),
	}
	if type in cards:
		var definition: Dictionary = cards[type]
		for attribute in definition.get("attributes", []):
			if attribute in attributes:
				card.attributes[attribute] = tr(attributes[attribute])
			elif attribute in ATTRIBUTES:
				var data = ATTRIBUTES[attribute].pick_random()
				if typeof(data) == TYPE_DICTIONARY:
					card.attributes[attribute] = tr(data.get("default", data.values().pick_random()))
					for key in data.keys():
						if key == "default":
							continue
						if key not in card.attributes or key == attribute:
							card.attributes[key] = tr(data[key])
				else:
					card.attributes[attribute] = tr(data)
			else:
				# fallback: just use some random word lol
				print("WARNING: missing attribute " + attribute + " in " + type)
				card.attributes[attribute] = pick_attribute(ATTRIBUTES.keys().pick_random())
	if "singular" not in card.attributes && "plural" not in card.attributes:
		if "name" in attributes:
			card.attributes.singular = tr(attributes.name)
		elif "recipe" in attributes:
			card.attributes.singular = tr(attributes.recipe)
		elif type in ATTRIBUTES:
			var data = ATTRIBUTES[type].pick_random()
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
			var mat_pos:= Utils.get_closest_position(position + Utils.DIRECTIONS.pick_random(), card_set.keys())
			add_card(card_set, create_card("material", component.material.get("attributes", {})), mat_pos)
			
			var card_pos:= Utils.get_closest_position(mat_pos, card_set.keys())
			add_card(card_set, create_card(RANDOM_CARDS.pick_random()), card_pos)
	
	for i in range(3):
		var card_pos:= Utils.get_closest_position(Utils.DIRECTIONS.pick_random(), card_set.keys())
		add_card(card_set, create_card(RANDOM_CARDS.pick_random()), card_pos)
	
	return card_set

func pick_valid_card_set(type_set: Array, current_position: Vector2i, current_cards: Dictionary, card_set:= []) -> Array:
	var index:= card_set.size()
	if index >= type_set.size():
		return card_set
	if index == 0:
		for pos in current_cards.keys():
			if current_cards[pos].type != type_set[index] || Utils.get_distance(current_position, pos) > Utils.MAX_DIST:
				continue
			var array:= pick_valid_card_set(type_set, current_position, current_cards, [pos])
			if array.size() == type_set.size():
				return array
	else:
		for pos in card_set:
			var directions:= Utils.DIRECTIONS.duplicate(true)
			directions.shuffle()
			for offset in directions:
				if current_cards.has(pos + offset) && current_cards[pos+offset].type == type_set[index] && Utils.get_distance(current_position, pos + offset) <= Utils.MAX_DIST:
					var array:= pick_valid_card_set(type_set, current_position, current_cards, card_set + [pos + offset])
					if array.size() == type_set.size():
						return array
	# no valid combinations found
	return []

func pick_valid_text(available_texts: Array, current_card_set: Dictionary) -> Dictionary:
	available_texts.shuffle()
	for type in available_texts:
		if type in texts_by_type:
			texts_by_type[type].shuffle()
			for text_data in texts_by_type[type]:
				var required: Array = text_data.get("required", [])
				var card_pos:= pick_valid_card_set(required, current_card_set.keys().pick_random(), current_card_set)
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
	for pos in text_state.last_cards:
		if randf() < 0.5:
			card_set.erase(pos)
	var text_data:= pick_valid_text(text_state.transition, card_set)
	if text_data.size() == 0:
		print("Warning: no valid texts available.")
		for i in range(4):
			var card_pos:= Utils.get_closest_position(text_state.card_set.keys().pick_random(), text_state.card_set.keys())
			add_card(text_state.card_set, create_card(RANDOM_CARDS.pick_random()), card_pos)
		text_data = pick_valid_text(text_state.transition, text_state.card_set)
		if text_data.size() == 0:
			print("Warning: still no valid texts available after adding random cards")
			text_state.reset()
			text_state.state = "error"
			text_state.transition = texts_by_type.sentence_end.pick_random().transition
			return text_state
	
#	text_state.last_cards.clear()
	for card in text_data.required.values():
		if card.position not in text_state.last_cards:
			text_state.last_cards.push_back(card.position)
	if text_state.last_cards.size() > 0:
		for i in range(randi()%int(max(text_state.last_cards.size() / 2.0 - 0.5, 1))):
			text_state.last_cards.remove_at(randi()%text_state.last_cards.size())
	
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
#					elif "singular" in res_str:
#						text_state.plural = false
#						break
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
				format_dict[key] = pick_attribute(ATTRIBUTES.keys().pick_random())
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
				if "sentence" in text_data && "subject" in text_data.sentence && text_data.sentence.subject == topic:
					if data[attribute] == text_state.last_subject:
						repeated_subject = true
					subject_key = key
					text_state.last_subject = data[attribute]
			else:
				print("Warning: key " + key + " missing in text data")
				format_dict[key] = data.values().pick_random()
		else:
			print("Warning: key " + key + " has invalid format. Use topic.attribute or singular/plural")
			format_dict[key] = pick_attribute(ATTRIBUTES.keys().pick_random())
			continue
		
	
	for s in text_data.get("sentence", {}):
		if s in text_state.sentence:
			if "predicate" in text_data.sentence and "predicate" in text_state.sentence:
				skip = true
				print("Info: skipping text part")
#				var str_that:= tr("THAT")
#				if str_that not in text_state.text.right(str_that.length() + 1):
#					text_state.text += str_that
#			elif "predicate" in text_state.sentence and "subject" in text_state.sentence:
#				var str_and:= tr("AND")
#				if str_and not in text_state.text.right(str_and.length() + 1):
#					text_state.text += str_and
			if !skip && text_state.text.length() > 0 && text_state.text[text_state.text.length() - 1] != " ":
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
	if text_state.text.length() > 0 && text_state.text[text_state.text.length() - 1] != " " && text.length() > 0 && text[0] != '.' && !skip:
		text_state.text += " "
	if repeated_subject && !skip:
		var pos:= text.find(subject_key) - 1
		var lpos:= text.rfind(" ", pos - 2)
		var sub_str: String
		if lpos < 0:
			lpos = 0
		sub_str = text.substr(lpos, pos - lpos)
		if "the " in sub_str || "The " in sub_str || "a " in sub_str || "A " in sub_str || "an " in sub_str || "An " in sub_str:
#			print(subject_key + " - " + text + ": " + text.substr(0, lpos) + " / " + text.substr(pos) + " / " + text.substr(lpos, pos-lpos) + ".")
			text = text.substr(0, lpos) + text.substr(pos)
			if text_state.plural:
				format_dict[subject_key] = "they"
			else:
				format_dict[subject_key] = "it"
			text_state.last_subject = ""
	if !skip:
		add_text = text.format(format_dict)
		if text_state.state == "sentence_end" && add_text.length() > 0 && (text_state.text.length() == 0 || text_state.text[max(text_state.text.length() - 2, 0)] not in [',', ':', '-']):
			add_text[0] = add_text[0].to_upper()
		text_state.text += add_text
	text_state.transition = text_data.get("transition", texts_by_type.sentence_end.pick_random().transition)
	text_state.state = text_data.type
	
	for key in text_data.get("remove", []):
		text_state.card_set.erase(text_data.required[key].position)
	for key in text_data.get("add", []):
		add_card(text_state.card_set, create_card(key), Utils.get_closest_position(text_state.card_set.keys().pick_random(), text_state.card_set.keys()))
	for key in text_data.get("replace", {}):
		text_state.card_set.erase(text_data.required[key].position)
		add_card(text_state.card_set, create_card(text_data.replace[key]), text_data.required[key].position)
	
	return text_state



func generate_description(item: Dictionary, max_sentences:= 3) -> String:
	var card_set:= create_card_set(item)
	var available_texts: Array = texts_by_type.sentence_end.pick_random().transition
	var text_state:= TextState.new(card_set, available_texts)
	var no_sentences:= 0
	
	while no_sentences < max_sentences:
		text_state = append_text(text_state)
		if text_state.state == "error":
			var pos: int = max(max(text_state.text.rfind('.'), text_state.text.rfind('!')), text_state.text.rfind('?')) + 1
			text_state.text = text_state.text.left(pos)
		elif text_state.state == "sentence_end":
			var pos:= text_state.text.rfind('.', text_state.text.length() - 2)
			if pos > 0:
				var length: int = min(text_state.text.length() - pos - 1, MAX_TEXT_LENGTH)
				if Utils.compare_strings(text_state.text.right(pos + 1), text_state.text.substr(max(pos - length, 0), length)) > 0.75:
					print("Warning: text rejected because too repetetive")
					text_state.text = text_state.text.left(pos + 1)
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
		if error!=OK:
			print("Can't open file " + file_name + "!")
			continue
		else:
			print("Loading items " + file_name + '.')
		
		var raw:= file.get_as_text()
		var array: Array = JSON.parse_string(raw) as Array
		if array==null || array.size()==0:
			printt("Error parsing " + file_name + "!")
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
		if error!=OK:
			print("Can't open file " + file_name + "!")
			continue
		else:
			print("Loading items " + file_name + '.')
		
		var raw:= file.get_as_text()
		var dict: Dictionary = JSON.parse_string(raw)
		if dict==null || dict.size()==0:
			printt("Error parsing " + file_name + "!")
			continue
		for key in dict:
			cards[key] = dict[key]
		file.close()


#func _process(_delta: float):
	#if randf() < 0.05:
		#var item:= create_item_data()
		#print(generate_description(item))
	#

func _ready():
	load_text_data("res://data/items/texts")
	load_card_data("res://data/items/cards")
	
	
