extends Node

const RESOURCE_COLOR = {
	"health":"#FF2010",
	"stamina":"#CCCC30",
	"focus":"#50FF99",
	"mana":"#4090FF",
}
const DAMAGE_COLOR = {
	"cutting":"#FFBBBB",
	"piercing":"#FFBBDD",
	"impact":"#FFEECC",
	"fire":"#FF5030",
	"ice":"#99DDFF",
	"lightning":"#BB66FF",
	"water":"#4099FF",
	"wind":"#40EEAA",
	"earth":"#EEAA40",
	"poison":"#99EE30",
	"acid":"#A0FAC0",
	"light":"#EEEE30",
	"darkness":"#502580",
}
const DAMAGE_TYPES = [
	"cutting",
	"piercing",
	"impact",
	"fire",
	"ice",
	"lightning",
	"water",
	"wind",
	"earth",
	"poison",
	"acid",
	"light",
	"darkness",
]
const PHYSICAL_DAMAGE_TYPES = [
	"cutting",
	"piercing",
	"impact",
	"poison",
	"acid",
]
const ABILITIES = {
	"light_weapons":{
		"name":"light_weapons",
		"penetration":2,
		"attack":0.5,
		"weapon_subtypes":["melee"],
		"armour_subtypes":["medium"],
	},
	"heavy_weapons":{
		"name":"heavy_weapons",
		"attack":2,
		"weapon_subtypes":["melee"],
	},
	"dirty_fighting":{
		"name":"dirty_fighting",
		"penetration":3,
		"armour_subtypes":["light","medium"],
	},
	"brawling":{
		"name":"brawling",
		"penetration":2,
		"accuracy":0.5,
		"evasion":0.5,
		"weapon_subtypes":["melee"],
		"armour_subtypes":["medium","heavy"],
	},
	"trapping":{
		"name":"trapping",
		"evasion":2,
	},
	"archery":{
		"name":"archery",
		"attack":2,
		"weapon_subtypes":["ranged"],
		"armour_subtypes":["medium"],
	},
	"gun_slinging":{
		"name":"gun_slinging",
		"attack":2,
		"weapon_subtypes":["ranged"],
		"armour_subtypes":["medium"],
	},
	"shield":{
		"name":"shields",
		"armour":2,
		"weapon_subtypes":["shield"],
		"armour_subtypes":["heavy"],
	},
	"armour":{
		"name":"armour",
		"armour":2,
		"weapon_subtypes":["shield"],
		"armour_subtypes":["heavy"],
	},
	"evasion":{
		"name":"evasion",
		"evasion":2,
		"armour_subtypes":["light","mediun"],
	},
	"elemental_magic":{
		"name":"elemental_magic",
		"magic":2,
		"weapon_subtypes":["magic"],
		"armour_subtypes":["light"],
	},
	"nature_magic":{
		"name":"nature_magic",
		"magic":2,
		"weapon_subtypes":["magic"],
		"armour_subtypes":["light"],
	},
	"celestial_magic":{
		"name":"celestial_magic",
		"magic":2,
		"weapon_subtypes":["magic"],
		"armour_subtypes":["light"],
	},
	"summoning":{
		"name":"summoning",
		"willpower":2,
		"weapon_subtypes":["magic"],
		"armour_subtypes":["light"],
	},
	"necromancy":{
		"name":"necromancy",
		"willpower":2,
		"weapon_subtypes":["magic"],
		"armour_subtypes":["light"],
	},
	"defensive_magic":{
		"name":"defensive_magic",
		"willpower":2,
		"weapon_subtypes":["magic"],
	},
	"healing":{
		"name":"healing_ability",
		"willpower":2,
		"weapon_subtypes":["magic"],
	},
	"alchemy":{
		"name":"alchemy",
		"willpower":2,
		"recipes":[
			"healing_salve","healing_potion","bandage","healing_infusion",
			"mana_salve","mana_potion","stamina_salve","stamina_potion",
		],
	},
	"weapon_smithing":{
		"name":"weapon_smithing",
		"attack":2,
		"recipes":[
			"dagger","sword","axe","mace","whip","greatsword","battleaxe","greatmaul",
			"scythe","morningstar","spear",
		],
	},
	"armour_smithing":{
		"name":"armour_smithing",
		"armour":2,
		"recipes":[
			"buckler","kite_shield","tower_shield","chain_belt","chain_cuirass",
			"plate_cuirass","chain_greaves","plate_greaves","chain_coif",
			"plate_helm","chain_boots","plate_boots","chain_gauntlets",
			"plate_gauntlets","chain_belt","metal_amulet","metal_ring",
			"metal_earring","metal_bracelet",
		],
	},
	"woodwork":{
		"name":"woodwork",
		"attack":2,
		"recipes":[
			"spellblade","quarterstaff","magestaff","tome","orb","amplifier",
			"sling","bow","crossbow","pistol","blunderbuss","wood_bracelet",
		],
	},
	"tayloring":{
		"name":"tayloring",
		"armour":2,
		"recipes":[
			"cloth_shirt","leather_chest","cloth_pants","leather_pants","cloth_hat",
			"leather_hat","cloth_sandals","leather_boots","cloth_sleeves","leather_gloves",
			"leather_belt","rope_belt","rope_amulet","leather_ring","gem_earring",
			"magical_cape","cloth_cape","metal_cape","orb_earring",
		],
	},
	"cooking":{
		"name":"cooking",
		"evasion":2,
	},
	"enchanting":{
		"name":"enchanting",
		"magic":2,
	},
	
}
const CRAFTING_ABILITIES = [
	"weapon_smithing","armour_smithing","woodwork","tayloring",
]
const ABILITY_MODULES = {
	"light_weapons":{
		"base_type":["strike","slash","dual_strike","stab"],
		"melee_mod":["pierce","quick","dual","stunning","rush"],
		"aim":["body","head","unaimed"],
	},
	"heavy_weapons":{
		"base_type":["strike","thrust","bash","cleave"],
		"melee_mod":["force","brutal","cleaving","reckless","pierce","charged","concussive"],
		"aim":["body","arms","legs","neck"],
	},
	"dirty_fighting":{
		"base_type":["backstab","throwing_knife"],
		"melee_mod":["shred","poisoned","penetrating"],
		"ranged_mod":["vile","sharp"],
		"aim":["weakpoint","organs","eyes"],
	},
	"brawling":{
		"base_type":["punch","slam","kick","grapple"],
		"melee_mod":["force","brutal","cleaving","quick","charged","stunning","rush"],
		"grapple_mod":["choking","immobilizing","shielding"],
		"aim":["body","arms","legs"],
	},
	"shield":{
		"base_type":["bash"],
		"melee_mod":["force","concussive","shielding"],
		"aim":["body","arms","legs"],
	},
	
	"archery":{
		"base_type":["arrow","shot","dual_shot","volley"],
		"ranged_mod":["aimed","quick","power","heavy_caliber"],
		"aim":["body","head","unaimed"],
	},
	"gun_slinging":{
		"base_type":["shot","cannon","barrage"],
		"ranged_mod":["aimed","trick","bulk_caliber"],
		"aim":["body","head","weakpoint"],
	},
	
	"armour":{
		"base_type":["shielding_stance"],
		"melee_mod":["shielding","brutal"],
		"defence_mod":["defencive","absorbing","reflecting"],
	},
	"evasion":{
		"base_type":["evasive_stance","engaging_stance"],
		"melee_mod":["parry"],
		"defence_mod":["nimble","engaging","reflecting"],
	},
	
	"elemental_magic":{
		"base_type":["combat_spell"],
		"magic":["fire","ice","lightning"],
		"shape":["bolt","ball","pillar","disc","spiral"],
		"application":["rocket","chain","explosion"],
		"magic_mod":["homing","pumped","high_yield","mana_burn","split","fuse"],
		"melee_mod":["infuse","channeled"],
		"ranged_mod":["infuse","channeled"],
		"summon_type":["elemental"],
		"summoning_method":["conjuration"],
	},
	"nature_magic":{
		"base_type":["combat_spell"],
		"magic":["water","wind","earth"],
		"shape":["bolt","ball","disc","blade","spiral"],
		"application":["rocket","beam","explosion"],
		"magic_mod":["homing","pumped","explosive","supersonic","split","fuse"],
		"melee_mod":["infuse","acidic"],
		"ranged_mod":["infuse","acidic"],
		"summon_type":["beast"],
		"summoning_method":["conjuration"],
	},
	"celestial_magic":{
		"base_type":["combat_spell"],
		"magic":["light","darkness"],
		"shape":["bolt","sphere","pillar","disc","blade"],
		"application":["rocket","beam","explosion"],
		"magic_mod":["vampiric","pumped","restorative","swift","split","fuse"],
		"melee_mod":["infuse","light_infused"],
		"ranged_mod":["infuse","light_infused"],
		"summon_type":["celestial"],
		"summoning_method":["conjuration"],
	},
	"defensive_magic":{
		"base_type":["shielding_spell"],
		"magic":["ice"],
		"magic_mod":["magic_shielding"],
		"defence_mod":["physical_shielding","spell_shielding","nature_shielding","celestial_shielding"],
	},
	"healing":{
		"base_type":["healing_spell"],
		"magic":["water"],
		"application":["rocket","beam","explosion"],
		"magic_mod":["restorative"],
	},
	
	"summoning":{
		"base_type":["summoning_spell"],
		"magic":["earth"],
		"summon_type":["beast"],
		"summoning_method":["tame"],
	},
	"necromancy":{
		"base_type":["summoning_spell"],
		"magic":["darkness"],
		"summon_type":["undead"],
		"summoning_method":["revive"],
	},
	
	# enemy skills
	"fangs":{
		"base_type":["fangs"],
		"aim":["body","arms","legs"],
		"melee_mod":["quick","charged","rush"],
	},
	"claws":{
		"base_type":["claws"],
		"aim":["body","arms","legs","unaimed"],
		"melee_mod":["pierce","reckless"],
	},
	"lacerating_fangs":{
		"base_type":["fangs"],
		"aim":["body","weakpoint"],
		"melee_mod":["shred"],
	},
	"toxic_bite":{
		"base_type":["fangs"],
		"aim":["body","weakpoint"],
		"melee_mod":["poisoned"],
	},
	"draining_bite":{
		"base_type":["fangs"],
		"aim":["body"],
		"melee_mod":["vampiric"],
	},
	"feral_fire_magic":{
		"base_type":["combat_spell"],
		"magic":["fire"],
		"shape":["bolt","ball"],
		"application":["rocket","beam","explosion"],
		"magic_mod":[],
	},
	"feral_ice_magic":{
		"base_type":["combat_spell"],
		"magic":["ice"],
		"shape":["bolt","ball"],
		"application":["rocket","beam","explosion"],
		"magic_mod":[],
	},
	"feral_lightning_magic":{
		"base_type":["combat_spell"],
		"magic":["lightning"],
		"shape":["bolt","ball"],
		"application":["rocket","beam","explosion"],
		"magic_mod":[],
	},
	"feral_wind_magic":{
		"base_type":["combat_spell"],
		"magic":["wind"],
		"shape":["bolt","ball"],
		"application":["rocket","beam","explosion"],
		"magic_mod":[],
	},
	"feral_water_magic":{
		"base_type":["combat_spell"],
		"magic":["water"],
		"shape":["bolt","ball"],
		"application":["rocket","beam","explosion"],
		"magic_mod":[],
	},
	"feral_earth_magic":{
		"base_type":["combat_spell"],
		"magic":["earth"],
		"shape":["bolt","ball"],
		"application":["rocket","beam","explosion"],
		"magic_mod":[],
	},
	"feral_acid_magic":{
		"base_type":["combat_spell"],
		"magic":["acid"],
		"shape":["bolt","ball"],
		"application":["rocket","beam","explosion"],
		"magic_mod":[],
	},
	"feral_poison_magic":{
		"base_type":["combat_spell"],
		"magic":["poison"],
		"shape":["bolt","ball"],
		"application":["rocket","beam","explosion"],
		"magic_mod":[],
	},
	"feral_light_magic":{
		"base_type":["combat_spell"],
		"magic":["light"],
		"shape":["bolt","ball"],
		"application":["rocket","beam","explosion"],
		"magic_mod":[],
	},
	"feral_darkness_magic":{
		"base_type":["combat_spell"],
		"magic":["darkness"],
		"shape":["bolt","ball"],
		"application":["rocket","beam","explosion"],
		"magic_mod":[],
	},
	
	"feral_impact_fire_magic":{
		"base_type":["feral_impact"],
		"magic":["fire"],
		"melee_mod":["infuse"],
		"aim":["body","legs"],
	},
	"feral_impact_ice_magic":{
		"base_type":["feral_impact"],
		"magic":["ice"],
		"melee_mod":["infuse"],
		"aim":["body","legs"],
	},
	"feral_impact_lightning_magic":{
		"base_type":["feral_impact"],
		"magic":["lightning"],
		"melee_mod":["infuse"],
		"aim":["body","legs"],
	},
	"feral_impact_wind_magic":{
		"base_type":["feral_impact"],
		"magic":["wind"],
		"melee_mod":["infuse"],
		"aim":["body","legs"],
	},
	"feral_impact_water_magic":{
		"base_type":["feral_impact"],
		"magic":["water"],
		"melee_mod":["infuse"],
		"aim":["body","legs"],
	},
	"feral_impact_earth_magic":{
		"base_type":["feral_impact"],
		"magic":["earth"],
		"melee_mod":["infuse"],
		"aim":["body","legs"],
	},
	"feral_impact_acid_magic":{
		"base_type":["feral_impact"],
		"magic":["acid"],
		"melee_mod":["infuse"],
		"aim":["body","legs"],
	},
	"feral_impact_poison_magic":{
		"base_type":["feral_impact"],
		"magic":["poison"],
		"melee_mod":["infuse"],
		"aim":["body","legs"],
	},
	"feral_impact_light_magic":{
		"base_type":["feral_impact"],
		"magic":["light"],
		"melee_mod":["infuse"],
		"aim":["body","legs"],
	},
	"feral_impact_darkness_magic":{
		"base_type":["feral_impact"],
		"magic":["darkness"],
		"melee_mod":["infuse"],
		"aim":["body","legs"],
	},
	
	"feral_cutting_fire_magic":{
		"base_type":["feral_cutting"],
		"magic":["fire"],
		"melee_mod":["infuse"],
		"aim":["body","arms"],
	},
	"feral_cutting_ice_magic":{
		"base_type":["feral_cutting"],
		"magic":["ice"],
		"melee_mod":["infuse"],
		"aim":["body","arms"],
	},
	"feral_cutting_lightning_magic":{
		"base_type":["feral_cutting"],
		"magic":["lightning"],
		"melee_mod":["infuse"],
		"aim":["body","arms"],
	},
	"feral_cutting_wind_magic":{
		"base_type":["feral_cutting"],
		"magic":["wind"],
		"melee_mod":["infuse"],
		"aim":["body","arms"],
	},
	"feral_cutting_water_magic":{
		"base_type":["feral_cutting"],
		"magic":["water"],
		"melee_mod":["infuse"],
		"aim":["body","arms"],
	},
	"feral_cutting_earth_magic":{
		"base_type":["feral_cutting"],
		"magic":["earth"],
		"melee_mod":["infuse"],
		"aim":["body","arms"],
	},
	"feral_cutting_acid_magic":{
		"base_type":["feral_cutting"],
		"magic":["acid"],
		"melee_mod":["infuse"],
		"aim":["body","arms"],
	},
	"feral_cutting_poison_magic":{
		"base_type":["feral_cutting"],
		"magic":["poison"],
		"melee_mod":["infuse"],
		"aim":["body","arms"],
	},
	"feral_cutting_light_magic":{
		"base_type":["feral_cutting"],
		"magic":["light"],
		"melee_mod":["infuse"],
		"aim":["body","arms"],
	},
	"feral_cutting_darkness_magic":{
		"base_type":["feral_cutting"],
		"magic":["darkness"],
		"melee_mod":["infuse"],
		"aim":["body","arms"],
	},
	
	"high_tech_cutting":{
		"base_type":["chainsaw"],
		"aim":["body","arms","legs"],
		"melee_mod":["fusion","laser","overcharged","grinding","cone","repeated"],
	},
	"high_tech_impact":{
		"base_type":["crusher"],
		"aim":["body","arms","legs"],
		"melee_mod":["fusion","laser","overcharged","grinding","cone","repeated"],
	},
	"high_tech_ranged":{
		"base_type":["boltgun"],
		"aim":["body","head","unaimed"],
		"ranged_mod":["fusion","laser","overcharged","long_range","cone","repeated"],
	},
	
}
const TRAPS = {
	"poison":{
		"ability":"trapping",
		"type":"debuff",
		"name":"poison trap",
		"health_regen":0.2,
		"effect_stat":"wisdom",
		"effect_scale":1.0,
		"duration":30.0,
	},
	"bleeding":{
		"ability":"trapping",
		"type":"debuff",
		"name":"bear trap",
		"health_regen":0.2,
		"effect_stat":"dexterity",
		"effect_scale":1.0,
		"duration":30.0,
	},
	"crippled":{
		"ability":"trapping",
		"type":"debuff",
		"name":"crippling trap",
		"effect":["attack","accuracy","evasion"],
		"effect_stat":"wisdom",
		"effect_scale":0.4,
		"duration":30.0,
	},
	"bear_trap":{
		"ability":"trapping",
		"type":"debuff",
		"name":"bear trap",
		"health_regen":1.0,
		"effect":["accuracy","evasion"],
		"effect_stat":"dexterity",
		"effect_scale":0.6,
		"duration":30.0,
	},
	"corrosion":{
		"ability":"trapping",
		"type":"debuff",
		"name":"corrosive trap",
		"effect":"armour",
		"effect_stat":"wisdom",
		"effect_scale":0.6,
		"duration":30.0,
	},
	"antimagic_trap":{
		"ability":"trapping",
		"type":"debuff",
		"name":"antimagic trap",
		"effect":["magic","willpower"],
		"effect_stat":"wisdom",
		"effect_scale":0.5,
		"duration":30.0,
	},
}
#const FIRE_PREFIX = ["fire","fiery","blazing","flare"]
#const ICE_PREFIX = ["ice","cryo","cold","freezing","frost"]
#const LIGHTNING_PREFIX = ["lightning","electro","thunder","storm"]
#const WATER_PREFIX = ["water","aqua","hydro"]
#const EARTH_PREFIX = ["earth","rock","sand","geo"]
#const WIND_PREFIX = ["wind","air","pressure","vacuum"]
#const LIGHT_PREFIX = ["light","solar","star","bright","day"]
#const DARKNESS_PREFIX = ["dark","nocturnal","darkness","black","night"]
#const POISON_PREFIX = ["poison","toxic"]
#const ACID_PREFIX = ["acid","corrosive"]
#const BOLT_NAMES = ["arrow","bolt","dart","shot","blast"]
#const BEAM_NAMES = ["beam","blast","jet","ray","arc"]
#const EXPLOSION_NAMES = ["explosion","nova","wave","storm","fall","sphere"]
#const SEEKER_NAMES = ["seeker","missile","smart sphere"]
#const MELEE_NAMES = ["slash","strike","cutter","attack","thrust"]
#const FERAL_MAGIC_NAMES = ["blast","blow","wave","strike","attack"]
#const FERAL_IMPACT_MAGIC_NAMES = ["blow","strike","punch","slam","impact"]
#const FERAL_CUTTING_MAGIC_NAMES = ["strike","slash","cut","roundcut","claw","fangs"]

