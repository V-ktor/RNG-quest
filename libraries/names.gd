extends Node

const CONS: Array[String] = ["b","c","d","f","g","h","j","k","l","m","n","p","r","s","t","v","w","x","y","z"]
const VOVELS: Array[String] = ["a","e","o","u","i"]
const ONLY_CENTRAL: Array[String] = ["-","'"]

const MATERIALS: Array[String] = [
	"iron","steel","titanium","silver","gold","platinum","mithril","vanadium","palladium",
	"thorium","uranium","quicksilver","mercury","tungsten",
	"aramid","leather","wood","redwood","blackwood","whitewood","silk","velvet","carbon",
	"stone","basalt","graphite","granite","marble",
	"diamond","saphire","ruby","emerald","amber",
]
const NAME_DATA: Dictionary[String, Dictionary] = {
	"human": {
		"phrases_male": ["or","esh","us","car","end","rus","har"],
		"phrases_female": ["ia","as","el","icy","bec","ate","sal"],
		"endings_male": ["us","or","en","ki"],
		"endings_female": ["ya","ir","ca","ia"],
		"phrases": [1,2],
	},
	"halfling": {
		"phrases_male": ["sau","fro","nir","cen","ray","alf","ba"],
		"phrases_female": ["ley","sal","nel","anth","ma","hilf","che","ryl"],
		"endings_male": ["ris","ing","do","am"],
		"endings_female": ["ra","ne","ke","ca"],
		"phrases": [1,1],
	},
	"elf": {
		"phrases_male": ["ama","egé","len","ar","rid","ril","vón","or","thr","ond","óld"],
		"phrases_female": ["ame","cle","ria","ide","adë","ódi","nón","ili","ól","niel"],
		"endings_male": ["old","egé","rid","ril"],
		"endings_female": ["ndë","adë","niel","ith"],
		"vovels": ["a","e","o","u","i","á","é","ë","ó"],
		"phrases": [1,3],
	},
	"dwarf": {
		"phrases_male": ["ard","ol","tis","til","th","as","ai","dur","us","go","hat","kar"],
		"phrases_female": ["ak","uth","hik","dir","urd","tia","het"],
		"endings_male": ["dur","ard","til","arl"],
		"endings_female": ["ak","dir","tia","mir"],
		"phrases": [1,2],
	},
	"orc": {
		"phrases_male": ["nak","ush","rag","gor","ar","dish","ork","uk","urt"],
		"phrases_female": ["urk","ik","ish","vag","pun","nak","lo","rak"],
		"endings_male": ["ush","gor","uk"],
		"endings_female": ["ik","rak","ish"],
		"phrases": [1,3],
	},
	"goblin": {
		"phrases_male": ["gla","gak","bli","in","ra","ta","da"],
		"phrases_female": ["gli","gra","gru","ni","ar","ti","om"],
		"endings_male": ["usk","grk","yik"],
		"endings_female": ["yak","gra","isk"],
		"phrases": [1,1],
	},
	"gnoll": {
		"phrases_male": ["glo","gok","dle","yn","wa","to","la"],
		"phrases_female": ["gle","gri","dru","ny","aw","te","il"],
		"endings_male": ["usk","grk","yik"],
		"endings_female": ["yak","gra","isk"],
		"phrases": [2,2],
	},
	"ogre": {
		"phrases_male": ["glo","gok","dle","in","ra","ta","da"],
		"phrases_female": ["gle","gri","dru","ni","ar","ti","om"],
		"endings_male": ["ush","gor","uk"],
		"endings_female": ["ik","rak","ish"],
		"phrases": [1,2],
	},
	"naga": {
		"phrases_male": ["skt","tes","cs","zh"],
		"phrases_female": ["kra","zes","sh","ni"],
		"endings_male": ["esh","rer","'zr"],
		"endings_female": ["ak","za","'cs"],
		"vovels": ["a","e","o","u","i","'","'"],
		"phrases": [1,2],
	},
	"undead": {
		"phrases_male": ["mal","bal","dur","ak"],
		"phrases_female": ["mel","bil","ald","yu"],
		"endings_male": ["ur","usk","oth","dor"],
		"endings_female": ["ar","isk","eth","dal"],
		"phrases": [2,2],
	},
	"demon": {
		"phrases_male": ["wry","esk","thor","pain","death","break"],
		"phrases_female": ["wer","yis","agon","iny","lept","frigh"],
		"endings_male": ["tor","mentor","coth","dor"],
		"endings_female": ["ria","itor","veth","dal"],
		"phrases": [2,2],
	},
	"cyborg": {
		"phrases_male": ["bil","hor","and","yu","bos","to","che"],
		"phrases_female": ["mol","gil","hal","ri","bet","ty","si"],
		"endings_male": ["-1s","-m0",":I",".j"],
		"endings_female": ["-2f","-w9",":E",".a"],
		"vovels": ["a","e","o","u","i","0","1","2","3","4","5","6","7","8","9"],
		"cons": ["b","c","d","f","g","h","j","k","l","m","n","p","r","s","t","v","w","x","y","z",".",": ","-","/"],
		"phrases": [1,2],
	},
	"archmage": {
		"phrases_male": ["alt","bumb","snap","pyr","emo","thor","ileus","proc","proxi","delv","disti"],
		"phrases_female": ["cele","stel","siri","yeno","tal","hexa","cry","valc","fon","nic","clai"],
		"endings_male": ["dore","inux","lord","tus"],
		"endings_female": ["aire","ris","ella","in"],
		"phrases": [1,2],
	},
	"ai_overlord": {
		"phrases_male": ["hex", "penti", "giga", "eta", "pro", "cess", "bit", "over"],
		"phrases_female": ["hexa", "penta", "tera", "exa", "hal", "byte", "super"],
		"endings_male": ["tron", "er", "or"],
		"endings_female": ["ia", "in", "net"],
		"phrases": [1,2],
	},
	"primal_god": {
		"phrases_male": ["bo", "de", "du", "fe", "go", "ko", "lo", "ne", "no", "pe", "quo", "que", "re", "ro", "to", "ti", "xi", "xa"],
		"phrases_female": ["bi", "ci", "da", "di", "fa", "ga", "gi", "ka", "la", "li", "le", "ma", "mi", "pi", "ri", "ta", "xe", "ya"],
		"endings_male": ["rik", "tic", "tok", "mop", "xo", "cho", "po"],
		"endings_female": ["tac", "rac", "fic", "xi", "si", "re"],
		"phrases": [2,4],
	},
	"scientific_god": {
		"phrases_male": ["holo", "mono", "quattro", "octo", "multi", "omni", "spatio", "gravo",
			"pyro", "cryo", "electro", "necro", "toxo", "ethero", "ferro", "xeno", "xylo",
			"zoo", "crystallo", "cyber", "theo", "elasto", "galacto", "metro", "demo", "auto",
			"nano", "phero", "photo", "radio", "lepto", "hypno", "bureau", "archeo", "astro",
			"phantas", "trans", "ego", "tyranno", "panto", "contro", "pro", "idio", "plasto",
			"endo", "arcano", "thermo", "crypto", "mero", "meso", "hyper", "anthropo"],
		"phrases_female": ["homo", "bi", "tri", "penta", "hexa", "deca", "hydro", "aeoro", "bio",
			"terra", "micro", "macro", "sui", "somni", "tetra", "video", "audio", "lingui", "para",
			"propa", "paci", "pan", "eso", "anti", "phas", "spectro", "cis", "logi", "centri",
			"anony", "norma", "dyna", "phaeto", "stellar", "sonar", "meno", "grammo", "luna",
			"semi", "poly", "soli", "digi", "ana", "cata"],
		"endings_male": ["chromatic", "synthetic", "syntactic", "phil", "phantastic", "tic",
			"spatial", "temporal", "metric", "gravitational", "phonetic", "morphic", "metallic",
			"graphic", "gonic", "mantic", "galactic", "scence", "theric", "thereal", "mal",
			"elastic","centric", "mous", "static", "mite", "nautic", "nomic", "cryptic",
			"active", "logical", "septic", "cistic", "directional"],
		"endings_female": ["chrome", "phobe", "genic", "genetic", "mimetic", "nematic",
			"phosphatic", "scopic", "cidal", "phasic", "pheral", "sive",  "tal", "dynamic",
			"mimic", "phoric", "plasmonic"],
		"phrases": [1,2],
	},
	"human_god": {
		"phrases_male": ["dawn", "mighty", "all", "aeth", "bulk", "holy", "world"],
		"phrases_female": ["dusk", "star", "harv", "est", "aeg", "beau", "crop"],
		"endings_male": ["ther", "lord", "bringer", "bearer", "man", "las", "en"],
		"endings_female": ["thra", "any", "terra", "weaver", "gal", "ya"],
		"vovels": ["a","e","o","u","i","y"],
		"phrases": [1,1],
	},
	"elf_god": {
		"phrases_male": ["nor", "ris", "le", "egé","len", "thr","ond","óld"],
		"phrases_female": ["shan", "kri", "thy", "fore", "ame","adë","ódi"],
		"endings_male": ["thon", "lan", "rbis"],
		"endings_female": ["thor", "la", "ith"],
		"vovels": ["a","e","o","u","i","á","é","ë","ó"],
		"phrases": [2,2],
	},
}
const RACE_ADJECTIVE: Dictionary[String, String] = {
	"elf": "elven",
	"dwarf": "dwarven",
	"orc": "orcish",
}
const EMPIRE_GENERIC_NAME: Array[String] = [
	"empire", "kingdom", "state", "realm", "division", "republic",
]
const EMPIRE_RACE_NAME: Dictionary[String, Array] = {
	"human": [
		"guild","republic","kingdom","empire",
	],
	"halfling": [
		"kingdom","empire","state","aristocracy",
	],
	"dwarf": [
		"company","kingdom",
	],
	"orc": [
		"tribe","tribes",
		"army","warband","marauders",
	],
	"goblin": [
		"tribe","tribes","gang","pack",
	],
	"gnoll": [
		"tribe","tribes",
		"army","warband","division",
	],
}
const EMPIRE_RACE_ADJECTIVE: Dictionary[String, Array] = {
	"human": [
		"trader","golden","iron",
	],
	"elf": [
		"enlightened","wise","ancient","elder",
	],
	"dwarf": [
		"mining","miner",
	],
	"orc": [
		"warmongering",
	],
	"goblin": [
		"feral","wild",
	],
}
const EMPIRE_RACE_TOPIC: Dictionary[String, Array] = {
	"elf": [
		"wisdom","elders","woods",
	],
	"dwarf": [
		"industry","mining",
	],
	"orc": [
		"warlords","bannerlord","warfare",
	],
}
const DISEASE_NAME: Array[String] = [
	"flu", "pox", "rot", "virus",
]
const DISEASE_PREFIX: Array[String] = [
	"chicken", "cow", "black",
]
const PREFIX: Array[String] = [
	"holo", "homo", "hetero", "mono", "bi", "tri", "quattro", "penta", "hexa", "octo", "deca",
	"multi", "omni", "spatio", "gravo", "pyro", "cryo", "electro", "hydro", "aeoro", "terra", "bio",
	"necro", "micro", "macro", "toxo", "ethero", "sui", "somni", "ferro", "xeno", "xylo", "tetra",
	"video", "audio", "lingui", "para", "zoo", "crystallo", "cyber", "propa", "paci", "pan", "eso",
	"theo", "anti", "phas", "spectro", "cis", "elasto", "galacto", "metro", "verti", "horizon",
	"logi", "centri", "demo", "auto", "anony", "norma", "dyna", "nano", "phero", "phaeto", "photo",
	"radio", "lepto", "hypno", "stellar", "sonar", "bureau", "archeo", "astro", "meno", "grammo",
	"phantas", "trans", "luna", "semi", "ego", "tyranno", "dyna", "panto", "contro", "pro", "idio",
	"poly", "plasto", "endo", "soli", "arcano", "thermo", "crypto", "mero", "meso", "digi", "ana",
	"hyper", "anthropo", "cata",
]
const SUFFIX: Array[String] = [
	"chrome", "chromatic", "synthetic", "syntactic", "phil", "phobe", "phantastic", "tic",
	"spatial", "temporal", "metric", "gravitational", "genic", "genetic", "mimetic", "nematic",
	"phosphatic", "phonetic", "scopic", "cidal", "phasic", "pheral", "morphic", "metallic",
	"graphic", "gonic", "sive", "mantic", "galactic", "scence", "theric", "thereal", "mal",
	"elastic", "tal", "centric", "mous", "static", "dynamic", "mite", "nautic", "nomic", "cryptic",
	"active", "logical", "septic", "cistic", "directional", "mimic", "phoric", "plasmonic",
]
const SUBJECT: Array[String] = [
	"phobia", "philia", "cide", "laxis", "scope", "mount", "graph", "phone", "borg", "maly",
	"noun", "void", "mancy", "maniac", "thesis", "matter", "cality", "cracy", "nomy", "phase",
	"gel", "synthesis", "tron", "logy", "vision", "centrism", "pluralism", "sepsis", "nol", "mere",
	"hedron", "phantasia", "enigma", "glyph", "nosis", "script", "chemical", "clysm", "cyst",
	"sphere", "gram",
]
const GREETINGS: Dictionary[String, Array] = {
	"neutral": [
		"Hello!","Hey!","Hi!","Good day!","Greetings!",
	],
	"polite": [
		"Nice to meet you, {sir/miss}.","It's a pleasure to meet you!",
	],
	"peasant": [
		"Howdy!","Howdy, partner!",
	],
	"cold": [
		"Hey.","Hi.",
	],
	"pious": [
		"May the gods bless you.","May the holy light guide you.",
	],
	"rogue": [
		"Nice purse!","What's in for me?",
	],
	"harsh": [
		"Yes?","Make it quick.",
	],
	"friendly": [
		"How may I help you?","Hey there!",
	],
	"curious": [
		"Is there something I should know?","You require my assistance?",
	],
	"arcane": [
		"The force is strong in you.","Magic shall prevail.",
	],
	"philosopher": [
		"Wanna partake in a trolley experiment of mine?",
	],
	"oracle": [
		"I knew you would come.","I awaited you'r arrival.",
	],
	"arrogant": [
		"What is it?","You're wasting my time.",
	],
	"shy": [
		"Y-yes?","Oh, y-you mean me?","How can I help you?",
	],
	"royal": [
		"You may enter.",
	],
}
const QUEST_DONE: Dictionary[String, Array] = {
	"neutral": [
		"Well done!","Great work!","Thank you!",
	],
	"polite": [
		"You have my thanks.","A job well executed.","You have my gratitute for completing the task.",
	],
	"peasant": [
		"Hell yeah!","You did it!","That was so amazing!",
	],
	"cold": [
		"Nice job.","Good work.",
	],
	"pious": [
		"God bless you!",
	],
	"rogue": [
		"Thanks!","Good to hear that was taken care of.","Hell yeah!",
	],
	"harsh": [
		"Mission accomplished.","Good.",
	],
	"friendly": [
		"Nice, good work!","That was amazing!","Many thanks!","Keep up the good work!",
	],
	"curious": [
		"How did it go?","You did it?","That went smoothly!",
	],
	"arcane": [
		"With great power comes great responsibility.","Your actions show great wisdom.","Magnificant!",
	],
	"philosopher": [
		"Wonderful!",
	],
	"oracle": [
		"I knew you would manage.","I have forseen your victory.",
	],
	"arrogant": [
		"About time...","That took you long enough.",
	],
	"shy": [
		"T-thank you!","You did a nice job.",
	],
	"royal": [
		"You may claim your reward.","You managed to fulfill your task.",
	],
	"programer": [
		"Transient parent has another exclusive child.",
	],
}
var dual_magic_names := {}


