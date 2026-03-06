extends Node

const MAX_TEXT_LENGTH := 500


class Card:
	var type: String
	var properties: Property
	var position: Vector2i
	
	func _init(data: Dictionary) -> void:
		self.type = data.get("type", "") as String
		match typeof(data.get("properties", null)):
			TYPE_DICTIONARY:
				self.properties = Property.new(data.get("properties", null) as Dictionary)
			TYPE_OBJECT:
				self.properties = data.get("properties", null) as Property
		self.position = data.get("position", Vector2i()) as Vector2i
	
	func to_dict() -> Dictionary:
		return {
			"type": self.type,
			"properties": self.properties.to_dict(),
			"position": self.position,
		}

class Property:
	var _singular: String
	var _plural: String
	var _adjective: String
	var _adverb: String
	var _verb: String
	var _prefix: String
	var _suffix: String
	var _color: String
	var _density: String
	var _thickness: String
	var is_name: bool
	
	func _init(data: Dictionary) -> void:
		self._singular = data.get("singular", "") as String
		self._plural = data.get("plural", "") as String
		self._adjective = data.get("adjective", "") as String
		self._adverb = data.get("adverb", "") as String
		self._verb = data.get("verb", "") as String
		self._prefix = data.get("prefix", "") as String
		self._suffix = data.get("suffix", "") as String
		self._color = data.get("color", "") as String
		self._density = data.get("density", "") as String
		self._thickness = data.get("thickness", "") as String
		self.is_name = data.get("is_name", false) as bool
	
	func to_dict() -> Dictionary:
		var dict := {
			"is_name": self.is_name,
		}
		if self._singular != "":
			dict.singular = self._singular
		if self._plural != "":
			dict.plural = self._plural
		if self._adjective != "":
			dict.adjective = self._adjective
		if self._adverb != "":
			dict.adverb = self._adverb
		if self._verb != "":
			dict.verb = self._verb
		if self._prefix != "":
			dict.prefix = self._prefix
		if self._suffix != "":
			dict.suffix = self._suffix
		if self._color != "":
			dict.color = self._color
		if self._density != "":
			dict.density = self._density
		if self._thickness != "":
			dict.thickness = self._thickness
		return dict
	
	func is_plural() -> bool:
		return self._plural != ""
	
	func get_singular() -> String:
		if self._singular == "":
			return self._plural
		return self._singular
	
	func get_plural() -> String:
		if self._plural == "":
			return self._singular + "s"
		return self._plural
	
	func get_adjective() -> String:
		if self._adjective == "":
			print("Warning: adjective missing for " + self._singular + " / " + self._plural)
			return self._singular
		return self._adjective
	
	func get_adverb() -> String:
		if self._adverb == "":
			return self.get_adjective() + "ish"
		return self._adverb
	
	func get_verb() -> String:
		if self._verb == "":
			return self.get_singular()
		return self._verb
	
	func get_prefix() -> String:
		return self._prefix
	
	func get_suffix() -> String:
		return self._suffix
	
	func get_color() -> String:
		if self._color == "":
			return self.get_adjective()
		return self._color
	
	func get_density() -> String:
		if self._density == "":
			return self.get_density()
		return self._density
	
	func get_thickness() -> String:
		if self._thickness == "":
			return self.get_adjective()
		return self._thickness
	
	func get_by_attribute(attribute: String) -> String:
		match attribute:
			"singular":
				return self.get_singular()
			"plural":
				return self.get_plural()
			"adjective":
				return self.get_adjective()
			"adverb":
				return self.get_adverb()
			"verb":
				return self.get_verb()
			"prefix":
				return self.get_prefix()
			"suffix":
				return self.get_suffix()
			"color":
				return self.get_color()
			"density":
				return self.get_density()
			"thickness":
				return self.get_thickness()
			_:
				return self.get_singular()