const ROMAN_NUMBERS = {
	"I":1,
	"V":5,
	"X":10,
	"L":50,
	"C":100,
	"D":500,
	"M":1000,
}

var module_data:= {}


func merge_dicts(dict: Dictionary, add: Dictionary) -> Dictionary:
	for k in add.keys():
		if dict.has(k):
			if typeof(dict[k])==TYPE_DICTIONARY:
				if typeof(add[k])==TYPE_ARRAY:
					for s in add[k]:
						if !dict[k].has(s):
							dict[k][s] = null
				else:
					dict[k] = merge_dicts(dict[k], add[k])
			elif typeof(dict[k])!=TYPE_STRING:
				if typeof(add[k])==TYPE_DICTIONARY:
					dict[k] += add[k].value
				else:
					dict[k] += add[k]
		else:
			dict[k] = add[k]
	return dict


func create_status_tooltip(status: Dictionary) -> String:
	var text: String = status.name + "\n" + status.type + "\n"
	if status.has("attributes"):
		for k in status.attributes.keys():
			if typeof(status.attributes[k])==TYPE_DICTIONARY:
				if status.attributes[k].value>=0:
					text += tr(k) + ": +" + str(int(status.attributes[k].value)) + "\n"
				else:
					text += tr(k) + ": -" + str(-int(status.attributes[k].value)) + "\n"
			else:
				if status.attributes[k]>=0:
					text += tr(k) + ": +" + str(int(status.attributes[k])) + "\n"
				else:
					text += tr(k) + ": -" + str(-int(status.attributes[k])) + "\n"
	if status.has("health"):
		if status.health>=0:
			text += tr("HEALTH") + ": +" + str(int(status.health)) + "\n"
		else:
			text += tr("HEALTH") + ": -" + str(-int(status.health)) + "\n"
	if status.has("health_regen"):
		if status.health_regen>=0:
			text += tr("HEALTH_REGEN") + ": " + str(status.health_regen).pad_decimals(2) + "\n"
		else:
			text += tr("HEALTH_DRAIN") + ": " + str(-status.health_regen).pad_decimals(2) + "\n"
	if status.has("shielding"):
		text += tr("SHIELDINGC") + ": "
		for i in range(status.shielding.size()):
			for j in range(status.shielding[i].size()):
				text += str(int(status.shielding[i].value)) + " " + tr(status.shielding[i].type.to_upper())
				if j<status.shielding[i].size()-1:
					text += " / "
			text += "\n"
	text += tr("DURATION") + ": " + str(status.duration).pad_decimals(1) + " / " + str(status.max_duration).pad_decimals(1)
	return text