func make_list(array: Array) -> String:
	var string:= ""
	if array.size()==1:
		string = array[0]
	elif array.size()==2:
		string = array[0] + " and " + array[1]
	else:
		for i in range(array.size()):
			string += array[i]
			if i<array.size()-2:
				string += ", "
			elif i==array.size()-2:
				string += ", and "
	return string


func replace_syllable(_name: String, phrases: Array, vovels:= VOVELS, cons:= CONS) -> String:
	# Replace a syllable of name by a random one from phrases.
	var pos := 0
	var phrase: String = phrases[randi()%phrases.size()]
	var length := phrase.length()
	var v := false
	var c := 0
	var start := 0
	# Chose a random syllable to replace.
	for i in range(_name.length()):
		pos = i
		if _name[i] in vovels:
			if v:
				v = false
				c = 0
				if randf() < 0.5:
					break
				else:
					start = i
			else:
				v = true
		else:
			c += 1
			if c > 2:
				v = false
				c = 0
				if randf() < 0.5:
					break
				else:
					start = i
	length = absi(start - pos) + randi() % 2
	pos = start
	if _name.length() > 4 + randi() % 4:
		length += 1
	if pos + length > _name.length() - 1:
		pos -= pos + length - _name.length() + 1
	_name = _name.substr(0, pos) + phrase + _name.substr(pos + length, _name.length() - pos - length)
	# Replace a vovel by a consonant if there are too many in a row or vice versa.
	for i in range(maxi(pos - 1, 0), mini(pos + length + 1, _name.length() - 1)):
		if _name[clampi(i, 0, _name.length() - 1)] not in vovels && _name[clampi(i - 1, 0, _name.length() - 1)] not in vovels && _name[clampi(i + 1, 0, _name.length() - 1)] not in vovels:
			_name[i] = vovels.pick_random()
		elif (_name[clampi(i, 0, _name.length() - 1)] in vovels) && (_name[clampi(i - 1, 0, _name.length() - 1)] in vovels) && (_name[clampi(i + 1, 0, _name.length() - 1)] in vovels):
			_name[i] = cons.pick_random()
	if _name.length() > 2 && (_name[_name.length() - 1] in cons and _name[_name.length() - 2] in cons):
		_name[_name.length() - 1] = vovels.pick_random()
	pos = -3
	for i in range(_name.length()):
		if _name.length() > i && _name[i] in ONLY_CENTRAL:
			if absi(i - pos) <= 2:
				_name = _name.left(i - 1) + _name.substr(i + 1, _name.length() - i - 1)
			else:
				pos = i
	if _name[0] in ONLY_CENTRAL:
		phrase = phrases[randi() % phrases.size()]
		while phrase[0] in ONLY_CENTRAL:
			phrase = phrases[randi() % phrases.size()]
		_name = phrase + _name
	if _name[_name.length() - 1] in ONLY_CENTRAL:
		_name = _name.left(_name.length() - 1)
	return _name

