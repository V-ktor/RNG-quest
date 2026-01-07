extends Node

var domain_data: Dictionary[String, Dictionary] = {}
var attribute_data: Array[Dictionary] = []

var gods: Dictionary[String, God] = {}


func create_god(tags: Array[String], tier:= 2) -> God:
	var domains := pick_domains(tags, tier)
	var data := {
		"name": generate_name(self.domain_data[domains.pick_random()], tags),
		"domains": domains,
	}
	var god_tags: Array[String] = []
	tags.shuffle()
	for i in range(ceili(tags.size() / 2.0)):
		if randf() < 0.5:
			god_tags.push_back(tags[i])
	for d in domains:
		var domain := self.domain_data[d]
		var domain_tags := domain.get("tags", []) as Array
		domain_tags.shuffle()
		for i in range(ceili(domain_tags.size() / 2.0)):
			god_tags.push_back(domain_tags[i])
		data.tags = god_tags
	
	var ID := (data.get("name", "god" + str(randi())) as String).to_lower().replace(" ", "_")
	var index := 1
	while ID + str(index) in self.gods:
		index += 1
	data.ID = ID + str(index)
	
	var god := God.new(data)
	self.gods[god.ID] = god
	return god

func get_valid_domains(tags: Array[String]) -> Array[String]:
	var contains:= func contains(tag: String):
		return tag in tags
	
	var valid_domains: Array[String] = []
	for d in domain_data:
		if "tags" in domain_data[d] and not domain_data[d].tags.any(contains):
			continue
		valid_domains.push_back(d)
	
	if valid_domains.size() == 0:
		return domain_data.keys()
	return valid_domains

func pick_domains(tags: Array[String], number: int) -> Array[String]:
	var valid_domains := get_valid_domains(tags)
	var domains: Array[String] = []
	valid_domains.shuffle()
	for i in range(mini(number, valid_domains.size())):
		domains.push_back(valid_domains[i])
	return domains

func get_properties(tags: Array[String], property: String) -> Array[String]:
	var contains:= func contains(tag: String):
		return tag in tags
	
	var properties: Array[String] = []
	for a in self.attribute_data:
		if "tags" in a and not a.tags.any(contains):
			continue
		properties += Array(a.get(property, []) as Array, TYPE_STRING, "", null)
	
	if properties.size() == 0:
		if self.attribute_data.size() == 0:
			return []
		return Array(self.attribute_data.pick_random().get(property, []) as Array,
			TYPE_STRING, "", null)
	return properties

func generate_name(domain: Dictionary, tags: Array[String]) -> String:
	var rnd := randf()
	var base_name: String
	
	if "cyborg" in tags or "robot" in tags:
		base_name = Names.create_name("ai_overlord", randi_range(-1, 1))
	elif "science" in tags or "research" in tags:
		base_name = Names.create_name("scientific_god", randi_range(-1, 1))
	elif "elf" in tags:
		base_name = Names.create_name("elf_god", randi_range(-1, 1))
	elif "brutality" in tags or "orc" in tags or "goblin" in tags or "ogre" in tags:
		base_name = Names.create_name("primal_god", randi_range(-1, 1))
	else:
		base_name = Names.create_name("human_god", randi_range(-1, 1))
	
	if rnd < 0.15 and "suffix" in domain:
		return "the One " + domain.get("suffix", ["who is generic"]).pick_random()
	if (rnd < 0.3 or ("title" not in domain and "prefix" not in domain)) and "suffix" in domain:
		return "the God " + domain.get("suffix", ["who is generic"]).pick_random()
	if rnd < 0.45 and "title" in domain and "prefix" in domain:
		return "the " + domain.get("prefix", ["undefined"]).pick_random() + " One"
	if (rnd < 0.6 or ("suffix" not in domain and "title" not in domain)) and "prefix" in domain:
		return "the " + domain.get("prefix", ["undefined"]).pick_random() + " God"
	if rnd < 0.75 and "title" in domain:
		return base_name + " the " + domain.get("title", ["unknown"]).pick_random()
	#if rnd < 0.8 and "title" in domain and "suffix" in domain:
		#return base_name + " the " + domain.get("title", ["unknown"]).pick_random() + " " + domain.get("suffix", ["who is generic"]).pick_random()
	if "title" in domain:
		return "the " + domain.get("title", ["unknown"]).pick_random()
	if "suffix" in domain:
		return base_name + " " + domain.get("suffix", ["who is generic"]).pick_random()
	return base_name

func pick_property(god_id: String, attribute: String) -> String:
	var god := self.gods[god_id]
	if god.tmp_properties.size() == 0:
		for p in ["adjective", "predicate", "concept"]:
			god.tmp_properties[p] = get_properties(god.tags, p)
	
	if attribute == "domain":
		return god.domains.pick_random()
	return god.tmp_properties[attribute].pick_random() as String


### Loading ###

func load_domain_data(paths: Array[String]):
	for file_name in paths:
		var file:= FileAccess.open(file_name, FileAccess.READ)
		var error:= FileAccess.get_open_error()
		if error != OK:
			print("Can't open file " + file_name)
			continue
		else:
			print("Loading skill module " + file_name)
		
		var raw:= file.get_as_text()
		var data: Dictionary = JSON.parse_string(raw)
		if data == null || data.size() == 0:
			printt("Error parsing " + file_name)
			continue
		
		for type in data:
			self.domain_data[type] = data[type]
			file.close()

func load_attribute_data(paths: Array[String]):
	for file_name in paths:
		var file:= FileAccess.open(file_name, FileAccess.READ)
		var error:= FileAccess.get_open_error()
		if error != OK:
			print("Can't open file " + file_name)
			continue
		else:
			print("Loading skill module " + file_name)
		
		var raw:= file.get_as_text()
		var data: Array = JSON.parse_string(raw)
		if data == null || data.size() == 0:
			printt("Error parsing " + file_name)
			continue
		
		for d in data:
			if typeof(d) != TYPE_DICTIONARY:
				continue
			self.attribute_data.push_back(d)

func _ready() -> void:
	load_domain_data(Utils.get_file_paths("res://data/gods/domains"))
	load_attribute_data(Utils.get_file_paths("res://data/gods/attributes"))
	