func _create_tooltip(skill: Dictionary) -> String:
	var text: String = skill.name + " " + convert_to_roman_number(skill.level) + "\n"
	if ABILITIES.has(skill.ability):
		text += tr(ABILITIES[skill.ability].name.to_upper())
	else:
		text += tr(skill.ability.to_upper())
	text += " " + skill.type + " skill\n\n"
	if skill.has("damage_type"):
		var _scale:= 100
		if skill.has("damage_scale"):
			_scale = 100*skill.damage_scale
		for k in ["attack_type","attack_stat"]:
			if !skill.has(k):
				continue
			if typeof(skill[k])==TYPE_ARRAY:
				text += tr(k.to_upper()) + ": " + str(_scale) + "% " + Names.make_list(skill[k]) + "\n"
			else:
				text += tr(k.to_upper()) + ": " + str(_scale) + "% " + skill[k] + "\n"
	if skill.has("damage_stat"):
		var _scale:= 100
		if skill.has("damage_scale"):
			_scale = 100*skill.damage_scale
		if typeof(skill.damage_stat)==TYPE_ARRAY:
			text += tr("DAMAGE_STAT") + ": " + str(_scale) + "% " + Names.make_list(skill.damage_stat) + "\n"
		else:
			text += tr("DAMAGE_STAT") + ": " + str(_scale) + "% " + skill.damage_stat + "\n"
	if skill.has("damage_type"):
		text += tr("DAMAGE_TYPE") + ": " + tr(skill.damage_type.to_upper()) + "\n"
	if skill.has("armour_penetration"):
		text += tr("ARMOUR_PENETRATION") + ": " + str(int(100*Characters.get_resistance(skill.armour_penetration))) + "%\n"
	if skill.has("effect"):
		if typeof(skill.effect)==TYPE_ARRAY:
			if skill.type=="debuff":
				text += tr("DECREASES") + ": " + Names.make_list(skill.effect) + "\n"
			else:
				text += tr("INCREASES") + ": " + Names.make_list(skill.effect) + "\n"
		else:
			if skill.type=="debuff":
				text += tr("DECREASES") + ": " + skill.effect + "\n"
			else:
				text += tr("INCREASES") + ": " + skill.effect + "\n"
	if skill.has("absorb_damage"):
		text += tr("ABSORB_DAMAGE") + ": " + str(int(100*skill.absorb_damage)) + "%\n"
	if skill.has("accuracy"):
		if skill.has("effect_scale"):
			text += tr("INCREASES") + " " + "accuracy: " + "\n" + str(int(100*skill.effect_scale)) + "%\n"
		else:
			text += tr("INCREASES") + " " + "accuracy: 100%\n"
	if skill.has("health_regen"):
		if skill.health_regen>=0 && skill.type!="debuff":
			text += tr("HEALTH_REGEN") + ": " + str(skill.health_regen).pad_decimals(2) + "\n"
		else:
			text += tr("HEALTH_DRAIN") + ": " + str(abs(skill.health_regen)).pad_decimals(2) + "\n"
	for c in ["effect","healing"]:
		var _scale:= 100
		if skill.has(c+"_scale"):
			_scale = 100*skill[c+"_scale"]
		if c=="attack" && skill.has("damage_scale"):
			_scale = 100*skill.damage_scale
		for k in [c+"_type",c+"_stat"]:
			if !skill.has(k):
				continue
			if typeof(skill[k])==TYPE_ARRAY:
				text += tr(k.to_upper()) + ": " + str(_scale) + "% " + Names.make_list(skill[k]) + "\n"
			else:
				text += tr(k.to_upper()) + ": " + str(_scale) + "% " + skill[k] + "\n"
	if skill.has("duration"):
		text += tr("DURATION") + ": " + str(skill.duration).pad_decimals(1) + "\n"
	if skill.has("debuff"):
		var _scale:= 100
		if skill.has("effect_scale"):
			_scale = 100*skill.effect_scale
		text += tr(skill.debuff.type) + ":\n  " + skill.debuff.name + "\n"
		if skill.debuff.has("effect"):
			if typeof(skill.debuff.effect)==TYPE_ARRAY:
				text += "  " + tr("DECREASES") + ": " + Names.make_list(skill.debuff.effect) + "\n"
			else:
				text += "  " + tr("DECREASES") + ": " + skill.debuff.effect + "\n"
		if skill.debuff.has("effect_type"):
			text += "  " + tr("EFFECT_TYPE") + ": " + str(_scale) + "% " + skill.debuff.effect_type + "\n"
		if skill.debuff.has("effect_stat"):
			text += "  " + tr("EFFECT_STAT") + ": " + str(_scale) + "% " + skill.debuff.effect_stat + "\n"
		if skill.debuff.has("health"):
			text += "  " + tr("HEALTH") + ": -" + str(skill.debuff.health) + "\n"
		if skill.debuff.has("health_regen"):
			text += "  " + tr("HEALTH_DRAIN") + ": " + str(skill.debuff.health_regen).pad_decimals(2) + "\n"
		text += "  " + tr("DURATION") + ": " + str(skill.debuff.duration).pad_decimals(1) + "\n"
	if skill.has("status"):
		var _scale:= 100
		if skill.has("effect_scale"):
			_scale = 100*skill.effect_scale
		text += tr(skill.status.type) + ":\n  " + skill.status.name + "\n"
		if skill.status.has("effect"):
			if typeof(skill.status.effect)==TYPE_ARRAY:
				text += "  " + tr("INCREASES") + ": " + Names.make_list(skill.status.effect) + "\n"
			else:
				text += "  " + tr("INCREASES") + ": " + skill.status.effect + "\n"
		if skill.status.has("effect_type"):
			text += "  " + tr("EFFECT_TYPE") + ": " + str(_scale) + "% " + skill.status.effect_type + "\n"
		if skill.status.has("effect_stat"):
			text += "  " + tr("EFFECT_STAT") + ": " + str(_scale) + "% " + skill.status.effect_stat + "\n"
		if skill.status.has("health"):
			text += "  " + tr("HEALTH") + ": +" + str(skill.status.health) + "\n"
		if skill.status.has("health_regen"):
			text += "  " + tr("HEALTH_REGEN") + ": " + str(skill.status.health_regen).pad_decimals(2) + "\n"
		text += "  " + tr("DURATION") + ": " + str(skill.status.duration).pad_decimals(1) + "\n"
	if skill.has("delay"):
		text += tr("DELAY") + ": " + str(skill.delay).pad_decimals(1)
	return text


