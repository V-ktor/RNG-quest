extends Node

const CONS = ["b","c","d","f","g","h","j","k","l","m","n","p","r","s","t","v","w","x","y","z"]
const VOVELS = ["a","e","o","u","i"]
const ONLY_CENTRAL = ["-","'"]

const GOD_PREFIX = [
	"War","Weapon","Doom","Death","fierce","grumpy","ferocious","wild","dumb","blind","almighty",
	"ugly","beautiful","cruel","hated","forbidden","shackled","auxiliary","temporary","dead","Sex",
	"Science","Magic","arcane","illuminated","dreaming","sleeping","hibernating","banned","wild",
	"Light","Shadow","Life","Fire","Ice","Water","Earth","forgotten","mossy","golden","shining",
	"Random Number","procedurally generated","Vegetarian","Vegan","rural","knowledgeable","wise",
	"the one and only","beloved","wicked","Demon","praised","Prime",
]
const GOD_SUFFIX = [
	"War","Warfare","Conflict","Violence","Death","Murder","Harm","Peace","Altruism","Prosperity",
	"Technology","Ingenuity","Construction","Nature","Hell","Heaven","Science","Knowledge","Life",
	"Healing","Destruction","Love","Hate","Birth","Fertility","Fortitude","Virtuosity","Rebirth",
	"Wisdom","Magic","Dedication","Passion","Light","Darkness","Fire","Ice","Water","Earth","Art",
	"Shadows","Void","the Dead","Space","Time","Fashion","Agriculture","Power","Beauty","Cards",
	"Random Numbers","Procedural Generation","Segmentation Fault","Bugs","Curses","Doom",
	"Flora","Fauna","Sleep","Dreams","Gold",
]
const ARCHMAGE_PHRASES = [
	"aire","cele","alt","dore","bumb","lord","snap","pyr","emo","yeno","thor","ileus","inux","dot",
]
const MATERIALS = [
	"iron","steel","titanium","silver","gold","platinum","mithril","vanadium","palladium",
	"thorium","uranium","quicksilver","mercury","tungsten",
	"aramid","leather","wood","redwood","blackwood","whitewood","silk","velvet","carbon",
	"stone","basalt","graphite","granite","marble",
	"diamond","saphire","ruby","emerald","amber",
]
const ARTIFACT_DESCRIPTIONS = [
	"The {adjective} {material} can't hide the {theme} beneath.",
	"The {adjective} {base_name} of the {theme}.",
	"{material} {base_name}, {name} of the {theme}.",
	"The legendary artifact of the {adjective} {theme}.",
	"Unremarkable {base_name} bearing the power of the {adjective} {theme}.",
	"{material} on the outside but {adjective} {theme} on the inside.",
	"{adjective} {base_name} powered by {theme}.",
	"{adjective} {base_name} that can't escape it's {theme}.",
	"{adjective} {base_name} covered in {feature}.",
	"The {adjective} {feature} gives an idea about the {name}'s {theme}.",
	"{feature} obfuscate the {theme} of the {adjective} {name}.",
	"The {theme} {feature} {is/are} said to be {adjective}.",
	"The {feature} contrast{s} the {adjective} {material} of the {base_name}.",
	"{base_name} surrounded by a {adjective} aura of {theme}.",
	"Not everything that is {adjective} is {material}.",
]
const NAME_DATA = {
	"human":{
		"phrases_male":["or","esh","us","car","end","rus","har"],
		"phrases_female":["ia","as","el","icy","bec","ate","sal"],
		"endings_male":["us","or","en","ki"],
		"endings_female":["ya","ir","ca","ia"],
		"phrases":[1,2],
	},
	"halfling":{
		"phrases_male":["sau","fro","nir","cen","ray","alf","ba"],
		"phrases_female":["ley","sal","nel","anth","ma","hilf","che","ryl"],
		"endings_male":["ris","ing","do","am"],
		"endings_female":["ra","ne","ke","ca"],
		"phrases":[1,1],
	},
	"elf":{
		"phrases_male":["ama","egé","len","ar","rid","ril","vón","or","thr","ond","óld"],
		"phrases_female":["ame","cle","ria","ide","adë","ódi","nón","ili","ól","niel"],
		"endings_male":["old","egé","rid","ril"],
		"endings_female":["ndë","adë","niel","ith"],
		"vovels":["a","e","o","u","i","á","é","ë","ó"],
		"phrases":[1,3],
	},
	"dwarf":{
		"phrases_male":["ard","ol","tis","til","th","as","ai","dur","us","go","hat","kar"],
		"phrases_female":["ak","uth","hik","dir","urd","tia","het"],
		"endings_male":["dur","ard","til","arl"],
		"endings_female":["ak","dir","tia","mir"],
		"phrases":[1,2],
	},
	"orc":{
		"phrases_male":["nak","ush","rag","gor","ar","dish","ork","uk","urt"],
		"phrases_female":["urk","ik","ish","vag","pun","nak","lo","rak"],
		"endings_male":["ush","gor","uk"],
		"endings_female":["ik","rak","ish"],
		"phrases":[1,3],
	},
	"goblin":{
		"phrases_male":["gla","gak","bli","in","ra","ta","da"],
		"phrases_female":["gli","gra","gru","ni","ar","ti","om"],
		"endings_male":["usk","grk","yik"],
		"endings_female":["yak","gra","isk"],
		"phrases":[1,1],
	},
	"gnoll":{
		"phrases_male":["glo","gok","dle","yn","wa","to","la"],
		"phrases_female":["gle","gri","dru","ny","aw","te","il"],
		"endings_male":["usk","grk","yik"],
		"endings_female":["yak","gra","isk"],
		"phrases":[2,2],
	},
	"ogre":{
		"phrases_male":["glo","gok","dle","in","ra","ta","da"],
		"phrases_female":["gle","gri","dru","ni","ar","ti","om"],
		"endings_male":["ush","gor","uk"],
		"endings_female":["ik","rak","ish"],
		"phrases":[1,2],
	},
	"naga":{
		"phrases_male":["skt","tes","cs","zh"],
		"phrases_female":["kra","zes","sh","ni"],
		"endings_male":["esh","rer","'zr"],
		"endings_female":["ak","za","'cs"],
		"vovels":["a","e","o","u","i","'","'"],
		"phrases":[1,2],
	},
	"undead":{
		"phrases_male":["mal","bal","dur","ak"],
		"phrases_female":["mel","bil","ald","yu"],
		"endings_male":["ur","usk","oth","dor"],
		"endings_female":["ar","isk","eth","dal"],
		"phrases":[2,2],
	},
	"demon":{
		"phrases_male":["wry","esk","thor","pain","death","break"],
		"phrases_female":["wer","yis","agon","iny","lept","frigh"],
		"endings_male":["tor","mentor","coth","dor"],
		"endings_female":["ria","itor","veth","dal"],
		"phrases":[2,2],
	},
	"cyborg":{
		"phrases_male":["bil","hor","and","yu","bos","to","che"],
		"phrases_female":["mol","gil","hal","ri","bet","ty","si"],
		"endings_male":["-1s","-m0",":I",".j"],
		"endings_female":["-2f","-w9",":E",".a"],
		"vovels":["a","e","o","u","i","0","1","2","3","4","5","6","7","8","9"],
		"cons":["b","c","d","f","g","h","j","k","l","m","n","p","r","s","t","v","w","x","y","z",".",":","-"],
		"phrases":[1,2],
	},
}
const RACE_ADJECTIVE = {
	"elf":"elven",
	"dwarf":"dwarven",
	"orc":"orcish",
}
const EMPIRE_GENERIC_NAME = [
	"empire","kingdom","state","realm","division","republic",
]
const EMPIRE_RACE_NAME = {
	"human":[
		"guild","republic","kingdom","empire",
	],
	"halfling":[
		"kingdom","empire","state","aristocracy",
	],
	"dwarf":[
		"company","kingdom",
	],
	"orc":[
		"tribe","tribes",
		"army","warband","marauders",
	],
	"goblin":[
		"tribe","tribes","gang","pack",
	],
	"gnoll":[
		"tribe","tribes",
		"army","warband","division",
	],
}
const EMPIRE_RACE_ADJECTIVE = {
	"human":[
		"trader","golden","iron",
	],
	"elf":[
		"enlightened","wise","ancient","elder",
	],
	"dwarf":[
		"mining","miner",
	],
	"orc":[
		"warmongering",
	],
	"goblin":[
		"feral","wild",
	],
}
const EMPIRE_RACE_TOPIC = {
	"elf":[
		"wisdom","elders","woods",
	],
	"dwarf":[
		"industry","mining",
	],
	"orc":[
		"warlords","bannerlord","warfare",
	],
}
const DISEASE_NAME = [
	"flu","pox","rot","virus",
]
const DISEASE_PREFIX = [
	"chicken","cow","black",
]
const GREETINGS = {
	"neutral":[
		"Hello!","Hey!","Hi!","Good day!","Greetings!",
	],
	"polite":[
		"Nice to meet you, {sir/miss}.","It's a pleasure to meet you!",
	],
	"peasant":[
		"Howdy!","Howdy, partner!",
	],
	"cold":[
		"Hey.","Hi.",
	],
	"pious":[
		"May the gods bless you.","May the holy light guide you.",
	],
	"rogue":[
		"Nice purse!","What's in for me?",
	],
	"harsh":[
		"Yes?","Make it quick.",
	],
	"friendly":[
		"How may I help you?","Hey there!",
	],
	"curious":[
		"Is there something I should know?","You require my assistance?",
	],
	"arcane":[
		"The force is strong in you.","Magic shall prevail.",
	],
	"philosopher":[
		"Wanna partake in a trolley experiment of mine?",
	],
	"oracle":[
		"I knew you would come.","I awaited you'r arrival.",
	],
	"arrogant":[
		"What is it?","You're wasting my time.",
	],
	"shy":[
		"Y-yes?","Oh, y-you mean me?","How can I help you?",
	],
	"royal":[
		"You may enter.",
	],
}
const QUEST_DONE = {
	"neutral":[
		"Well done!","Great work!","Thank you!",
	],
	"polite":[
		"You have my thanks.","A job well executed.","You have my gratitute for completing the task.",
	],
	"peasant":[
		"Hell yeah!","You did it!","That was so amazing!",
	],
	"cold":[
		"Nice job.","Good work.",
	],
	"pious":[
		"God bless you!",
	],
	"rogue":[
		"Thanks!","Good to hear that was taken care of.","Hell yeah!",
	],
	"harsh":[
		"Mission accomplished.","Good.",
	],
	"friendly":[
		"Nice, good work!","That was amazing!","Many thanks!","Keep up the good work!",
	],
	"curious":[
		"How did it go?","You did it?","That went smoothly!",
	],
	"arcane":[
		"With great power comes great responsibility.","Your actions show great wisdom.","Magnificant!",
	],
	"philosopher":[
		"Wonderful!",
	],
	"oracle":[
		"I knew you would manage.","I have forseen your victory.",
	],
	"arrogant":[
		"About time...","That took you long enough.",
	],
	"shy":[
		"T-thank you!","You did a nice job.",
	],
	"royal":[
		"You may claim your reward.","You managed to fulfill your task.",
	],
	"programer":[
		"Transient parent has another exclusive child.",
	],
}