func random_syllable(_name: String, vovels := VOVELS) -> String:
	var pos: int
	var dir: int
	var length: int
	for _i in range(20):
		pos = randi() % (_name.length())
		if _name[pos] in vovels:
			break
	if pos == 0:
		dir = 1
	elif pos == _name.length() - 1:
		dir = -1
	else:
		dir = 2 * (randi() % 2) - 1
	length = randi() % 3
	if pos + dir * length < 0:
		length += pos + dir * length
	elif pos + dir * length > _name.length() - 1:
		length -= pos + dir * length - _name.length() + 1
	for i in range(pos, pos + dir * length, dir):
		_name = _name.substr(0, i) + CONS.pick_random() + _name.substr(i + 1, _name.length() - 1 - i)
	for i in range(_name.length()):
		if _name[clampi(i, 0, _name.length() - 1)] not in vovels && _name[clampi(i - 1, 0, _name.length() - 1)] not in vovels && _name[clampi(i + 1, 0, _name.length() - 1)] not in vovels:
			_name[i] = vovels.pick_random()
	return _name

func create_from_phrases(length: int, phrases: Array[String], endings: Array[String], vovels := VOVELS, cons := CONS) -> String:
	var _name:= ""
	var ending_first := false
	var last_char: String
	if randf() < 0.1:
		ending_first = true
	for _i in range(length - 1):
		_name += phrases.pick_random()
	if ending_first:
		_name += endings.pick_random()
	for _i in range(randi() % floori(1 + 0.25 * _name.length()) + 1):
		_name = replace_syllable(_name, phrases, vovels, cons)
	if not ending_first:
		_name += endings.pick_random()
	last_char = _name[0]
	for i in range(1, _name.length()):
		if _name[i] == last_char && last_char in vovels:
			_name = _name.left(i - 1) + _name.substr(i)
		if i + 1 >= _name.length():
			break
		else:
			last_char = _name[i]
	return _name.capitalize().replace(' ','')