func convert_to_roman_number(number: int) -> String:
	var string:= ""
	var i:= ROMAN_NUMBERS.size()-1
	while number>0 && i>=0:
		while number>=ROMAN_NUMBERS.values()[i]:
			string += ROMAN_NUMBERS.keys()[i]
			number -= ROMAN_NUMBERS.values()[i]
		match ROMAN_NUMBERS.keys()[i]:
			"V":
				if number>=ROMAN_NUMBERS.values()[i]-1:
					string += "IV"
					number -= 4
			"X":
				if number>=ROMAN_NUMBERS.values()[i]-1:
					string += "IX"
					number -= 9
			"L":
				if number>=ROMAN_NUMBERS.values()[i]-10:
					string += "XL"
					number -= 40
			"C":
				if number>=ROMAN_NUMBERS.values()[i]-10:
					string += "XC"
					number -= 90
			"D":
				if number>=ROMAN_NUMBERS.values()[i]-100:
					string += "CD"
					number -= 400
			"M":
				if number>=ROMAN_NUMBERS.values()[i]-100:
					string += "CM"
					number -= 900
		i -= 1
	return string



# skills #

func get_modules(type: String, abilities: Array, exceptions:= []) -> Array:
	var modules:= []
	for s in abilities:
		if !ABILITY_MODULES.has(s):
			continue
		
		var dict: Dictionary = ABILITY_MODULES[s]
		if dict.has(type):
			for k in dict[type]:
				if k in exceptions:
					continue
				modules.push_back(k)
	return modules