func get_god_name() -> String:
	var string: String = GOD_PREFIX.pick_random() + " " + tr("GOD_OF") + " "
	var suffix: String = GOD_SUFFIX.pick_random()
	while string.to_lower().similarity(suffix.to_lower())>0.5:
		suffix = GOD_SUFFIX.pick_random()
	return string + suffix


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
	var pos:= 0
	var phrase: String = phrases[randi()%phrases.size()]
	var length:= phrase.length()
	var v:= false
	var c:= 0
	var start:= 0
	# Chose a random syllable to replace.
	for i in range(_name.length()):
		pos = i
		if _name[i] in vovels:
			if v:
				v = false
				c = 0
				if randf()<0.5:
					break
				else:
					start = i
			else:
				v = true
		else:
			c += 1
			if c>2:
				v = false
				c = 0
				if randf()<0.5:
					break
				else:
					start = i
	length = int(abs(start-pos))+randi()%2
	pos = start
	if _name.length()>4+randi()%4:
		length += 1
	if pos+length>_name.length()-1:
		pos -= pos+length-_name.length()+1
	_name = _name.substr(0,pos)+phrase+_name.substr(pos+length,_name.length()-pos-length)
	# Replace a vovel by a consonant if there are too many in a row or vice versa.
	for i in range(max(pos-1,0),min(pos+length+1,_name.length()-1)):
		if !(_name[clamp(i,0,_name.length()-1)] in vovels) && !(_name[clamp(i-1,0,_name.length()-1)] in vovels) && !(_name[clamp(i+1,0,_name.length()-1)] in vovels):
			_name[i] = vovels[randi()%vovels.size()]
		elif (_name[clamp(i,0,_name.length()-1)] in vovels) && (_name[clamp(i-1,0,_name.length()-1)] in vovels) && (_name[clamp(i+1,0,_name.length()-1)] in vovels):
			_name[i] = cons[randi()%cons.size()]
	if _name.length()>2 && (_name[_name.length()-1] in cons and _name[_name.length()-2] in cons):
		_name[_name.length()-1] = vovels[randi()%vovels.size()]
	pos = -3
	for i in range(_name.length()):
		if _name.length()>i && _name[i] in ONLY_CENTRAL:
			if abs(i-pos)<=2:
				_name = _name.left(i-1) + _name.substr(i+1, _name.length()-i-1)
			else:
				pos = i
	if _name[0] in ONLY_CENTRAL:
		phrase = phrases[randi()%phrases.size()]
		while phrase[0] in ONLY_CENTRAL:
			phrase = phrases[randi()%phrases.size()]
		_name = phrase+_name
	if _name[_name.length()-1] in ONLY_CENTRAL:
		_name = _name.left(_name.length()-1)
	return _name

