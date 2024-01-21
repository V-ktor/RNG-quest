extends Node

const INITIAL_STATES = [
	"adventurer_guild_commission","fetch_rumours","spy_hostile_camp",
]
const QUEST_PERSONS = [
	{
		"position":["peasant","farmer"],
		"personality":["peasant"],
		"tags":["worker"],
		"home":true,
	},
	{
		"position":["preacher"],
		"personality":["pious"],
		"tags":["pious"],
	},
	{
		"position":["hunter","marksman","archer"],
		"personality":["cold"],
		"tags":["hunter"],
	},
	{
		"position":["thief","rogue"],
		"personality":["rogue"],
		"tags":["criminal"],
	},
	{
		"position":["soldier","guard"],
		"personality":["harsh"],
		"tags":["soldier","military"],
	},
	{
		"position":["scout","spy"],
		"personality":["harsh"],
		"tags":["military"],
	},
	{
		"position":["citizen"],
		"personality":["friendly"],
		"home":true,
	},
	{
		"position":["miner","wood cutter"],
		"personality":["cold","harsh"],
		"tags":["worker"],
		"home":true,
	},
	{
		"position":["worker"],
		"personality":["peasant"],
		"tags":["worker"],
		"home":true,
	},
	{
		"position":["smith"],
		"personality":["friendly"],
		"tags":["worker"],
		"home":true,
	},
	{
		"position":["advisor","supervisor"],
		"personality":["curious"],
		"tags":["quest_giver"],
	},
	{
		"position":["mage","wizard"],
		"personality":["arcane"],
		"tags":["mage"],
		"home":true,
	},
	{
		"position":["sage","wizard"],
		"personality":["arcane"],
		"tags":["mage","quest_giver"],
		"home":true,
	},
	{
		"position":["fighter","mercenary"],
		"personality":["harsh"],
		"tags":["soldier"],
		"home":true,
	},
	{
		"position":["philosopher"],
		"personality":["philosopher"],
		"home":true,
	},
	{
		"position":["researcher","scientist"],
		"personality":["curious"],
		"tags":["researcher"],
		"home":true,
	},
	{
		"position":["adventurer","wanderer"],
		"personality":["friendly"],
		"tags":["adventurer"],
	},
	{
		"position":["oracle"],
		"personality":["oracle"],
		"tags":["oracle","story"],
		"home":true,
	},
	{
		"position":["saint"],
		"personality":["pious"],
		"tags":["pious","story"],
		"home":true,
	},
	{
		"position":["mayor"],
		"personality":["polite"],
		"tags":["quest_giver"],
		"home":true,
	},
	{
		"position":["count","earl"],
		"personality":["royal"],
		"tags":["royal","quest_giver"],
		"home":true,
		"title":true,
	},
	{
		"position":["king"],
		"personality":["royal"],
		"tags":["royal","story"],
		"home":true,
		"title":true,
		"gender":-1,
	},
	{
		"position":["queen"],
		"personality":["royal"],
		"tags":["royal","story"],
		"home":true,
		"title":true,
		"gender":1,
	},
	{
		"position":["prince"],
		"personality":["arrogant"],
		"tags":["royal","quest_giver"],
		"home":true,
		"title":true,
		"gender":-1,
	},
	{
		"position":["princes"],
		"personality":["arrogant"],
		"tags":["royal","quest_giver"],
		"home":true,
		"title":true,
		"gender":1,
	},
	{
		"position":["hero"],
		"personality":["friendly"],
		"tags":["hero","story"],
	},
	{
		"position":["maiden"],
		"personality":["shy"],
		"tags":["hero","story"],
		"home":true,
		"gender":1,
	},
	{
		"position":["archmage"],
		"personality":["arcane"],
		"tags":["mage","story"],
		"home":true,
		"title":true,
	},
	{
		"position":["high priest"],
		"personality":["pious"],
		"tags":["pious","quest_giver"],
		"home":true,
		"title":true,
		"gender":-1,
	},
	{
		"position":["high priestess"],
		"personality":["pious"],
		"tags":["pious","quest_giver"],
		"home":true,
		"title":true,
		"gender":1,
	},
	{
		"position":["guild master"],
		"personality":["curious"],
		"tags":["quest_giver"],
		"home":true,
		"title":true,
	},
	{
		"position":["guard captain","sergeant","spy master"],
		"personality":["harsh"],
		"tags":["quest_giver","military"],
		"home":true,
		"title":true,
	},
]
var states:= {
	"adventurer_guild_commission":{
		"title":"Talk to [color=blue][hint={person_description}]{person-quest_giver}[/hint][/color] in [color=green]{city}[/color].",
		"task":{
			"type":"talk",
		},
		"requires":[
			"person-quest_giver","city",
		],
		"story":[
			{
				"type":"commission",
				"requires":["city"],
			},
		],
		"log":"You were commissioned by [color=blue][hint={person_description}]{person-quest_giver}[/hint][/color].",
		"transitions":{
			"deliver_letter":{
				"story":[
					{
						"type":"letter",
						"requires":["item-letter"],
					},
				],
			},
			"treasure_hunt":{},
			"monster_hunt":{},
			"explore":{},
		},
	},
	"research_commission":{
		"title":"Talk to [color=blue][hint={person_description}]{person-researcher}[/hint][/color] in [color=green]{city}[/color].",
		"task":{
			"type":"talk",
		},
		"requires":[
			"person-researcher",
		],
		"story":[
			{
				"type":"commission",
				"requires":["city"],
			},
		],
		"log":"You were commissioned by [color=blue][hint={person_description}]{person-researcher}[/hint][/color].",
		"transitions":{
			"deliver_letter":{
				"story":[
					{
						"type":"letter",
						"requires":["item-letter"],
					},
				],
			},
			"explore":{},
			"fetch_item":{},
		},
	},
	"fetch_rumours":{
		"title":"Fetch some rumours in [color=green]{city}[/color].",
		"task":{
			"type":"fetch_rumours",
			"amount":[2,8],
		},
		"requires":[
			"city",
		],
		"transitions":{
			"treasure_hunt":{},
			"monster_hunt":{},
			"fetch_item":{},
		},
	},
	"commission_done":{
		"title":"Talk to [color=blue][hint={person_description}]{person-quest_giver}[/hint][/color] in [color=green]{city}[/color].",
		"task":{
			"type":"talk",
		},
		"requires":[
			"city","person-quest_giver",
		],
		"consumes":{
			"type":"commission",
		},
		"reward":{
			"exp":20,
			"gold":20,
			"potion_chance":0.2,
			"equipment_chance":0.1,
		},
		"log":"You have completed [color=blue][hint={person_description}]{person-quest_giver}'s[/hint][/color] commission.",
	},
	"deliver_letter":{
		"title":"Deliver a letter to [color=blue][hint={person_description}]{person}[/hint][/color] in [color=green]{city}[/color].",
		"task":{
			"type":"deliver",
		},
		"requires":[
			"city","person-quest_giver","person-story","item-letter",
		],
		"consumes":{
			"type":"letter",
		},
		"reward":{
			"exp":10,
		},
		"log":"You have delivered a letter to [color=blue][hint={person_description}]{person-story}[/hint][/color].",
		"transitions":{
			"commission_done":{},
		},
	},
	"treasure_hunt":{
		"title":"Look for clues about the treasure in [color=green]{location}[/color].",
		"task":{
			"type":"look_for_clues",
			"amount":[2,8],
		},
		"story":[
			{
				"type":"treasure",
				"requires":["location"],
			},
		],
		"log":"You heard of a trasure hidden somewhere in this region.",
		"transitions":{
			"search":{},
		},
	},
	"search":{
		"title":"Search the [color=green]{location}[/color].",
		"task":{
			"type":"search",
			"amount":[2,8],
		},
		"requires":[
			"location",
		],
		"transitions":{
			"dig_up_chest":{
				"requires":["treasure"],
			},
			"track_down_monster":{
				"requires":["monster"],
			},
			"track_down_criminal":{
				"requires":["criminal"],
			},
			"take_out_hostile_camp":{
				"requires":["hostile_camp"],
			},
		},
	},
	"dig_up_chest":{
		"title":"Dig up the chest.",
		"task":{
			"type":"dig",
		},
		"log":"You found the treasure chest.",
		"transitions":{
			"open_chest":{
				"requires":["treasure"],
			},
		},
	},
	"open_chest":{
		"title":"Open the chest.",
		"task":{
			"type":"loot",
		},
		"requires":[
			"loot",
		],
		"consumes":{
			"type":"treasure",
		},
		"reward":{
			"exp":10,
			"gold":100,
		},
		"transitions":{
			"commission_done":{
				"requires":["commission"],
			},
		},
	},
	"monster_hunt":{
		"title":"Look for clues about the monster.",
		"task":{
			"type":"look_for_clues",
			"amount":[2,8],
		},
		"story":[
			{
				"type":"monster",
				"requires":["location","enemy-beast"],
			},
		],
		"log":"You heard of a dangerous monster that roams nearby.",
		"transitions":{
			"search":{
				
			},
		},
	},
	"track_down_monster":{
		"title":"Track down the monster.",
		"task":{
			"type":"look_for_clues",
			"amount":[2,8],
		},
		"log":"You found traces of a monster.",
		"transitions":{
			"fight_monster":{},
		},
	},
	"fight_monster":{
		"title":"Kill the [color=red]{enemy-beast}[/color].",
		"task":{
			"type":"kill",
			"amount":1,
		},
		"requires":[
			"enemy-beast",
		],
		"consumes":{
			"type":"monster",
		},
		"reward":{
			"exp":10,
		},
		"transitions":{
			"commission_done":{
				"requires":["commission"],
			},
		},
	},
	"catch_criminal":{
		"title":"Look for clues about the criminal in [color=green]{city}[/color].",
		"task":{
			"type":"look_for_clues",
			"amount":[2,8],
		},
		"requires":[
			"city",
		],
		"story":[
			{
				"type":"criminal",
				"requires":["location","enemy-criminal"],
			},
		],
		"log":"You were tasked to catch a criminal in [color=green]{city}[/color].",
		"transitions":{
			"search":{},
		},
	},
	"track_down_criminal":{
		"title":"Track down the criminal.",
		"task":{
			"type":"look_for_clues",
			"amount":[2,8],
		},
		"log":"You the criminal.",
		"transitions":{
			"fight_criminal":{},
		},
	},
	"fight_criminal":{
		"title":"Defeat the [color=red]{enemy-criminal}[/color].",
		"task":{
			"type":"kill",
			"amount":1,
		},
		"requires":[
			"enemy-criminal",
		],
		"consumes":{
			"type":"criminal",
		},
		"reward":{
			"exp":10,
		},
		"transitions":{
			"commission_done":{
				"requires":["commission"],
			},
		},
	},
	"explore":{
		"title":"Explore the [color=green]{location}[/color].",
		"task":{
			"type":"explore",
			"amount":[4,10],
		},
		"requires":[
			"location-dungeon",
		],
		"reward":{
			"exp":20,
		},
		"transitions":{
			"map_location":{},
			"search":{
				"story":[
					{
						"type":"treasure",
						"requires":["location"],
					},
					{
						"type":"monster",
						"requires":["location","enemy-beast"],
					},
				],
			},
			
		},
	},
	"map_location":{
		"title":"Map out the [color=green]{location}[/color].",
		"task":{
			"type":"map_location",
		},
		"requires":[
			"location",
		],
		"story":[
			{
				"type":"map",
				"requires":["item-map"],
			},
		],
		"transitions":{
			"commission_done":{
				"requires":["commission"],
				"consumes":{
					"type":"map",
				},
			},
		},
	},
	"fetch_item":{
		"title":"Fetch a [color=cyan][hint={item_description}]{item-package}[/hint][/color] in [color=green]{city}[/color].",
		"task":{
			"type":"fetch",
		},
		"story":[
			{
				"type":"delivery_item",
				"requires":["person","item-package"],
			},
		],
		"requires":[
			"city",
		],
		"transitions":{
			"deliver_package":{},
		},
	},
	"deliver_package":{
		"title":"Deliver [color=cyan][hint={item_description}]{item-package}[/hint][/color] to [color=blue][hint={person_description}]{person}[/hint][/color] in [color=green]{city}[/color].",
		"task":{
			"type":"deliver",
		},
		"requires":[
			"city","person","item-package",
		],
		"consumes":{
			"type":"delivery_item",
		},
		"reward":{
			"exp":15,
			"gold":10,
			"potion_chance":0.3,
		},
		"log":"You have delivered a [color=cyan][hint={item_description}]{item-package}[/hint][/color] to [color=blue][hint={person_description}]{person}[/hint][/color].",
	},
	"spy_hostile_camp":{
		"title":"[color=blue][hint={person_description}]{person}[/hint][/color] has tasked you to spy the [color=orange]{faction}[/color] camp in [color=green]{location}[/color].",
		"task":{
			"type":"search",
		},
		"requires":[
			"person-military","city","location",
		],
		"story":[
			{
				"type":"hostile_camp",
				"requires":["location","faction-hostile"],
			},
		],
		"transitions":{
			"observe_hostile_camp":{},
			"infiltrate_hostile_camp":{},
			"take_out_hostile_camp":{},
		},
	},
	"observe_hostile_camp":{
		"title":"Keep observing the [color=orange]{faction}[/color] camp.",
		"task":{
			"type":"look_for_clues",
		},
		"requires":[
			"hostile_camp",
		],
		"transitions":{
			"report_back":{},
		},
	},
	"infiltrate_hostile_camp":{
		"title":"Infiltrate the [color=orange]{faction}[/color] camp.",
		"task":{
			"type":"explore",
		},
		"consumes":{
			"type":"hostile_camp",
		},
		"transitions":{
			"report_back":{},
		},
	},
	"take_out_hostile_camp":{
		"title":"Defeat the [color=red]{enemy-faction}[/color].",
		"task":{
			"type":"kill",
			"amount":6,
		},
		"requires":[
			"enemy-faction",
		],
		"consumes":{
			"type":"hostile_camp",
		},
		"reward":{
			"exp":40,
		},
		"transitions":{
			"report_back":{},
		},
	},
	"report_back":{
		"title":"Report to [color=blue][hint={person_description}]{person-military}[/hint][/color] in [color=green]{city}[/color].",
		"task":{
			"type":"talk",
		},
		"requires":[
			"city","person-military",
		],
		"reward":{
			"exp":20,
			"gold":20,
			"potion_chance":0.2,
			"equipment_chance":0.1,
		},
		"log":"You have completed [color=blue][hint={person_description}]{person-military}'s[/hint][/color] request.",
	},
	
}
const TITLE = [
	[
		"{prefix} Awakening","A {person}'s Awakening","{prefix} Revelation","{prefix} Prophecy",
		"A {person}'s Prophecy","Prophecy of {theme}","{prefix} Adventure","The {person}'s Rise",
		"Rise of {theme}","The {person}'s Tale","A Tale of {theme}","Beginning of {theme}",
		"A {prefix} Beginning","A {prefix} Adventure","{prefix} Prologue","{prefix} Start",
		"The {person}'s Story","The Story of {theme}","{prefix} Rebirth","A {person}'s Rebirth",
		"Bound to {element}","A Glimpse of {theme}","{prefix} Revolution","Meet the {person}",
		"Of {element} and {theme}","{theme} of {element}","Rise of {element}","Bound by {elements}",
		"Embraced by {elements}","The Road to {theme}","{prefix} {person} Rising",
	],
	[
		"{prefix} Matters","A Matter of {theme}","{prefix} Affairs","Affairs of {theme}",
		"{prefix} Questions","A Question of {theme}","{prefix} Battle","The {prefix} Chase",
		"{prefix} Pursuit","{prefix} Chivalry","{prefix} Honour","A {person}'s Honour",
		"The {prefix} Quest","A {person}'s Quest","A Song of {elements}","A Song of {theme}",
		"{prefix} Investigation","The Investigation of {theme}","{prefix} Engagement",
		"{prefix} Travels","A {person}'s Travels","{prefix} Journey","{prefix} Frontiers",
		"The Frontier of {theme}","Into {elements}","Descend into {elements}","Into {theme}",
		"Melodies of {elements}","The Melody of {theme}","A {person}'s Legacy","{prefix} Legacy",
		"Legacy of {theme}","The {person} Bathing in {elements}","The {person} of {theme}",
		"On the Border to {theme}","{prefix} Evolution","Evolution of {theme}","Die for {theme}",
		"{theme} of {elements}","{element}{person}","Attitude of {theme}","Epiphany of {theme}",
	],
	[
		"The {person}'s Fall","{prefix} Aftermath","{prefix} Crisis","{prefix} Dawn",
		"{prefix} Fate","Fate of the {person}","{prefix} Destiny","{prefix} End","End of {theme}",
		"The {person}'s End","{prefix} Epilogue","{prefix} Findings","{prefix} Conclusion",
		"{prefix} Answers","The {person}'s Answer","{prefix} Whispers","Whispers of {theme}",
		"A {person}'s Consequences","The {person}'s Death","{theme}'s Consequences",
		"The Answer to {theme}","Remarks of {theme}","Remarks of a {person}","Eternal {theme}",
		"The Next Chapter of {theme}","Help! I turned into a {person}!","Divided by {elements}",
		"Death of the {element}{person}","The Cleansing {elements}","No More {theme}",
		"Sealed with {elements}",
	],
]
const TITLE_PREFIX = [
	"Mysterious","Mythical","Ancient","Ominous","Dubious","Critical","Well Timed","Late","Early",
	"Spontaneous","Unexpected","Forgotten","Relevant","Urgent","Pressing","Night Time",
	"Spooky","Serious","Light","Heavy","Blighted","Holy","Sacred","Divine","Abysmal","Overwhelming",
	"Underrated","Overrated","Invisible","Overarching","Bad","Badass","Unbelievable","Unknown",
	"Lost","Undiscovered","Fateful","Draconic","Feral","Barbaric","New","Old","Renewed","Emotional",
	"Relentless","Restless","Stressful","Random","Determined","Lucky","Alarming","Heartless",
	"{element}bound","{element}born","Unholy","Peaceful","Timid","Heroic","Astral","Forged","Deep",
	"Rural","Industrial","Neo","Grand","Undefined","Faithful","Rising","Falling","Determined",
]
const THEME = [
	"Conflict","War","Destruction","Redemption","Forgiveness","Obliteration","Sky","Aether",
	"Oblivion","Dawn","Midnight","the End","a New Beginning","Abyss","Underworld","Heaven",
	"Ocean","Deep Sea","the Woods","Mountaintop","Desert","Torment","Pain","Doom","Termination",
	"Home","Uncertainty","Eternity","Maelstrom","Despair","Depression","Insanity","Stasis",
	"Entropy","Chaos","Order","Realm","Hellfire","Coverdice","Turning Back","Determination",
	"Devastation","Randomness",
]
const ELEMENT = [
	"fire","heat","lava","magma","ash","ice","snow","frost","earth","stone","mud","wind","air",
	"water","storm","thunder","light","shadow","darkness","aether","void","star","space","time",
	"soul","entropy","energy","spirit","mind","heart","steam","heaven","hell","death","life",
	"miasma","radiation","blade",
]
const ELEMENTS = [
	"fire","heat","lava","magma","ash","ice","snow","frost","earth","stones","mud","wind","air",
	"water","storms","thunder","light","shadows","darkness","aether","void","stars","space","time",
	"souls","entropy","energy","spirits","minds","hearts","steam","heaven","hell","death","life",
	"miasma","radiation","blades",
]
const PERSON = [
	"sage","wizard","mage","enchantress","oracle","scientist","researcher","philosopher","seraph",
	"man","women","boy","girl","citizen","human","halfling","elf","dwarf","fairy","hero","demon",
	"soldier","fighter","knight","mercenary","marksman","spellblade","archer","fencer","villain",
	"thief","criminal","hunter","trapper","scout","guard","protector","fool","saint","priest",
	"peasant","farmer","miner","wood cutter","worker","smith","settler","refugee","pirate","devil",
	"mayor","count","earl","king","queen","prince","princes","lancer","adventurer","wanderer",
	"adviser","assistant","guild master","hero","friend","fiend","maiden",
]
const POSITIVE_PERSON = [
	"wise","elder","old","arch","shy","empathic","enigmatic","mysterious","lonely",
	"brave","fearless","naive","good","allied","nice","sweet","tolerant","naive","secretive",
	"faithful","loyal","helpful","useful","resourceful","determined","important",
	"royal",
]
const NEGATIVE_PERSON = [
	"petty","dubious","vile","mean","dark","brutal","reckless","cynical","toxic","cruel","corrupt",
	"evil","diabolic","infernal","murderous","pathetic","unsympathetic","half-breed","hidden",
	"the enemy's","hostile","fishy","bad","menacing","useless","bloody","fiendish","antagonist",
]
const DUNGEON_NAME = [
	"dungeon","keep","cave","cavern","ruin","temple","rift","domain","island","castle","tower",
]
const DUNGEON_PREFIX = [
	"eerie","creepy","dark","enigmatic","dusty","ancient","forgotten","forbidden","locked","ruined",
	"demolished","pristine","dangerous","abandoned","heretic","ash","isolated","uncharted","smelly",
	"overrun","infested","slimy","forsaken","unknown","unnamed","invisible","untouched",
]
const DUNGEON_SUFFIX = [
	"of danger","of harm","of archfiend",
]
const LETTER_TYPES = [
	"letter","scroll",
]
const LETTER_ADJECTIVE = [
	"sealed","signed","long","short","plain","ornate",
]
const PACKAGE_TYPES = [
	"package","box",
]
const PACKAGE_ADJECTIVE = [
	"heavy","large","small","ordinary","common",
]
var story:= []
var locations:= []
var cities:= []
var guilds:= []
var persons:= {}
var inventory:= []
var factions:= []
var hostile_factions:= []
var current_state: Dictionary