func create_name(race: String, gender: int) -> String:
	var dict: Dictionary
	var _name: String
	var phrases: Array[String] = []
	var endings: Array[String] = []
	var vovels: Array[String]
	if race in NAME_DATA:
		dict = NAME_DATA[race]
	else:
		dict = NAME_DATA.values().pick_random().duplicate(true)
		for k: String in dict:
			var d: Dictionary = NAME_DATA.values().pick_random()
			if k in d:
				dict[k] += d[k]
	if gender <= 0:
		phrases += Array(dict.phrases_male as Array, TYPE_STRING, "", null)
		endings += Array(dict.endings_male as Array, TYPE_STRING, "", null)
	if gender >= 0:
		phrases += Array(dict.phrases_female as Array, TYPE_STRING, "", null)
		endings += Array(dict.endings_female as Array, TYPE_STRING, "", null)
	if "vovels" in dict:
		vovels = Array(dict.vovels, TYPE_STRING, "", null)
	else:
		vovels = VOVELS
	
	_name = create_from_phrases(
		randi_range(dict.phrases[0] as int, dict.phrases[1] as int),
		phrases,
		endings,
		vovels,
		CONS,
	)
	
	return _name

func get_disease_name() -> String:
	return (DISEASE_PREFIX.pick_random() + " " + DISEASE_NAME.pick_random()).capitalize()