func random_syllable(_name: String, vovels:=VOVELS) -> String:
	var pos: int
	var dir: int
	var length: int
	for _i in range(20):
		pos = randi()%(_name.length())
		if (_name[pos] in vovels):
			break
	if pos==0:
		dir = 1
	elif pos==_name.length()-1:
		dir = -1
	else:
		dir = 2*(randi()%2)-1
	length = randi()%3
	if pos+dir*length<0:
		length += pos+dir*length
	elif pos+dir*length>_name.length()-1:
		length -= pos+dir*length-_name.length()+1
	for i in range(pos,pos+dir*length,dir):
		_name = _name.substr(0,i)+CONS[randi()%CONS.size()]+_name.substr(i+1,_name.length()-1-i)
	for i in range(_name.length()):
		if !(_name[clamp(i,0,_name.length()-1)] in vovels) && !(_name[clamp(i-1,0,_name.length()-1)] in vovels) && !(_name[clamp(i+1,0,_name.length()-1)] in vovels):
			_name[i] = vovels[randi()%vovels.size()]
	return _name

func create_from_phrases(length: int, phrases: Array, endings: Array, vovels:= VOVELS, cons:= CONS) -> String:
	var _name:= ""
	var ending_first:= false
	var last_char: String
	if randf()<0.1:
		ending_first = true
	for _i in range(length-1):
		_name += phrases[randi()%phrases.size()]
	if ending_first:
		_name += endings[randi()%endings.size()]
	for _i in range(randi()%int(1+0.25*_name.length())+1):
		_name = replace_syllable(_name, phrases, vovels, cons)
	if !ending_first:
		_name += endings[randi()%endings.size()]
	last_char = _name[0]
	for i in range(1,_name.length()):
		if _name[i]==last_char && last_char in vovels:
			_name = _name.left(i-1) + _name.substr(i)
		if i+1>=_name.length():
			break
		else:
			last_char = _name[i]
	return _name.capitalize().replace(' ','')