func get_a_an(word: String) -> String:
	if word[0].to_lower() in Names.VOVELS:
		return "an "
	else:
		return "a "

func format_string(string: String) -> String:
	var pos:= 0
	while pos>=0:
		pos = string.find('{', pos)
		if pos>=0:
			var pos_end:= string.find("}", pos)
			var key:= string.substr(pos + 1, pos_end - pos - 1)
			match key:
				"element":
					string = string.left(pos) + ELEMENT.pick_random().capitalize() + string.substr(pos_end + 1)
				"elements":
					string = string.left(pos) + ELEMENTS.pick_random().capitalize() + string.substr(pos_end + 1)
				"prefix":
					string = string.left(pos) + format_string(TITLE_PREFIX.pick_random()) + string.substr(pos_end + 1)
				"person":
					if string[max(pos-1, 0)]==' ':
						string = string.left(pos) + PERSON.pick_random().capitalize() + string.substr(pos_end + 1)
					else:
						string = string.left(pos) + PERSON.pick_random() + string.substr(pos_end + 1)
				"theme":
					string = string.left(pos) + THEME.pick_random() + string.substr(pos_end + 1)
		
	return string

func sanitize_string(string: String) -> String:
	var pos:= 0
	if string[0]=='A' && string[1]==' ':
		var pos2:= string.find(' ', 2)
		if string[pos2-1]=="s":
			string = "The" + string.substr(1)
		elif string[2].to_lower() in Names.VOVELS:
			string = "An" + string.substr(1)
	while pos>=0 && pos<string.length():
		var pos2: int
		pos = string.find(" a ", pos)
		if pos==-1:
			break
		pos2 = string.find(' ', pos+3)
		if string[pos2-1]=='s':
			string = string.left(pos) + " the " + string.substr(pos+3)
		elif string[pos+3].to_lower() in Names.VOVELS:
			string = string.left(pos) + " an " + string.substr(pos+3)
		elif string[pos+3]=='[':
			var p:= string.find(']', pos+3)
			if string[p+1].to_lower() in Names.VOVELS:
				string = string.left(pos) + " an " + string.substr(pos+3)
		pos += 3
	pos = 0
	while pos>=0 && pos<string.length():
		pos = string.find("{is/are}", pos)
		if pos>1:
			if string[pos-2]=='s':
				string = string.left(pos) + "are" + string.substr(pos+8)
			else:
				string = string.left(pos) + "is" + string.substr(pos+8)
	pos = 0
	while pos>=0 && pos<string.length():
		pos = string.find("{s}", pos)
		if pos>0:
			var p:= string.rfind(' ', pos)
			if p>0 && string[p-1]!='s':
				string = string.left(pos) + "s" + string.substr(pos+3)
			else:
				string = string.left(pos) + string.substr(pos+3)
	return string