class TextState:
	var text: String
	var card_set: Dictionary[Vector2i, Card]
	var state: String
	var transition: Array[String]
	var sentence: Array[String]
	var plural: bool
	var subject_gender: int
	var last_subject: String
	var last_cards: Array[Vector2i]
	var texts_by_type: Dictionary[String, Array]
	
	func _init(_card_set: Dictionary[Vector2i, Card], _transition: Array[String],
			_texts_by_type: Dictionary[String, Array]) -> void:
		self.card_set = _card_set
		self.transition = _transition
		self.texts_by_type = _texts_by_type
		self.state = "sentence_end"
		self.text = ""
		self.plural = false
		self.subject_gender = -1
	
	func reset() -> void:
		self.state = "sentence_end"
		self.sentence.clear()
		self.plural = false
		self.subject_gender = -1


func add_card(dict: Dictionary[Vector2i, Card], card: Card,
		position: Vector2i) -> Card:
	dict[position] = card
	card.position = position
	return card

func pick_attribute(attributes: Array) -> String:
	var data: Variant = attributes.pick_random()
	if typeof(data) == TYPE_DICTIONARY:
		if "adjective" in data:
			return tr(data.adjective as String)
		else:
			return tr((data as Dictionary).values()[0] as String)
	elif typeof(data) == TYPE_ARRAY:
		data = data.pick_random()
		if typeof(data) == TYPE_ARRAY:
			return self.pick_attribute(data as Array)
		elif typeof(data) == TYPE_DICTIONARY:
			if "adjective" in data:
				return tr(data.adjective as String)
			else:
				return tr((data as Dictionary).values()[0] as String)
		else:
			return tr(data as String)
	else:
		return tr(data as String)

func pick_valid_card_set(type_set: Array, current_position: Vector2i,
		current_cards: Dictionary[Vector2i, Card], card_set: Array[Vector2i] = []) -> Array[Vector2i]:
	var index := card_set.size()
	if index >= type_set.size():
		return card_set
	if index == 0:
		for pos in current_cards:
			if current_cards[pos].type != type_set[index] or \
				Utils.get_distance(current_position, pos) > Utils.MAX_DIST:
					continue
			var array:= pick_valid_card_set(type_set, current_position, current_cards, [pos])
			if array.size() == type_set.size():
				return array
	else:
		for pos in card_set:
			var directions: Array[Vector2i] = Array(Utils.DIRECTIONS.duplicate(true), TYPE_VECTOR2I, "", null)
			directions.shuffle()
			for offset in directions:
				if current_cards.has(pos + offset) and \
					current_cards[pos + offset].type == type_set[index] and \
					Utils.get_distance(current_position, pos + offset) <= Utils.MAX_DIST:
						var array:= pick_valid_card_set(type_set, current_position, current_cards,
							Array(card_set + [pos + offset], TYPE_VECTOR2I, "", null))
						if array.size() == type_set.size():
							return array
	# no valid combinations found
	return []

func pick_valid_text(available_texts: Array[String],
		current_card_set: Dictionary[Vector2i, Card],
		texts_by_type: Dictionary[String, Array], last_positions: Array[Vector2i]) -> Dictionary:
	if current_card_set.size() == 0:
		return {}
	
	if last_positions.size() == 0:
		last_positions = current_card_set.keys()
	
	available_texts.shuffle()
	for type in available_texts:
		if type in texts_by_type:
			texts_by_type[type].shuffle()
			for text_data: Dictionary in texts_by_type[type]:
				var required: Array[String] = Array(text_data.get("required", []) as Array, TYPE_STRING, "", null)
				var card_pos := self.pick_valid_card_set(
					required,
					last_positions.pick_random() as Vector2i,
					current_card_set,
				)
				if card_pos.size() == required.size():
					var mapping := {}
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