func add_entry(dict: Dictionary, key: String, data) -> void:
	match typeof(data):
		TYPE_DICTIONARY:
			if dict.has(key):
				dict[key] = merge_dicts(dict[key], data)
			else:
				dict[key] = data.duplicate(true)
		TYPE_ARRAY:
			if dict.has(key):
				dict[key] += data
			else:
				dict[key] = data.duplicate(true)
		_:
			if dict.has(key):
				dict[key] += data
			else:
				dict[key] = data

func add_module(skill: Dictionary, module: Dictionary) -> Dictionary:
	if module.has("slots"):
		for s in module.slots:
			if skill.slots.has(s):
				skill.slots[s].push_back(null)
			else:
				skill.slots[s] = [null]
	if skill.usage=="attack" && module.has("auto_naming_attack"):
		if skill.has("auto_naming"):
			skill.auto_naming = merge_dicts(skill.auto_naming, module.auto_naming_attack)
		else:
			skill.auto_naming = module.auto_naming_attack.duplicate(true)
	elif skill.usage=="heal" && module.has("auto_naming_healing"):
		if skill.has("auto_naming"):
			skill.auto_naming = merge_dicts(skill.auto_naming, module.auto_naming_healing)
		else:
			skill.auto_naming = module.auto_naming_healing.duplicate(true)
	elif module.has("auto_naming"):
		if skill.has("auto_naming"):
			skill.auto_naming = merge_dicts(skill.auto_naming, module.auto_naming)
		else:
			skill.auto_naming = module.auto_naming.duplicate(true)
	
	match skill.usage:
		"attack":
			for k in ["damage_type"]:
				if !module.has(k):
					continue
				if skill.has(k):
					skill[k] += module[k]
				else:
					skill[k] = module[k].duplicate(true)
			for k in ["damage","armour_penetration","damage_multiplier"]:
				if module.has(k):
					add_entry(skill, k, module[k])
			if module.has("latent_damage_type"):
				if !skill.has("latent_damage_type"):
					skill.latent_damage_type = module.latent_damage_type.duplicate(true)
				else:
					for k in module.latent_damage_type:
						if skill.latent_damage_type.has(k):
							if skill.has("damage_type"):
								skill.damage_type.push_back(k)
							else:
								skill.damage_type = [k]
		"heal":
			for k in ["healing_type","shielding_type"]:
				if !module.has(k):
					continue
				if skill.has(k):
					skill[k] += module[k]
				else:
					skill[k] = module[k].duplicate(true)
			for k in ["healing","healing_multiplier"]:
				if module.has(k):
					add_entry(skill, k, module[k])
		"buff":
			for k in ["shielding_type","latent_shielding_type"]:
				if !module.has(k):
					continue
				if skill.has(k):
					skill[k] += module[k]
				else:
					skill[k] = module[k].duplicate(true)
			for k in ["shielding","shielding_multiplier"]:
				if module.has(k):
					add_entry(skill, k, module[k])
		"summon":
			for k in ["summoning","summon_stats","summon_attributes","summon_abilities","summon_damage","summon_resistance"]:
				if module.has(k):
					add_entry(skill, k, module[k])
	for k in ["cost","area","range","cooldown","hits","status_self","health_steal","reflect_damage","attributes","delay_multiplier","duration","summon_name"]:
		if module.has(k):
			add_entry(skill, k, module[k])
	for k in ["status","status_self"]:
		if module.has(k):
			for status in module[k]:
				if !status.has("limit") || skill.usage==status.limit:
					if skill.has("status"):
						skill[k].push_back(status.duplicate(true))
					else:
						skill[k] = [status.duplicate(true)]
		
	
	return skill

func create_skill(type: String) -> Dictionary:
	var skill:= {
		"level":1,
		"slots":{
			"base_type":[type],
		},
		"cost":{},
		"current_cooldown":0.0,
		"range":0,
	}
	var dict: Dictionary = module_data.type[type]
	skill.usage = dict.usage
	skill.type = dict.type
	skill.target_type = dict.target_type
	skill.attribute = dict.attribute
	skill = add_module(skill, dict)
	return skill