func get_title(chapter: int) -> String:
	var title: String = sanitize_string(format_string(TITLE[chapter%TITLE.size()].pick_random()))
	title[0] = title[0].to_upper()
	return title

func get_person_description(npc: Dictionary) -> String:
	return npc.description + "\n" + tr("LOCATION") + ": " + npc.location

func get_dungeon_name() -> String:
	var _name: String = DUNGEON_NAME.pick_random()
	var prefix: String = DUNGEON_PREFIX.pick_random()
	while _name.similarity(prefix)>0.5:
		prefix = DUNGEON_PREFIX.pick_random()
	_name = sanitize_string((prefix + " " + _name).capitalize())
	return _name


func create_person(race: String, location: String) -> Dictionary:
	var dict: Dictionary = QUEST_PERSONS.pick_random().duplicate()
	var gender: int
	var key: String
	var index:= 0
	if dict.has("gender"):
		gender = dict.gender
	else:
		if randf()<0.1:
			gender = 0
		else:
			gender = 2*(randi()%2) - 1
		dict.gender = gender
	dict.race = race
	dict.location = location
	dict.name = Names.create_name(race, gender)
	dict.position = dict.position.pick_random()
	for k in dict.keys():
		if typeof(dict[k])==TYPE_ARRAY:
			dict[k] = dict[k].pick_random()
	if dict.has("title") && dict.title:
		dict.display_name = dict.position.capitalize() + " " + dict.name#.split(' ')[1]
	else:
		dict.display_name = dict.name
	dict.description = dict.name + "\n" + race + " " + dict.position
	if dict.has("home") && dict.home:
		dict.description += "\n" + tr("LIVING_IN").format({"location":location})
	if !dict.has("tags"):
		dict.tags = []
	dict.key = dict.name.to_lower().replace(' ', '_')
	key = dict.key
	while persons.has(key):
		index += 1
		key = dict.key + str(index)
	dict.key = key
	persons[key] = dict
	return dict

