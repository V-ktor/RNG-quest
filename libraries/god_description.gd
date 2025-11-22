extends Node

var domain_data: Dictionary[String, Dictionary] = {}

var gods: Dictionary[String, God] = {}


func create_god(tags: Array[String]) -> God:
	var valid_domains := get_valid_domains(tags)
	var domain := domain_data[valid_domains.pick_random() as String]
	var data := {
		"name": generate_name(domain, tags)
	}
	
	var ID := data.get("name", "god" + str(randi())) as String
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
			domain_data[type] = data[type]
			file.close()

func _ready() -> void:
	load_domain_data(Utils.get_file_paths("res://data/gods/domains"))
	