func fill_slots(skill: Dictionary, abilities: Array, exceptions:= []) -> Dictionary:
	var i:= -1
	while i<skill.slots.size()-1:
		i += 1
		
		var s = skill.slots.keys()[i]
		var modules:= get_modules(s, abilities, exceptions)
		if modules.size()==0:
			continue
		for j in range(skill.slots[s].size()):
			if skill.slots[s][j]!=null:
				continue
			var type: String = modules.pick_random()
			skill.slots[s][j] = type
			skill = add_module(skill, module_data[s][type])
	return skill

func get_combat(skill: Dictionary) -> Dictionary:
	var hits:= 1
	if skill.has("hits"):
		hits = skill.hits
	var dict:= {
		"status":[],
		"status_self":[],
	}
	if skill.has("cost") && skill.cost.has("focus"):
		dict.focus = skill.cost.focus
	for type in ["damage","healing","shielding"]:
		if !skill.has(type):
			continue
		
		var multiplier:= 1.0
		if skill.has(type+"_multiplier"):
			multiplier = max(1.0 + Characters.get_resistance(skill[type+"_multiplier"]), 0.0)
		dict[type] = []
		for i in range(hits):
			dict[type].push_back([])
			for k in skill[type].keys():
				if skill.has(type+"_type"):
					if typeof(skill[type][k])==TYPE_DICTIONARY:
						for c in skill[type][k].type:
							if c in DAMAGE_TYPES:
								dict[type][i].push_back({"value":multiplier/max(skill[type][k].type.size(), 1.0)*skill[type][k].value,"type":c,"scaling":k})
							else:
								var dam_types = skill[type+"_type"]
								if typeof (dam_types)==TYPE_ARRAY:
									for t in dam_types:
										dict[type][i].push_back({"value":multiplier*skill[type][k]/float(dam_types.size()),"type":t,"scaling":k})
								else:
									dict[type][i].push_back({"value":multiplier/max(skill[type][k].type.size(), 1.0)*skill[type][k].value,"type":dam_types,"scaling":k})
					else:
						if k in DAMAGE_TYPES:
							dict[type][i].push_back({"value":multiplier*skill[type][k],"type":k})
						else:
							var dam_types = skill[type+"_type"]
							if typeof(dam_types)==TYPE_ARRAY:
								for t in dam_types:
									dict[type][i].push_back({"value":multiplier*skill[type][k]/float(dam_types.size()),"type":t,"scaling":k})
							else:
								dict[type][i].push_back({"value":multiplier*skill[type][k],"type":dam_types,"scaling":k})
				elif typeof(skill[type][k])==TYPE_DICTIONARY:
					for c in skill[type][k].type:
						dict[type][i].push_back({"value":multiplier/float(skill[type][k].type.size())*skill[type][k].value,"type":c,"scaling":k})
				else:
					dict[type][i].push_back({"value":multiplier*skill[type][k],"type":k})
	if skill.has("shielding"):
		if typeof(skill.shielding)==TYPE_ARRAY:
			for array in skill.shielding:
				for shield in array:
					shield.value /= float(array.size())
	for c in ["status","status_self"]:
		if skill.has(c):
			for status in skill[c]:
				status = status.duplicate(true)
				if !status.has("name"):
					status.name = skill.name
				for type in ["damage","healing","shielding"]:
					if !status.has(type):
						continue
					var data = status[type]
					status[type] = []
					for k in data.keys():
						if k in DAMAGE_TYPES:
							status[type].push_back({"value":data[k],"type":k})
						else:
							if typeof(data[k])!=TYPE_DICTIONARY:
								var dam_types: Array
								if skill.has(type+"_type"):
									dam_types = skill[type+"_type"]
								else:
									dam_types = ["health"]
								if typeof(dam_types)==TYPE_ARRAY:
									for t in dam_types:
										status[type].push_back({"value":data[k]/float(dam_types.size()),"type":t,"scaling":k})
								else:
									status[type].push_back({"value":data[k],"type":dam_types,"scaling":k})
							elif data[k].has("type"):
								if typeof(data[k].type)==TYPE_ARRAY:
									for t in data[k].type:
										status[type].push_back({"value":data[k].value/float(data[k].type.size()),"type":t,"scaling":k})
								else:
									status[type].push_back({"value":data[k].value,"type":data[k].type,"scaling":k})
							else:
								var dam_types:= []
								if skill.has(type+"_type"):
									dam_types = skill[type+"_type"]
								if typeof(dam_types)==TYPE_ARRAY:
									for t in dam_types:
										status[type].push_back({"value":data[k].value/float(dam_types.size()),"type":t,"scaling":k})
								else:
									status[type].push_back({"value":data[k].value,"type":dam_types,"scaling":k})
				if status.has("attributes") && status.has("scaling_attribute"):
					var scaling:= 1.0
					if status.has("scaling"):
						scaling = status.scaling
					for k in status.attributes.keys():
						status.attributes[k] = {
							"value":status.attributes[k],
							"attribute":status.scaling_attribute,
							"scaling":scaling,
						}
					if skill.has("attributes"):
						for k in skill.attributes.keys():
							if status.attributes.has(k):
								if typeof(status.attributes[k])==TYPE_DICTIONARY:
									status.attributes[k].value += skill.attributes[k]
								else:
									status.attributes[k] += skill.attributes[k]
							else:
								status.attributes[k] = skill.attributes[k]
				if (c=="status_self" || skill.usage!="attack") && !status.has("focus") && dict.has("focus"):
					status.focus = dict.focus
				if skill.has("reflect_damage") && (c=="status_self" || skill.usage!="attack"):
					if status.has("reflect_damage"):
						status.reflect_damage += skill.reflect_damage
					else:
						status.reflect_damage = skill.reflect_damage
				dict[c].push_back(status)
	if skill.has("area") && skill.area>0:
		if skill.area<=1:
			skill.splash_damage = 0.3
		elif skill.area<=2:
			skill.splash_damage = 0.6
		else:
			if skill.target_type=="enemy" || skill.target_type=="all_enemies":
				skill.target_type = "all_enemies"
			elif skill.usage=="buff" || skill.usage=="heal":
				skill.target_type = "all_allies"
	return dict

func create_name(skill: Dictionary) -> String:
	var string: String
	if skill.auto_naming.has("base"):
		string = skill.auto_naming.base.pick_random()
	else:
		string = module_data.type[skill.slots.base_type[0]].name
	if skill.auto_naming.has("type"):
		var t:= ""
		var used:= []
		for i in range(skill.auto_naming.type.size()):
			var type1: String = skill.slots.magic[i]
			var o:= false
			if i in used:
				continue
			for j in range(skill.auto_naming.type.size()):
				if i==j || j in used:
					continue
				var array:= [type1, skill.slots.magic[j]]
				if !Names.DUAL_MAGIC_NAMES.has(array):
					array = [skill.slots.magic[j], type1]
				if Names.DUAL_MAGIC_NAMES.has(array):
					t += Names.DUAL_MAGIC_NAMES[array].pick_random()
					if i<skill.auto_naming.type.size()-1-float(j>i):
						t += "-"
					o = true
					used += [i,j]
					break
			if o:
				continue
			t = skill.auto_naming.type[i].pick_random() + "-" + t