func create_item(type: String, dict: Dictionary) -> Dictionary:
	var item:= {
		"name":tr(type.to_upper()),
		"type":type,
		"amount":1,
	}
	
	match type:
		"letter", "package":
			var description:= "A {adjective} {type}"
			var format_dict:= {}
			for k in ["person-quest_giver","person-story","person"]:
				if dict.has(k):
					item.name = persons[dict[k]].name + "'s " + item.name
					if type=="letter":
						description += " " + tr("WRITTEN_BY").format({"name":persons[dict[k]].name})
					elif type=="package":
						description += " " + tr("OBTAINED_FROM").format({"name":persons[dict[k]].name})
					break
			if type=="letter":
				format_dict.type = LETTER_TYPES.pick_random()
				format_dict.adjective = LETTER_ADJECTIVE.pick_random()
			elif type=="package":
				format_dict.type = PACKAGE_TYPES.pick_random()
				format_dict.adjective = PACKAGE_ADJECTIVE.pick_random()
			description = sanitize_string(description.format(format_dict) + ".")
			item.description = description
	
	if !item.has("description"):
		item.description = get_a_an(item.name).capitalize() + " " + item.name + "."
	
	return item

func add_quest_item(item: Dictionary, amount:= 1):
	var index:= inventory.find(item)
	if index>=0:
		inventory[index].amount += amount
	else:
		inventory.push_back(item)