func get_archmage_name() -> String:
	var _name:= create_from_phrases(2+int(randf_range(-0.25,1.75)*randf_range(0.0,1.1)), ARCHMAGE_PHRASES, ARCHMAGE_PHRASES)
	return _name

func create_name(race: String, gender: int) -> String:
	var dict: Dictionary
	var _name: String
	var phrases:= []
	var endings:= []
	var vovels: Array
	if NAME_DATA.has(race):
		dict = NAME_DATA[race]
	else:
		dict = NAME_DATA.values().pick_random().duplicate(true)
		for k in dict.keys():
			var d: Dictionary = NAME_DATA.values().pick_random()
			if d.has(k):
				dict[k] += d[k]
	if gender<=0:
		phrases += dict.phrases_male
		endings += dict.endings_male
	if gender>=0:
		phrases += dict.phrases_female
		endings += dict.endings_female
	if dict.has("vovels"):
		vovels = dict.vovels
	else:
		vovels = VOVELS
	
	_name = create_from_phrases(randi_range(dict.phrases[0], dict.phrases[1]), phrases, endings, vovels, CONS)
	
	return _name

func get_disease_name() -> String:
	return (DISEASE_PREFIX.pick_random() + " " + DISEASE_NAME.pick_random()).capitalize()

func get_empire_name(race: String) -> String:
	var rnd:= randf()
	if rnd<0.075:
		if RACE_ADJECTIVE.has(race):
			return (RACE_ADJECTIVE[race] + " " + EMPIRE_GENERIC_NAME.pick_random()).capitalize()
		else:
			return (race + " " + EMPIRE_GENERIC_NAME.pick_random()).capitalize()
	elif rnd<0.15:
		return EMPIRE_GENERIC_NAME.pick_random().capitalize() + " " + tr("OF") + " " + race.capitalize() + "s"
	elif rnd<0.35:
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
	elif rnd<0.55:
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


#func _ready():
#	for i in range(20):
#		printt(create_name("naga", 1))
#		printt(get_empire_name("gnoll"))