func append_text(text_state: TextState, create_card: Callable, random_cards: Array[String],
		properties: Dictionary[String, Array]) -> TextState:
	var card_set := text_state.card_set.duplicate()
	var text_data := self.pick_valid_text(text_state.transition, card_set, text_state.texts_by_type,
		text_state.last_cards)
	if text_data.size() == 0:
		print("Warning: no valid texts available.")
		for i in range(4):
			var card_pos: Vector2i
			if text_state.card_set.size() > 0:
				card_pos = Utils.get_closest_position(
					text_state.card_set.keys().pick_random() as Vector2i,
					text_state.card_set.keys(),
				)
			else:
				card_pos = Utils.get_closest_position(Vector2(0, 0), text_state.card_set.keys())
			add_card(text_state.card_set,
				create_card.call(random_cards.pick_random() as String) as Card, card_pos)
		text_data = pick_valid_text(text_state.transition, text_state.card_set,
			text_state.texts_by_type, text_state.last_cards)
		if text_data.size() == 0:
			print("Warning: still no valid texts available after adding random cards")
			text_state.reset()
			text_state.state = "error"
			text_state.transition = Array(
				text_state.texts_by_type.sentence_end.pick_random().transition as Array,
				TYPE_STRING, "", null)
			return text_state
	
	for card: Card in (text_data.required as Dictionary).values():
		if card.position not in text_state.last_cards:
			text_state.last_cards.push_back(card.position)
	if text_state.last_cards.size() > 0:
		for i in range(randi() % floori(maxf(text_state.last_cards.size() / 2.0 - 0.5, 1.0))):
			text_state.last_cards.remove_at(randi() % text_state.last_cards.size())
	
	var text := ""
	var re := RegEx.new()
	var results: Array[RegExMatch]
	var format_dict := {}
	var add_text: String
	var repeated_subject := false
	var subject_key := ""
	var skip := false
	if "text" in text_data:
		text = (text_data.text as Array).pick_random()
	re.compile(r"{([\w\.'/]+)}")
	results = re.search_all(text)
	if results.size() > 0 and "sentence" in text_data:
		var has_subject := false
		if "subject" in text_data:
			for result in results:
				var res_str := result.get_string(1)
				if text_data.subject in res_str:
					has_subject = true
					if "plural" in res_str:
						text_state.plural = true
						break
					elif "singular" in res_str:
						text_state.plural = false
						break
		if not has_subject and "object" in text_data:
			for result in results:
				var res_str:= result.get_string(1)
				if text_data.object in res_str:
					if "plural" in res_str:
						text_state.plural = true
						break
	for result in results:
		var key := result.get_string(1)
		if "/" in key:
			var array:= key.split("/")
			if text_state.plural and array.size() > 1:
				format_dict[key] = array[1]
			else:
				format_dict[key] = array[0]
		elif '.' in key:
			var array := key.split('.')
			var topic := array[0]
			var attribute := array[1]
			if topic not in text_data.required:
				print("Warning: key " + topic + " missing in text data")
				format_dict[key] = self.pick_attribute(properties.values())
				continue
			
			var property := text_data.required[topic].properties as Descriptions.Property
			var prop := property.get_by_attribute(attribute)
			#text_state.plural = property.is_plural()
			text_state.plural = attribute == "plural" and property.is_plural()
			format_dict[key] = prop
			if "sentence" in text_data and "subject" in text_data.sentence and \
					text_data.sentence.subject == topic:
				if prop == text_state.last_subject:
					repeated_subject = true
				subject_key = key
				text_state.last_subject = prop
			if property.is_name and attribute in ["singular", "plural"]:
				var pos := result.get_start(1)
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
			format_dict[key] = pick_attribute(properties.values().pick_random())
			continue
		
	
	for s: String in text_data.get("sentence", {}):
		if s in text_state.sentence:
			if "predicate" in text_data.sentence and "predicate" in text_state.sentence:
				skip = true
				print("Info: skipping text part")
			if not skip and text_state.text.length() > 0 and \
				text_state.text[text_state.text.length() - 1] != " ":
					text_state.text += " "
	for s: String in text_data.get("sentence", {}):
		if s not in text_state.sentence:
			text_state.sentence.push_back(s)
	if "termination" in text_state.sentence:
		if text_state.text.right(1) not in ['.', ',', '!', '?', ':', '-']:
			if "subordinate" in text_state.sentence:
				text_state.text += ','
			else:
				text_state.text += '.'
		text_state.reset()
	if text_state.text.length() > 0 and text_state.text[text_state.text.length() - 1] != " " and \
		text.length() > 0 and text[0] != '.' and not skip:
			text_state.text += " "
	if repeated_subject and not skip:
		var pos:= text.find(subject_key) - 1
		var lpos:= text.rfind(" ", pos - 2)
		var sub_str: String
		if lpos < 0:
			lpos = 0
		sub_str = text.substr(lpos, pos - lpos)
		if "the " in sub_str or "The " in sub_str or "a " in sub_str or "A " in sub_str or \
			"an " in sub_str or "An " in sub_str:
			text = text.substr(0, lpos) + text.substr(pos)
			if text_state.plural:
				format_dict[subject_key] = "they"
			else:
				format_dict[subject_key] = "it"
			text_state.last_subject = ""
	if not skip:
		add_text = text.format(format_dict)
		if text_state.state == "sentence_end" and add_text.length() > 0 and \
			(text_state.text.length() == 0 or \
			text_state.text[max(text_state.text.length() - 2, 0)] not in [',', ':', '-']):
				add_text[0] = add_text[0].to_upper()
		text_state.text += add_text
	text_state.transition = Array(text_data.get("transition",
		text_state.texts_by_type.sentence_end.pick_random().transition) as Array, TYPE_STRING, "", null,
	)
	text_state.state = text_data.type
	
	for key: String in text_data.get("remove", []):
		text_state.card_set.erase(text_data.required[key].position)
	for key: String in text_data.get("add", []):
		self.add_card(text_state.card_set, create_card.call(key) as Card, Utils.get_closest_position(
			text_state.card_set.keys().pick_random() as Vector2i, text_state.card_set.keys()))
	for key: String in text_data.get("replace", {}):
		text_state.card_set.erase(text_data.required[key].position)
		self.add_card(text_state.card_set, create_card.call(text_data.replace[key] as String) as Card,
			text_data.required[key].position as Vector2i)
	
	return text_state