func remove_quest_item(item: Dictionary, amount:= 0) -> bool:
	var index:= inventory.find(item)
	if index<0:
		for i in range(inventory.size()):
			if inventory[i].type==item.type:
				index = i
				break
	if index>=0:
		if inventory[index].amount<amount:
			inventory.erase(item)
			return false
		elif amount==0 || inventory[index].amount==amount:
			inventory.erase(item)
			return true
		else:
			inventory[index].amount -= amount
			return true
	return false



func has_required(type: String) -> bool:
	for dict in story:
		if dict.type==type:
			return true
	return false

func get_required(type: String):
	for dict in story:
		if dict.type==type:
			return dict

func has_all_required(array: Array) -> bool:
	for type in array:
		if !has_required(type):
			return false
	return true

func create_required(type: String, dict: Dictionary):
	var array:= type.split('-', false)
	match array[0]:
		"location":
			if array.size()>1:
				match array[1]:
					"dungeon":
						return get_dungeon_name()
			return locations.pick_random()
		"city":
			return cities.pick_random()
		"person":
			if array.size()>0:
				var valid:= []
				for p in persons.keys():
					for i in range(1,array.size()):
						if array[i] in persons[p].tags:
							valid.push_back(p)
				if valid.size()>0:
					return valid.pick_random()
			if persons.size()<20:
				create_person(Names.NAME_DATA.keys().pick_random(), cities.pick_random())
			return persons.keys().pick_random()
		"loot":
			var loot:= []
			for i in range(randi_range(1,3)):
				loot.push_back(Items.EQUIPMENT_RECIPES.keys().pick_random())
			return loot
		"item":
			if array.size()>1:
				for item in inventory:
					if item.type==array[1]:
						return item
				return create_item(array[1], dict)
			return create_item("item", dict)
		"enemy":
			if array.size()>1:
				match array[1]:
					"beast":
						return ["boar","wolf","strong_wolf","elemental_wolf","crab","scorpion","drake","yeti"].pick_random()
					"criminal":
						return "thug"
					"fighter":
						return "fighter"
					"guard":
						return "guard"
					"necromancer":
						return ["zombie","ghoul","skeletton","mummy","vampire"].pick_random()
					"faction":
						return hostile_factions.pick_random()
			return Enemies.BASE_ENEMIES.keys().pick_random()
		"faction":
			if array.size()>1:
				match array[1]:
					"hostile":
						return hostile_factions.pick_random()
					_:
						return factions.pick_random()
			return factions.pick_random()
		