#			if i<skill.auto_naming.type.size()-1:
#				t += "-"
			used.push_back(i)
		if t[t.length()-1]=='-':
			t = t.left(t.length()-1)
		string = t + " " + string
	if skill.auto_naming.has("prefix"):
		var n: String
		for i in range(20):
			n = skill.auto_naming.prefix.pick_random()
			if n.similarity(string)*sqrt(float(max(n.length(), string.length()))/float(min(n.length(), string.length())))<0.5:
				break
		if skill.auto_naming.has("base") && n.similarity(string)*sqrt(float(max(n.length(), string.length()))/float(min(n.length(), string.length())))>0.5:
			for i in range(20):
				string = skill.auto_naming.base.pick_random()
				if n.similarity(string)*sqrt(float(max(n.length(), string.length()))/float(min(n.length(), string.length())))<0.5:
					break
		string = n + " " + string
	if skill.auto_naming.has("suffix"):
		var n: String
		for i in range(20):
			n = skill.auto_naming.suffix.pick_random()
			if n.similarity(string)*sqrt(float(max(n.length(), string.length()))/float(min(n.length(), string.length())))<0.5:
				break
		string = string + " " + n
	return string.capitalize()

func format_damage(array: Array, attribute: String, left:= "    ") -> String:
	var text:= ""
	text += "\n" + left
	for j in range(array.size()):
		var data: Dictionary = array[j]
		if j>0:
			text += " / "
		text += str(int(100*data.value)) + "% "
		if data.has("scaling"):
			text += tr("OF") + " " + tr(data.scaling.to_upper()) + " "
		else:
			text += tr("OF") + " " + tr(attribute.to_upper()) + " "
#		if DAMAGE_COLOR.has(data.type):
#			text += tr("AS") + " " + "[color=" + DAMAGE_COLOR[data.type] + "]" + tr(data.type.to_upper()) + "[/color]"
#		else:
		text += tr("AS") + " " + tr(data.type.to_upper())
	return text

func format_status(status: Dictionary, attribute: String, left:= "    ") -> String:
	var text:= ""
	text += "\n" + left + status.name + ":\n    " + left + status.type
	if status.has("focus"):
#		text += "\n" + left + "    [color=" + RESOURCE_COLOR.focus + "]" + tr("FOCUS") + ": " + str(status.focus) + "[/color]"
		text += "\n" + left + "    " + tr("FOCUS") + ": " + str(status.focus)
	if status.has("stun"):
		text += "\n" + left + "    " + tr("STUN") + ": " + str(int(100*status.stun)) + "%"
	for type in ["damage","healing","shielding"]:
		if status.has(type):
			text += "\n" + left + "    " + tr(type.to_upper()).capitalize() + ":"
			text += format_damage(status[type], attribute, left + "        ")
	if status.has("attributes"):
		for k in status.attributes.keys():
			match typeof(status.attributes[k]):
				TYPE_DICTIONARY:
					if status.attributes[k].has("scaling"):
						if status.attributes[k].scaling>=0.0:
							if status.attributes[k].value>=0:
								text += "\n" + left + "    " + tr(k.to_upper()) + ": +" + str(int(status.attributes[k].value)) + " + " + str(int(100*status.attributes[k].scaling)) + "% " + tr("OF") + " " + status.attributes[k].attribute
							else:
								text += "\n" + left + "    " + tr(k.to_upper()) + ": -" + str(-int(status.attributes[k].value)) + " + " + str(-int(100*status.attributes[k].scaling)) + "% " + tr("OF") + " " + status.attributes[k].attribute
						else:
							if status.attributes[k].value>=0:
								text += "\n" + left + "    " + tr(k.to_upper()) + ": +" + str(int(status.attributes[k].value)) + " - " + str(int(100*status.attributes[k].scaling)) + "% " + tr("OF") + " " + status.attributes[k].attribute
							else:
								text += "\n" + left + "    " + tr(k.to_upper()) + ": -" + str(-int(status.attributes[k].value)) + " - " + str(-int(100*status.attributes[k].scaling)) + "% " + tr("OF") + " " + status.attributes[k].attribute
					else:
						if status.attributes[k].value>=0:
							text += "\n" + left + "    " + tr(k.to_upper()) + ": +" + str(int(status.attributes[k].value))
						else:
							text += "\n" + left + "    " + tr(k.to_upper()) + ": -" + str(-int(status.attributes[k].value))
				TYPE_FLOAT, TYPE_INT:
					if status.attributes[k]>=0:
						text += "\n" + left + "    " + tr(k.to_upper()) + ": +" + str(int(status.attributes[k]))
					else:
						text += "\n" + left + "    " + tr(k.to_upper()) + ": -" + str(-int(status.attributes[k]))
				_:
					text += "\n" + left + "    " + tr(k.to_upper()) + ": " + str(status.attributes[k])
	if status.has("reflect_damage"):
		text += "\n" + left + tr("REFLECT_DAMAGE") + ": " + str(int(100*status.reflect_damage)) + "%"
	text += "\n" + left + "    " + tr("DURATION") + ": " + str(status.duration).pad_decimals(1)
	return text

func create_tooltip(skill: Dictionary) -> String:
	var text: String = skill.name + "\n" + tr(skill.type.to_upper()) + " "
	if skill.has("usage"):
		match skill.usage:
			"attack":
				text += tr("ATTACK")
			"heal":
				text += tr("HEALING")
			"buff":
				text += tr("BUFF")
			"summon":
				text += tr("SUMMON")
			_:
				text += tr("SKILL")
	else:
		text += tr("SKILL")
	text += "\n"
	if skill.has("range"):
		if skill.range<1:
			text += "\n" + tr("RANGE") + ": " + tr("MELEE_RANGE")
		elif skill.range<2:
			text += "\n" + tr("RANGE") + ": " + tr("SHORT_RANGE")
		else:
			text += "\n" + tr("RANGE") + ": " + tr("LONG_RANGE")
	else:
		text += "\n" + tr("RANGE") + ": " + tr("MELEE_RANGE")
	if skill.has("target_type"):
		text += "\n" + tr("TARGET") + ": " + tr(skill.target_type.to_upper())
	if skill.has("splash_damage"):
		text += "\n" + tr("SPLASH_DAMAGE") + ": " + str(int(100*skill.splash_damage)) + "% "
	if skill.has("cost") && skill.cost.size()>0:
		text += "\n" + tr("COST") + ":"
		for k in skill.cost.keys():