func generate_description(card_set: Dictionary[Vector2i, Card], create_card: Callable,
		texts_by_type: Dictionary[String, Array], random_cards: Array[String],
		properties: Dictionary[String, Array], max_sentences:= 3) -> String:
	var available_texts: Array[String] = Array(
		texts_by_type.sentence_end.pick_random().transition as Array, TYPE_STRING, "", null,
	)
	var text_state := TextState.new(card_set, available_texts, texts_by_type)
	var no_sentences := 0
	var failures := 0
	text_state.last_cards = [Vector2i()]
	
	while no_sentences < max_sentences:
		text_state = self.append_text(
			text_state,
			create_card,
			random_cards,
			properties,
		)
		if text_state.state == "error":
			var pos := maxi(maxi(text_state.text.rfind('.'), text_state.text.rfind('!')),
				text_state.text.rfind('?')) + 1
			text_state.text = text_state.text.left(pos)
		elif text_state.state == "sentence_end":
			var pos := text_state.text.rfind('.', text_state.text.length() - 2)
			if pos > 0:
				var length := mini(text_state.text.length() - pos - 1, MAX_TEXT_LENGTH)
				if Utils.compare_strings(text_state.text.right(pos + 1),
					text_state.text.substr(maxi(pos - length, 0), length)) > 0.75:
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
	if string[0] == 'A' and string[1] == ' ':
		var pos2:= string.find(' ', 2)
		if string[pos2 - 1] == 's':
			string = "The" + string.substr(1)
		elif string[2].to_lower() in Names.VOVELS:
			string = "An" + string.substr(1)
	
	while pos >= 0 and pos < string.length():
		var pos2: int
		pos = string.findn(" a ", pos)
		if pos == -1:
			break
		pos2 = string.find(' ', pos + 3)
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
		if start and string[p] != " ":
			string[p] = string[p].to_upper()
			start = false
		if string[p] in ['.', '!', '?']:
			start = true
	return string