func create_story(story_dict: Dictionary) -> Dictionary:
	var dict:= {}
	dict.type = story_dict.type
	if story_dict.has("requires"):
		dict.requires = {}
		for k in story_dict.requires:
			var data = get_required(k)
			var array: Array = k.split('-', false)
			if data==null:
				data = create_required(k, dict)
			dict.requires[k] = data
			if array[0]!=k:
				if dict.requires.has(array[0]):
					if typeof(dict.requires[array[0]])==TYPE_ARRAY:
						dict.requires[array[0]].push_back(data)
					else:
						dict.requires[array[0]] = [dict.requires[array[0]], data]
				else:
					dict.requires[array[0]] = data
	story.push_back(dict)
	return dict

func transition_to(new: String, transition_dict:= {}):
	var format_dict:= {}
	
	current_state = states[new].duplicate()
	if current_state.has("requires"):
		var dict:= {}
		for t in current_state.requires:
			var array: Array = t.split('-', false)
			dict[t] = get_required(t)
			if dict[t]==null:
				dict[t] = create_required(t, dict)
			if array[0]!=t:
				if dict.has(array[0]):
					if typeof(dict[array[0]])==TYPE_ARRAY:
						dict[array[0]].push_back(dict[t])
					else:
						dict[array[0]] = [dict[array[0]], dict[t]]
				else:
					dict[array[0]] = dict[t]
			if "enemy" in t:
				current_state.enemy = dict[t]
			if typeof(dict[t])==TYPE_DICTIONARY && dict[t].has("requires"):
				for k in dict[t].requires:
					dict[k] = dict[t].requires[k]
		current_state.requires = dict
	else:
		current_state.requires = {}
	if current_state.has("story"):
		var dict:= {}
		current_state.story = current_state.story.pick_random()
		dict = create_story(current_state.story)
		if dict.has("requires"):
			for k in dict.requires.keys():
				current_state.requires[k] = dict.requires[k]
	if current_state.has("consumes"):
		for dict in story:
			if current_state.consumes.has("type") && current_state.consumes.type==dict.type:
				if dict.has("requires"):
					if dict.requires.has("beast"):
						format_dict[current_state.consumes.type] = dict.requires.beast
					elif dict.requires.has("item"):
						format_dict[current_state.consumes.type] = dict.requires.item
					for k in dict.requires.keys():
						current_state.requires[k] = dict.requires[k]
				story.erase(dict)
				break
	if transition_dict.has("consumes"):
		for dict in story:
			if transition_dict.consumes.has("type") && transition_dict.consumes.type==dict.type:
				if dict.has("requires"):
					if dict.requires.has("beast"):
						format_dict[current_state.consumes.type] = dict.requires.beast
					elif dict.requires.has("item"):
						format_dict[current_state.consumes.type] = dict.requires.item
						for i in range(inventory.size()):
							if inventory[i].type==dict.requires.item.type:
								inventory.remove_at(i)
								break
				story.erase(dict)
				break
	if current_state.task.has("amount") && typeof(current_state.task.amount)==TYPE_ARRAY:
		current_state.task.amount = randi_range(current_state.task.amount[0], current_state.task.amount[1])
	
	if current_state.has("log"):
		if current_state.has("requires"):
			for k in current_state.requires:
				format_dict[k] = current_state.requires[k]
	