#			text += "\n    [color=" + RESOURCE_COLOR[k] + "]" + tr(k.to_upper()) + ": " + str(skill.cost[k]) + "[/color]"
			text += "\n    " + tr(k.to_upper()) + ": " + str(skill.cost[k]).pad_decimals(1)
	
	for type in ["damage","healing","shielding"]:
		if !skill.has("combat") || !skill.combat.has(type):
			continue
		text += "\n" + tr(type.to_upper()).capitalize() + ":"
		for i in range(skill.combat[type].size()):
			text += format_damage(skill.combat[type][i], skill.attribute)
	if skill.has("summoning") && skill.summoning.size()>0:
		text += "\n" + tr("SUMMONING") + ":"
		for k in skill.summoning.keys():
#			text += "\n    [color=" + ATTRIBUTE_COLOR[k] + "]" + tr(k.to_upper()) + ": " + str(skill.summoning[k]) + "[/color]"
			text += "\n    " + str(int(100*skill.summoning[k])) + "% " + tr("OF") + " " + tr(k.to_upper())
		text += "\n    " + tr("STATS") + ":"
		for k in skill.summon_stats.keys():
			text += "\n        " + tr(k.to_upper()) + ": " + str(int(skill.summon_stats[k]))
		text += "\n    " + tr("ATTRIBUTES") + ":"
		for k in skill.summon_attributes.keys():
			if skill.summon_attributes[k]==0:
				continue
			text += "\n        " + tr(k.to_upper()) + ": " + str(int(skill.summon_attributes[k]))
		for t in ["damage","resistance"]:
			if skill.has("summon_"+t):
				text += "\n    " + tr(t.to_upper()) + ":"
				for k in skill["summon_"+t].keys():
					if skill["summon_"+t][k]>=0:
						text += "\n        " + tr(k.to_upper()) + ": +" + str(int(100*skill["summon_"+t][k])) + "%"
					else:
						text += "\n        " + tr(k.to_upper()) + ": -" + str(-int(100*skill["summon_"+t][k])) + "%"
		text += "\n    " + tr("ABILITIES") + ":"
		for k in skill.summon_abilities:
			text += "\n        " + tr(k.to_upper())
	if skill.has("duration"):
		text += "\n" + tr("DURATION") + ": " + str(skill.duration).pad_decimals(1)
	
	if skill.has("combat") && skill.combat.has("status") && skill.combat.status.size()>0:
		text += "\n" + tr("STATUS") + ":"
		for status in skill.combat.status:
			text += format_status(status, skill.attribute)
	if skill.has("combat") && skill.combat.has("status_self") && skill.combat.status_self.size()>0:
		text += "\n" + tr("STATUS") + " (" + tr("CASTER") + ")" + ":"
		for status in skill.combat.status_self:
			text += format_status(status, skill.attribute)
	
	if skill.has("reflect_damage"):
		text += "\n" + tr("REFLECT_DAMAGE") + ": " + str(int(100*skill.reflect_damage)) + "%"
	if skill.has("armour_penetration"):
		text += "\n" + tr("ARMOUR_PENETRATION") + ": " + str(int(100*Characters.get_resistance(skill.armour_penetration))) + "%"
	if skill.has("health_steal"):
		text += "\n" + tr("HEALTH_STEAL") + ": " + str(int(100*skill.health_steal)) + "%"
	if skill.has("attributes"):
		for s in skill.attributes.keys():
			text += "\n" + tr(s.to_upper()) + ": " + str(skill.attributes[s])
	if skill.has("delay_multiplier"):
		text += "\n" + tr("ACTION_SPEED") + ": " + str(int(100.0/max(1.0 + skill.delay_multiplier, 0.01) - 1.0)) + "%"
	if skill.has("cooldown"):
		text += "\n" + tr("COOLDOWN") + ": " + str(skill.cooldown)
	
	return text

func create_random_skill(abilities: Array, force_type:= "", basic:= false, invalid_names:= [], exceptions:= []) -> Dictionary:
	var type:= force_type
	var skill_name: String
	if !module_data.type.has(type):
		type = get_modules("base_type", abilities, exceptions).pick_random()
	var skill:= create_skill(type)
	if !basic:
		skill = fill_slots(skill, abilities, exceptions)
		skill = fill_slots(skill, abilities, exceptions)
	for i in range(20):
		skill_name = create_name(skill)
		if !(skill_name in invalid_names):
			break
	skill.name = skill_name
	skill.combat = get_combat(skill)
	skill.erase("status")
	skill.erase("status_self")
	skill.erase("damage")
	skill.erase("healing")
	skill.erase("shielding")
	skill.erase("auto_naming")
	skill.description = create_tooltip(skill)
	return skill


# loading #

func get_file_paths(path: String) -> Array:
	var array:= []
	var dir:= DirAccess.open(path)
	var error:= DirAccess.get_open_error()
	if error!=OK:
		print("Error when accessing "+path+"!")
		return array
	
	dir.list_dir_begin()
	var file_name:= dir.get_next()
	while file_name!="":
		if !dir.current_is_dir():
			array.push_back(path+"/"+file_name)
		file_name = dir.get_next()
	
	return array

func get_sub_dirs(path: String) -> Array:
	var array:= []
	var dir:= DirAccess.open(path)
	var error:= DirAccess.get_open_error()
	if error!=OK:
		print("Error when accessing "+path+"!")
		return array
	
	dir.list_dir_begin()
	var file_name:= dir.get_next()
	while file_name!="":
		if dir.current_is_dir():
			array.push_back(path+"/"+file_name)
		file_name = dir.get_next()
	
	return array

func load_data(paths: Array, type: String):
	if !module_data.has(type):
		module_data[type] = {}
	for file_name in paths:
		var file:= FileAccess.open(file_name, FileAccess.READ)
		var error:= FileAccess.get_open_error()
		if error!=OK:
			print("Can't open file " + file_name + "!")
			continue
		else:
			print("Loading items " + file_name + ".")
		
		var raw:= file.get_as_text()
		var data: Dictionary = JSON.parse_string(raw)
		if data==null || data.size()==0:
			printt("Error parsing " + file_name + "!")
			continue
		for k in data.keys():
			module_data[type][k] = data[k]
		file.close()

func load_skill_data(path: String):
	load_data(get_file_paths(path+"/base_type"), "type")
	load_data(get_file_paths(path+"/magic"), "magic")
	load_data(get_file_paths(path+"/melee_mod"), "melee_mod")
	load_data(get_file_paths(path+"/ranged_mod"), "ranged_mod")
	load_data(get_file_paths(path+"/magic_mod"), "magic_mod")
	load_data(get_file_paths(path+"/defence_mod"), "defence_mod")
	load_data(get_file_paths(path+"/grapple_mod"), "grapple_mod")
	load_data(get_file_paths(path+"/aim"), "aim")
	load_data(get_file_paths(path+"/shape"), "shape")
	load_data(get_file_paths(path+"/application"), "application")
	load_data(get_file_paths(path+"/summon_type"), "summon_type")
	load_data(get_file_paths(path+"/summoning_method"), "summoning_method")

func _ready():
	load_skill_data("res://data/skills")
	
	for path in get_sub_dirs("user://mods/"):
		print("Loading mod " + path + " skills.")
		load_skill_data(path + "/data/skills")