func get_empire_name(race: String) -> String:
	var rnd:= randf()
	if rnd < 0.075:
		if RACE_ADJECTIVE.has(race):
			return (RACE_ADJECTIVE[race] + " " + EMPIRE_GENERIC_NAME.pick_random()).capitalize()
		else:
			return ((race + " " + EMPIRE_GENERIC_NAME.pick_random()) as String).capitalize()
	elif rnd < 0.15:
		return EMPIRE_GENERIC_NAME.pick_random().capitalize() + " " + tr("OF") + " " + race.capitalize() + "s"
	elif rnd < 0.35:
		var base: String
		if EMPIRE_RACE_NAME.has(race):
			base = EMPIRE_RACE_NAME[race].pick_random()
		else:
			base = EMPIRE_GENERIC_NAME.pick_random()
		if EMPIRE_RACE_ADJECTIVE.has(race):
			return (EMPIRE_RACE_ADJECTIVE[race].pick_random() + " " + base).capitalize()
		elif RACE_ADJECTIVE.has(race):
			return (RACE_ADJECTIVE[race] + " " + base).capitalize()
		else:
			return (race + " " + base).capitalize()
	elif rnd < 0.55:
		var base: String
		if EMPIRE_RACE_NAME.has(race):
			base = EMPIRE_RACE_NAME[race].pick_random()
		else:
			base = EMPIRE_GENERIC_NAME.pick_random()
		if EMPIRE_RACE_TOPIC.has(race):
			return base.capitalize() + " " + tr("OF") + " " + EMPIRE_RACE_TOPIC[race].pick_random().capitalize()
		else:
			return base.capitalize() + " " + tr("OF") + " " + create_name(race, 0).capitalize()
	if EMPIRE_RACE_NAME.has(race):
		return EMPIRE_RACE_NAME[race].pick_random().capitalize() + " " + tr("OF") + " " + create_name(race, 0).capitalize()
	return EMPIRE_GENERIC_NAME.pick_random().capitalize() + " " + tr("OF") + " " + create_name(race, 0).capitalize()