func next():
	if !current_state.has("transitions"):
		start()
		return
	
	var valid_transitions:= []
	for k in current_state.transitions.keys():
		if !current_state.transitions[k].has("requires") || has_all_required(current_state.transitions[k].requires):
			valid_transitions.push_back(k)
	if valid_transitions.size()>0:
		var new: String = valid_transitions.pick_random()
		if current_state.transitions[new].has("story"):
			create_story(current_state.transitions[new].story.pick_random())
		transition_to(new, current_state.transitions[new])
		return
	
	start()

func start():
	transition_to(INITIAL_STATES.pick_random())

func create_quest(region: Dictionary) -> Dictionary:
	var quest:= {
		"title":current_state.title,
		"requires":current_state.requires,
	}
	var dict: Dictionary
	quest.task = current_state.task.type
	if current_state.task.has("amount"):
		quest.amount = current_state.task.amount
	else:
		quest.amount = 1
	for k in current_state.task.keys():
		quest[k] = current_state.task[k]
	quest.action = current_state.task.type
	quest.stage = 0
	if quest.requires.has("city"):
		quest.city = quest.requires.city
	if quest.requires.has("location"):
		quest.location = quest.requires.location
	if quest.requires.has("person-quest_giver"):
		quest.npc = persons[quest.requires["person-quest_giver"]]
	elif quest.requires.has("person-story"):
		quest.npc = persons[quest.requires["person-story"]]
	elif quest.requires.has("person"):
		if persons.has("quest.requires.person"):
			quest.npc = persons[quest.requires.person]
		else:
			quest.npc = create_person(Names.NAME_DATA.keys().pick_random(), cities.pick_random())
			quest.requires.person = quest.npc.key
	else:
		for k in quest.requires:
			if "person" in k && persons.has(quest.requires[k]):
				quest.npc = persons[quest.requires[k]]
				break
	if quest.has("npc"):
		if quest.has("city"):
			quest.npc.location = quest.city
		elif quest.has("location"):
			quest.npc.location = quest.location
		else:
			quest.npc.location = region.name
	if quest.requires.has("enemy"):
		quest.enemy = quest.requires.enemy
	if quest.has("npc"):
		quest.person = quest.npc.display_name
		quest.person_description = get_person_description(quest.npc)
	if quest.requires.has("item"):
		quest.item = quest.requires.item
	if quest.requires.has("faction-enemy"):
		quest.faction = quest.requires["faction-enemy"]
	elif quest.requires.has("faction"):
		quest.faction = quest.requires.faction
	dict = quest.duplicate(true)
	for k in quest.requires.keys():
		if dict.has(k):
			continue
		dict[k] = quest.requires[k]
		match typeof(dict[k]):
			TYPE_ARRAY:
				dict[k] = dict[k].pick_random()
			TYPE_DICTIONARY:
				if dict[k].has("display_name"):
					dict[k] = dict[k].display_name
				elif dict[k].has("name"):
					dict[k] = dict[k].name
				else:
					dict[k] = str(dict[k])
			TYPE_STRING:
				if "person" in k:
					if persons.has(dict[k]):
						dict[k] = persons[dict[k]].display_name
						if !dict.has("person_description"):
							dict.person_description = persons[dict[k]].description
				elif "enemy" in k:
					dict[k] = Enemies.BASE_ENEMIES[dict[k]].base_name.pick_random().capitalize()
	if dict.has("enemy"):
		dict.enemy = Enemies.BASE_ENEMIES[dict.enemy].base_name.pick_random().capitalize()
	if dict.has("item"):
		dict.item_description = dict.item.description
		dict.item = dict.item.name
	quest.name = sanitize_string(quest.title.format(dict))
	if current_state.has("log"):
		quest.log = sanitize_string(current_state.log.format(dict))
	if quest.has("reward"):
		if quest.reward.has("exp"):
			quest.reward.exp = int(ceil(quest.reward.exp*(1.0 + 0.2*(region.level-1))))
		if quest.reward.has("gold"):
			quest.reward.gold = int(ceil(quest.reward.exp*(1.0 + 0.1*(region.level-1))))
	return quest

func next_quest(region: Dictionary) -> Dictionary:
	next()
	return create_quest(region)

