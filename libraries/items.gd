extends Node

const ATTRIBUTES = [
	"attack", "magic", "willpower", "accuracy", "armour", "evasion",
	"penetration", "speed", "critical",
]
const RANK_COLORS = [
	Color(0.6,0.6,0.6),
	Color(1.0,1.0,1.0),
	Color(0.3,1.0,0.2),
	Color(0.2,0.6,1.0),
	Color(1.0,1.0,0.2),
	Color(0.6,0.2,1.0),
	Color(0.6,0.5,0.1),
]
const EQUIPMENT_ATTRIBUTE_MULTIPLIER = {
	"weapon":1.5,
	"belt":0.75,
	"amulet":0.5,
	"ring":0.5,
	"earring":0.5,
	"bracelet":0.5,
}
const EQUIPMENT_TYPE_NAME = {
	"weapon":["weapon", "tool"],
	"torso":["armour", "clothing", "chest", "harness"],
	"legs":["pants", "greaves"],
	"head":["hat", "helmet"],
	"hands":["gloves"],
	"feet":["boots"],
	"belt":["belt"],
	"cape":["cape", "cloak"],
	"amulet":["amulet", "pendant"],
	"ring":["ring"],
	"earring":["earring"],
	"bracelet":["bracelet"],
}
const EQUIPMENT_SUBTYPE_NAME = {
	"melee":["basher", "smasher", "cutter", "piercer"],
	"ranged":["thrower", "shooter", "projector", "launcher"],
	"magic":["catalyst", "amplifier", "infuser", "artifact"],
}
const LEGENDARY_ITEM_NAME = {
	"dagger": ["knife", "scalpel", "shard"],
	"rapier": ["needle", "piercer"],
	"short_sword": ["blade", "razor"],
	"long_sword": ["edge", "cutlass", "saber"],
	"hand_axe": ["cleaver", "cutter"],
	"mace": ["club", "morning star", "pickle"],
	"greatsword": ["cutter", "obliterator", "bastard sword"],
	"greatmaul": ["maul", "obliterator", "basher", "trasher"],
	"battleaxe": ["feller", "waraxe"],
	"scythe": ["harvester"],
	"spear": ["pole", "lance", "spire"],
	"staff": ["rod", "sceptre", "spire"],
	"tome": ["grimoire", "spell book", "encyclopedia"],
	"orb": ["heartstone", "shard", "eye", "singularity"],
	"amplifier": ["aether core", "catalyst"],
	"blowgun": ["dart launcher", "needle thrower"],
	"pistol": ["blaster", "gun", "sidearm"],
	"bow": ["long bow", "war bow"],
	"crossbow": ["ballista", "arbalest"],
	"blunderbuss": ["shotgun", "rifle", "cannon"],
	"buckler": ["shield", "deflector"],
	"kite_shield": ["protector", "guard"],
	"tower_shield": ["protector", "tower"],
	"cloth_shirt": ["robe", "clothing"],
	"leather_chest": ["skin", "hide"],
	"chain_cuirass": ["scales", "scale male"],
	"plate_cuirass": ["harness", "cage"],
	"leather_gloves": ["fists", "wraps"],
	"chain_gauntlets": ["fists", "grip"],
	"cloth_hat": ["hat", "headband"],
	"leather_hat": ["hat", "cap"],
	"chain_coif": ["crown"],
	"plate_helm": ["helmet", "visor"],
	"cloth_sandals": ["sandals", "walker"],
	"leather_boots": ["boots", "walker"],
	"belt": ["girdle"],
	"cape": ["wrap", "cloak", "mantle"],
	"ring": ["circle", "jewel"],
	"amulet": ["pendant", "jewel"],
}
const DEFAULT_MATERIAL_PRICE = 10
const DEFAULT_MATERIAL_TYPES = [
	{
		"name": "common",
		"quality":0.75,
	},
	{
		"name": "good",
		"quality":1.0,
	},
	{
		"name": "rare",
		"quality":1.25,
	},
]
const DEFAULT_MATERIALS = {
	"wood":[
		{
			"name": "pine",
			"quality":0.75,
		},
		{
			"name": "cedar",
			"quality":0.75,
		},
		{
			"name": "maple",
			"quality":1.0,
		},
		{
			"name": "bamboo",
			"quality":1.0,
		},
		{
			"name": "birch",
			"quality":1.25,
		},
		{
			"name": "oak",
			"quality":1.25,
		},
	],
	"paper":[
		{
			"name": "rough",
			"quality":0.75,
		},
		{
			"name": "bleached",
			"quality":1.0,
		},
		{
			"name": "common",
			"quality":1.0,
		},
		{
			"name": "infused",
			"quality":1.25,
		},
	],
	"cloth":[
		{
			"name": "wool",
			"quality":0.75,
		},
		{
			"name": "polyester",
			"quality":0.75,
		},
		{
			"name": "linen",
			"quality":1.0,
		},
		{
			"name": "cotton",
			"quality":1.0,
		},
		{
			"name": "velvet",
			"quality":1.25,
		},
		{
			"name": "silk",
			"quality":1.25,
		},
	],
	"leather":[
		{
			"name": "rough",
			"quality":0.75,
		},
		{
			"name": "worn down",
			"quality":0.75,
		},
		{
			"name": "reinforced",
			"quality":1.0,
		},
		{
			"name": "wolf skin",
			"quality":1.0,
		},
		{
			"name": "bear skin",
			"quality":1.25,
		},
		{
			"name": "troll hide",
			"quality":1.25,
		},
	],
	"metal":[
		{
			"name": "tin",
			"quality":0.75,
		},
		{
			"name": "copper",
			"quality":0.75,
		},
		{
			"name": "bronze",
			"quality":1.0,
		},
		{
			"name": "iron",
			"quality":1.0,
		},
		{
			"name": "steel",
			"quality":1.25,
		},
		{
			"name": "silver",
			"quality":1.25,
		},
	],
	"stone":[
		{
			"name": "clay",
			"quality":0.75,
		},
		{
			"name": "graphite",
			"quality":0.75,
		},
		{
			"name": "quartz",
			"quality":1.0,
		},
		{
			"name": "sand stone",
			"quality":1.0,
		},
		{
			"name": "granite",
			"quality":1.25,
		},
		{
			"name": "basalt",
			"quality":1.25,
		},
	],
	"gem":[
		{
			"name": "quartz",
			"quality":0.75,
		},
		{
			"name": "peridot",
			"quality":0.75,
		},
		{
			"name": "turquoise",
			"quality":0.75,
		},
		{
			"name": "glass",
			"quality":0.75,
		},
		{
			"name": "agate",
			"quality":1.0,
		},
		{
			"name": "emerald",
			"quality":1.0,
		},
		{
			"name": "amber",
			"quality":1.0,
		},
		{
			"name": "lapis lazuli",
			"quality":1.0,
		},
		{
			"name": "garnet",
			"quality":1.25,
		},
		{
			"name": "hematite",
			"quality":1.25,
		},
		{
			"name": "ruby",
			"quality":1.25,
		},
		{
			"name": "sapphire",
			"quality":1.25,
		},
	],
	"bone":[
		{
			"name": "withered",
			"quality":0.75,
		},
		{
			"name": "beast",
			"quality":1.0,
		},
		{
			"name": "tiger",
			"quality":1.25,
		},
	],
	"soul":[
		{
			"name": "fleeting",
			"quality":0.75,
		},
		{
			"name": "unremarkable",
			"quality":1.0,
		},
		{
			"name": "greater",
			"quality":1.25,
		},
	],
}
const LEGENDARY_MATERIALS = {
	"wood":[
		{
			"name": "redwood",
			"quality":1.0,
			"add": {
				"attack":0.5,
				"penetration":0.75,
			},
		},
		{
			"name": "blackwood",
			"quality":1.0,
			"add": {
				"accuracy":0.5,
				"evasion":0.5,
			},
		},
		{
			"name": "whitewood",
			"quality":1.0,
			"add": {
				"health":5,
				"stamina":2.5,
				"mana":2.5,
			},
		},
		{
			"name": "steelwood",
			"quality":1.0,
			"add": {
				"armour":1,
			},
		},
	],
	"paper":[
		{
			"name": "forgotten beast",
			"quality":1.0,
			"add": {
				"willpower":1,
			},
		},
		{
			"name": "ancient beast",
			"quality":1.0,
			"add": {
				"magic":0.5,
				"accuracy":0.5,
			},
		},
		{
			"name": "aether infused",
			"quality":1.0,
			"add": {
				"mana":2.5,
				"mana_regen":1.5,
			},
		},
	],
	"cloth":[
		{
			"name": "aramid",
			"quality":1.0,
			"add": {
				"resistance": {
					"piercing":0.025,
					"fire":0.025,
					"light":0.025,
				},
			},
		},
		{
			"name": "ancient beast fur",
			"quality":1.0,
			"add": {
				"resistance": {
					"cutting":0.025,
					"ice":0.025,
					"water":0.025,
				},
			},
		},
		{
			"name": "exquisite velvet",
			"quality":1.0,
			"add": {
				"willpower":0.5,
				"evasion":0.5,
			},
		},
		{
			"name": "resilient silk",
			"quality":1.0,
			"add": {
				"willpower":0.5,
				"armour":0.5,
			},
		},
	],
	"leather":[
		{
			"name": "infused troll",
			"quality":1.0,
			"add": {
				"health_regen":2.5,
			},
		},
		{
			"name": "ancient beast",
			"quality":1.0,
			"add": {
				"armour":0.5,
				"accuracy":0.5,
			},
		},
		{
			"name": "forgotten beast",
			"quality":1.0,
			"add": {
				"armour":0.5,
				"evasion":0.5,
			},
		},
	],
	"metal":[
		{
			"name": "mithril",
			"quality":1.0,
			"add": {
				"accuracy":0.5,
				"evasion":0.5,
			},
		},
		{
			"name": "black steel",
			"quality":1.0,
			"add": {
				"attack":0.5,
				"penetration":0.75,
			},
		},
		{
			"name": "quicksilver",
			"quality":0.95,
			"add": {
				"speed":0.5,
			},
		},
	],
	"stone":[
		{
			"name": "granite",
			"quality":1.0,
			"add": {
				"resistance": {
					"cutting":0.02,
					"piercing":0.02,
					"impact":0.02,
				},
			},
		},
		{
			"name": "basalt",
			"quality":1.0,
			"add": {
				"attack":1,
			},
		},
		{
			"name": "marble",
			"quality":1.0,
			"add": {
				"magic":0.5,
				"mana_regen":1.5,
			},
		},
	],
	"gem":[
		{
			"name": "pure diamond",
			"quality":1.0,
			"add": {
				"magic":1,
			},
		},
		{
			"name": "star saphire",
			"quality":1.0,
			"add": {
				"magic":0.5,
				"willpower":0.5,
			},
		},
		{
			"name": "blood ruby",
			"quality":1.0,
			"add": {
				"health":2.5,
				"health_regen":1,
			},
		},
	],
	"bone":[
		{
			"name": "ancient beast",
			"quality":1.0,
			"add": {
				"resitance": {
					"impact":0.02,
					"cutting":0.02,
					"piercing":0.02,
				},
			},
		},
		{
			"name": "ancient beast",
			"quality":1.0,
			"add": {
				"damage": {
					"impact":0.015,
					"cutting":0.015,
					"piercing":0.015,
				},
			},
		},
	],
}
const SOUL_STONES = [
	"soul_splinter", "soul_shard", "soul_stone", "soul_gem", "soul_jewel", "soul_orb"
]

var is_vegan:= false
var materials:= {}
var equipment_components:= {}
var equipment_recipes:= {}
var potion_recipes:= {}
var food_recipes:= {}

@onready
var Description:= $Description
@onready
var Enchantment:= $Enchantment


func pick_random_equipment(type: String) -> String:
	var valid:= []
	for k in equipment_recipes.keys():
		if equipment_recipes[k].type == type:
			valid.push_back(k)
	if valid.size() > 0:
		return valid.pick_random()
	return ""


func get_material_quality(material_list: Array) -> int:
	var quality:= 0
	for mat in material_list:
		quality += mat.quality
	quality /= material_list.size()
	return quality

func get_creature_quality(creature: Dictionary) -> int:
	var quality: int
	var tier_multiplier:= 1.0
	var level_multiplier: float = 1.0 + 0.1 * (creature.level - 1)
	if creature.tier < 0:
		tier_multiplier = 1.0 / sqrt(-2.0 * creature.tier)
	elif creature.tier > 0:
		tier_multiplier = sqrt(2.0 * creature.tier)
	quality = int(100*level_multiplier*tier_multiplier)
	return quality

func make_list(array: Array) -> String:
	var string:= ""
	if array.size() == 1:
		string = Story.get_a_an(array[0].name) + array[0].name
	elif array.size() == 2:
		string = Story.get_a_an(array[0].name) + array[0].name + " and " + \
			Story.get_a_an(array[1].name) + array[1].name
	else:
		for i in range(array.size()):
			string += Story.get_a_an(array[i].name) + array[i].name
			if i < array.size() - 2:
				string += ", "
			elif i == array.size() - 2:
				string += ", and "
	return string

func format_damage_type(type: String) -> String:
	if type in Skills.DAMAGE_COLOR:
		return "[color=" + Skills.DAMAGE_COLOR[type] + "]" + tr(type.to_upper()) + "[/color]"
	return tr(type.to_upper())

func format_resource(type: String, add:= "") -> String:
	if type in Skills.RESOURCE_COLOR:
		return "[color=" + Skills.RESOURCE_COLOR[type] + "]" + tr(type.to_upper() + add) + "[/color]"
	if type.right(6) == "_regen":
		var t:= type.left(type.length() - 6)
		if t in Skills.RESOURCE_COLOR:
			return "[color=" + Skills.RESOURCE_COLOR[t] + "]" + tr(type.to_upper() + add) + "[/color]"
	return tr(type.to_upper() + add)

func format_item_name(item: Dictionary) -> String:
	item.rank = get_item_rank(item)
	return "[color=" + RANK_COLORS[item.rank].to_html(false) + "]" + item.name + "[/color]"

func create_tooltip(item: Dictionary) -> String:
	var text: String = format_item_name(item) + "\n" + item.type + "\n"
	text += "\n" + "quality: " + str(int(item.quality)) + "%\n"
	for k in ATTRIBUTES:
		if !item.has(k) || int(item[k]) == 0:
			continue
		if item[k]>0:
			text += tr(k.to_upper()) + ": +" + str(int(item[k])) + "\n"
		else:
			text += tr(k.to_upper()) + ": -" + str(-int(item[k])) + "\n"
	for k in Characters.DEFAULT_STATS.keys():
		if !item.has(k) || int(item[k]) == 0:
			continue
		if item[k]>0:
			text += tr(k.to_upper()) + ": +" + str(int(item[k])) + "\n"
		else:
			text += tr(k.to_upper()) + ": -" + str(-int(item[k])) + "\n"
	if item.has("healing"):
		text += tr("HEALING") + ": " + str(int(item.healing)) + " " + \
			format_resource(item.effect) + "\n"
	if item.has("damage"):
		text += tr("DAMAGE") + ":\n"
		for k in item.damage.keys():
			var value:= int(100 * item.damage[k])
			if value == 0:
				continue
			if item.damage[k]>=0.0:
				text += "  " + format_damage_type(k) + ": +" + str(value) + "%\n"
			else:
				text += "  " + format_damage_type(k) + ": -" + str(-value) + "%\n"
	for k in Characters.RESOURCES:
		if item.has(k):
			if item[k] >= 0:
				text += format_resource(k) + ": +" + str(int(item[k])) + "\n"
			else:
				text += format_resource(k) + ": -" + str(-int(item[k])) + "\n"
		if item.has(k + "_regen") && item[k + "_regen"] != 0:
			var value:= int(item[k+"_regen"])
			if value == 0:
				continue
			if item[k + "_regen"]>0:
				text += format_resource(k, "_REGEN") + ": +" + str(value) + "\n"
			else:
				text += format_resource(k, "_REGEN") + ": -" + str(-value) + "\n"
	if item.has("resistance"):
		text += tr("RESISTANCE") + ":\n"
		for k in item.resistance.keys():
			var value:= int(100 * item.resistance[k])
			if value == 0:
				continue
			if item.resistance[k] >= 0.0:
				text += "  " + format_damage_type(k) + ": +" + str(value) + "%\n"
			else:
				text += "  " + format_damage_type(k) + ": -" + str(-value) + "%\n"
	if item.has("status"):
		text += tr("APPLIES_STATUS").format({
			"status":item.status.name,
		}) + "\n  " + item.status.type + "\n"
		for k in item.status.keys():
			if k == "name" || k == "type":
				continue
			if k=="effect":
				if typeof(item.status.effect) == TYPE_ARRAY:
					text += "  " + tr("INCREASES") + " " + Names.make_list(item.status.effect) + \
						"\n"
				else:
					text += "  " + tr("INCREASES") + " " + item.status.effect + "\n"
				continue
			if typeof(item.status[k]) == TYPE_ARRAY:
				text += "  " + format_resource(k) + ": " + Names.make_list(item.status[k]) + "\n"
			else:
				text += "  " + format_resource(k) + ": " + str(int(item.status[k])) + "\n"
	if item.has("mod"):
		for k in item.mod.keys():
			if item.mod[k] >= 0.0:
				text += format_resource(k) + ": +" + str(int(100 * item.mod[k])) + "%\n"
			else:
				text += format_resource(k) + ": -" + str(-int(100 * item.mod[k])) + "%\n"
	if item.has("add"):
		for k in item.add.keys():
			match typeof(item.add[k]):
				TYPE_INT, TYPE_FLOAT:
					var value:= int(item.add[k])
					if value != 0:
						if item.add[k] >= 0.0:
							text += format_resource(k) + ": +" + str(value) + "\n"
						else:
							text += format_resource(k) + ": -" + str(-value) + "\n"
				TYPE_DICTIONARY:
					text += format_resource(k) + ":\n"
					for s in item.add[k].keys():
						var value: int
						var unit:= ""
						if k in ["damage", "resistance"]:
							value = int(100 * item.add[k][s])
							unit = "%"
						else:
							value = int(item.add[k][s])
						if value==0:
							continue
						if item.add[k][s]>=0.0:
							text += "    " + format_damage_type(s) + ": +" + str(value) + \
								unit + "\n"
						else:
							text += "    " + format_damage_type(s) + ": -" + str(-value) + \
								unit + "\n"
	text += tr("PRICE") + ": " + str(int(item.price))
	return text


func create_description(item: Dictionary, max_sentences:= 0) -> String:
	var rank:= get_item_rank(item)
	var text: String = format_item_name(item) + "\n" + item.type + "\n"
	if "source" not in item:
		item.source = tr("UNKNOWN_ORIGIN")
	text += item.source + "\n\n"
	
	if "card_set" not in item:
		item.card_set = Description.create_description_data(item, rank)
	
	if max_sentences == 0:
		max_sentences = clamp(int((rank + randi_range(0, 2)) / 2.0), 1, 4)
	text += Description.generate_description(item.card_set, max_sentences)
	
	return text

func create_component_tooltip(item: Dictionary) -> String:
	if "components" not in item:
		return ""
	if "source" not in item:
		item.source = tr("UNKNOWN_ORIGIN")
	var text: String = format_item_name(item) + "\n" + item.type + "\n" + \
		item.source + "\n\n" + tr("COMPONENTS") + ": "
	if item.components is Array:
		for dict in item.components:
			if typeof(dict) == TYPE_DICTIONARY:
				text += "\n  " + dict.name
			else:
				text += "\n  " + str(dict)
	else:
		text += "\n" + item.components
	
	return text


func merge_dicts(dict: Dictionary, add: Dictionary, multiplier:= 1.0) -> Dictionary:
	for k in add.keys():
		if k!="speed" && (typeof(add) == TYPE_INT || typeof(add) == TYPE_FLOAT):
			add[k] *= multiplier
		if dict.has(k):
			if typeof(dict[k]) == TYPE_STRING:
				dict[k] = [dict[k], add[k]]
			elif typeof(add[k]) == TYPE_DICTIONARY:
				merge_dicts(dict[k], add[k], multiplier)
			else:
				if typeof(dict[k]) == TYPE_ARRAY && typeof(add[k]) != TYPE_ARRAY:
					dict[k].push_back(add[k])
				else:
					dict[k] += add[k]
		else:
			dict[k] = add[k]
	return dict

func get_item_rank(item: Dictionary) -> int:
	var rank:= 0
	if "enchantments" in item:
		rank += 1
	elif "enchantment_potential" in item && item.enchantment_potential > 1:
		rank += 1
	if "legendary" in item and item.legendary:
		rank += 4
	if "mod" in item or "add" in item:
		rank += 1
	rank += int(log(1.0 + item.quality / 100.0 + 0.1 * item.quality / 100.0 * item.quality / 100.0))
	return min(rank, RANK_COLORS.size() - 1)

func pick_random_material(type: String) -> String:
	var valid:= []
	for k in materials.keys():
		if type in materials[k].tags:
			valid.push_back(k)
	if valid.size() > 0:
		return valid.pick_random()
	return materials.keys().pick_random()

func create_material_list(components: Array) -> Array:
	var array:= []
	for type in components:
		array.push_back(equipment_components[type].material)
	return array

func create_random_materials(list: Array, region: Region, quality_mod:= 1.0) -> Array:
	var material_list:= []
	for array in list:
		var type: String = array.pick_random()
		material_list.push_back(create_regional_material(pick_random_material(type),
			region, quality_mod))
	return material_list

func create_random_equipment(type: String, components: Array, region: Region,
		info:= {}, tier:= 0, quality_mod:= 1.0, quality_bonus:= 0) -> Dictionary:
	var item: Dictionary
	var quality_scale:= 0.5 + 0.5 * components.size() / (components.size() + tier)
	quality_mod *= quality_scale
	components = components.duplicate(true)
	for i in range(tier):
		components.push_back(equipment_components.keys().pick_random())
	item = create_equipment(type, components, create_random_materials(
		create_material_list(components), region, quality_mod), info, quality_bonus)
	item.quality = int(item.quality / quality_scale)
	if tier==1:
		item.name = tr("UNCOMMON").capitalize() + " " + item.name.split(' ')[0] + " "
		if info.has("name"):
			item.name += tr(info.name.to_upper()).capitalize()
		elif info.has("type"):
			item.name += tr(info.type.to_upper()).capitalize()
		else:
			item.name += tr(type.to_upper()).capitalize()
	elif tier>=2:
		item.name = item.name.split(' ')[0] + " " + tr("PROTO").capitalize() + " "
		if info.has("name"):
			item.name += tr(info.name.to_upper()).capitalize()
		elif info.has("type"):
			item.name += tr(info.type.to_upper()).capitalize()
		else:
			item.name += tr(type.to_upper()).capitalize()
	return item

func create_random_standard_equipment(type: String, region: Region, tier:= 0,
		quality_mod:= 1.0, quality_bonus:= 0) -> Dictionary:
	var item: Dictionary
	var dict: Dictionary = equipment_recipes[type].duplicate(true)
	dict.base_type = type
	item = create_random_equipment(dict.type, dict.components, region, dict, tier,
		quality_mod, quality_bonus)
	item.recipe = type
	return item

func create_randomized_equipment(type: String, slot: String, subtype: String,num_components: int,
		region: Region, tier:= 0, quality_mod:= 1.0, quality_bonus:= 0) -> Dictionary:
	var item: Dictionary
	var valid:= []
	var components:= []
	var nm: String
	components.resize(num_components)
	for k in equipment_components.keys():
		if "subtype" in equipment_components[k] && equipment_components[k].subtype == subtype:
			valid.push_back(k)
	if valid.size() > 0:
		components[0] = valid.pick_random()
	for i in range(1, num_components):
		components[i] = equipment_components.keys().pick_random()
	if randf() < 0.5 && EQUIPMENT_SUBTYPE_NAME.has(subtype):
		nm = tr(EQUIPMENT_SUBTYPE_NAME[subtype].pick_random().to_upper()).capitalize()
	elif EQUIPMENT_TYPE_NAME.has(slot):
		nm = tr(EQUIPMENT_TYPE_NAME[slot].pick_random().to_upper()).capitalize()
	item = create_random_equipment(type, components, region, {
		"type": slot,
		"name": nm,
	}, tier, quality_mod, quality_bonus)
	if slot == "weapon" && num_components >= 4:
		item["2h"] = true
	return item

func create_equipment(type: String, components: Array, material_list: Array, info:= {},
		quality_bonus:= 0) -> Dictionary:
	var item:= info.duplicate(true)
	var component_list:= []
	if item.has("name"):
		item.name = tr(item.name.to_upper()).capitalize()
	elif item.has("base_type"):
		item.name = tr(item.base_type.to_upper()).capitalize()
	else:
		item.name = tr(type.to_upper()).capitalize()
	item.type = type
	if info.has("base_type"):
		item.base_type = type
	elif item.has("name"):
		item.base_type = item.name
	elif info.has("type"):
		item.base_type = info.type
	else:
		item.base_type = type
	item.quality = 0
	item.price = 0
	item.enchantment_potential = randi_range(1, 4)
	for i in range(components.size()):
		var dict: Dictionary = equipment_components[components[i]]
		var mat: Dictionary = material_list[i]
		var quality: int = mat.quality + quality_bonus
		var mat_data:= {
			"name": mat.name.to_lower(),
			"attributes": {},
		}
		var comp_data:= {
			"name": tr(components[i].to_upper()),
			"material": mat_data,
			"attributes": {},
		}
		if comp_data.name.right(1) == 's' and comp_data.name.right(2) != "ss":
			comp_data.attributes.plural = comp_data.name
		else:
			comp_data.attributes.singular = comp_data.name
		if mat.name.right(1) == 's' and mat.name.right(2) != "ss":
			mat_data.attributes.plural = mat_data.name
		else:
			mat_data.attributes.singular = mat_data.name
		merge_dicts(item, dict, quality)
		if mat.has("add"):
			merge_dicts(item, mat.add)
		component_list.push_back(comp_data)
		item.quality += quality
		item.price += DEFAULT_MATERIAL_PRICE
	item.quality /= components.size()
	item.price *= (0.5 + 0.5 * float(item.quality) / 100.0 * float(item.quality) / 100.0)
	for i in range(material_list.size()):
		var mat: Dictionary = material_list[i]
		if not mat.has("mod"):
			continue
		for k in mat.mod.keys():
			if item.has(k):
				item[k] *= 1.0 + mat.mod[k]
	if EQUIPMENT_ATTRIBUTE_MULTIPLIER.has(type):
		var multiplier: float = EQUIPMENT_ATTRIBUTE_MULTIPLIER[type]
		for k in item.keys():
			if typeof(item[k]) == TYPE_FLOAT:
				item[k] = roundi(multiplier*item[k])
	else:
		for k in item.keys():
			if typeof(item[k]) == TYPE_FLOAT:
				item[k] = roundi(item[k])
	item.components = component_list
	item.erase("material")
	item.attributes = {}
	if item.name.right(1) == 's' and item.name.right(2) != "ss":
		item.attributes.plural = item.name.to_lower()
	else:
		item.attributes.singular = item.name.to_lower()
	if material_list.size()>0:
		var prefix: String = material_list.pick_random().name
		if ' ' in prefix:
			if randf()<0.667:
				prefix = prefix.left(prefix.find(' '))
			else:
				var l:= prefix.find(' ', prefix.find(' ') + 1)
				if l>0:
					prefix = prefix.left(l)
		item.name = prefix + " " + item.name
	item.name = sanitize_name(item.name)
	item.description = create_tooltip(item)
	item.description_plain = Skills.tooltip_remove_bb_code(item.description)
	item.story = create_description(item)
	item.component_description = create_component_tooltip(item)
	return item

func craft_equipment(type: String, material_list: Array, quality_bonus:= 0) -> Dictionary:
	var item: Dictionary
	var dict: Dictionary = equipment_recipes[type].duplicate(true)
	dict.base_type = type
	item = create_equipment(dict.type, dict.components, material_list, dict, quality_bonus)
	item.recipe = type
	item.source = tr("CRAFTED_ITEM")
	item.description = create_tooltip(item)
	item.description_plain = Skills.tooltip_remove_bb_code(item.description)
	item.story = create_description(item)
	item.component_description = create_component_tooltip(item)
	return item

func create_equipment_drop(creature: Dictionary) -> Dictionary:
	var item: Dictionary
	var quality:= 100
	var num_enchantments:= 0
	var recipe: String = equipment_recipes.keys().pick_random()
	if creature.has("equipment_quality"):
		quality *= creature.equipment_quality
	item = create_random_standard_equipment(recipe, Region.new({
		"level":creature.level,
		"tier":creature.tier,
		"local_materials":DEFAULT_MATERIALS,
	}), int(creature.tier * randf_range(0.25, 0.75) + randf_range(0.0, 0.5)), float(quality) / 100.0)
	item.recipe = recipe
	num_enchantments -= int(item.has("enchanted") && item.enchanted)
	if creature.has("equipment_enchantment_chance"):
		for i in range(3):
			if randf()<creature.equipment_enchantment_chance:
				num_enchantments += 1
	if num_enchantments > 0:
		for i in range(num_enchantments):
			var enchantment: String
			if randf() < 0.05:
				enchantment = Enchantment.enchantments_by_tier.curse.pick_random()
			else:
				enchantment = Enchantment.enchantments_by_tier.regular.pick_random()
			item = enchant_equipment(item, enchantment, int(quality * randf_range(0.75, 1.25)))
	item.source = Story.sanitize_string(tr("DROPPED_BY").format({
		"creature":creature.name,
	}))
	if "race" in creature:
		item.source_race = creature.race
	item.description = create_tooltip(item)
	item.description_plain = Skills.tooltip_remove_bb_code(item.description)
	item.story = create_description(item)
	item.component_description = create_component_tooltip(item)
	return item

func create_legendary_equipment(type: String, level: int, quality:= 150) -> Dictionary:
	var item: Dictionary
	var add_quality:= 0
	var creator: String
	var base_name: String
	if type not in equipment_recipes:
		type = equipment_recipes.keys().pick_random()
	item = create_random_standard_equipment(type, Region.new({
		"level": 10 + int(1.2 * level),
		"tier": 0,
		"local_materials": LEGENDARY_MATERIALS,
	}), 2, 1.5, add_quality)
	if type in LEGENDARY_ITEM_NAME && randf() < 0.75:
		base_name = LEGENDARY_ITEM_NAME[type].pick_random().capitalize()
	else:
		base_name = item.base_type.capitalize()
	item.recipe = type
	item.name = base_name
	item = enchant_equipment(item,
		Enchantment.enchantments_by_tier_and_slot.legendary.minor.pick_random(),
		quality + add_quality + 10 * level, "1")
	item = enchant_equipment(item,
		Enchantment.enchantments_by_tier_and_slot.legendary.greater.pick_random(),
		quality + add_quality + 10 * level, "2")
	item.enchantment_potential = 0
	item.legendary = true
	
	item.card_set = Description.create_description_data(item, 6)
	
	if randf() < 0.75:
		var prefixes:= []
		var suffixes:= []
		for card in item.card_set.values():
			if "prefix" in card.attributes:
				prefixes.append(card.attributes.prefix)
			if "suffix" in card.attributes:
				suffixes.append(card.attributes.suffix)
		
		item.name = base_name
		if prefixes.size() > 0:
			item.name = prefixes.pick_random() + " " + item.name
		if suffixes.size() > 0:
			item.name += " " + suffixes.pick_random()
	
	if randf() < 0.25:
		var rnd:= randf()
		var prefix: String = Names.PREFIX.pick_random().capitalize()
		var adjective: String
		var subject: String
		creator = Names.create_name("archmage", randi_range(-1, 1))
		if randf() < 0.333:
			prefix += "-" + Names.PREFIX.pick_random()
		adjective = prefix + Names.SUFFIX.pick_random()
		subject = prefix + Names.SUBJECT.pick_random()
		if rnd < 0.5:
			item.name = creator + "'s " + adjective + " " + base_name
		elif rnd < 0.75:
			item.name = adjective + " " + base_name + " " + tr("OF") + " " + creator
		else:
			item.name = base_name + " " + tr("OF") + " " + subject
		Description.add_card(item.card_set, Description.create_card("science", {
			"singular": subject.to_lower(),
			"adjective": adjective.to_lower(),
		}), Utils.get_closest_position(Vector2i(0, 0), item.card_set.keys()))
	else:
		creator = Names.create_name(Names.NAME_DATA.keys().pick_random(), randi_range(-1, 1))
	item.source = tr("ARTIFACT_BY_CREATOR").format({
		"creator": creator,
	})
	
	for pos in item.card_set:
		if item.card_set[pos].type == "craftmanship":
			#item.card_set.erase(pos)
			item.card_set[pos].attributes.singular = creator
	Description.add_card(item.card_set, Description.create_card("theme"),
	Utils.get_closest_position(Vector2i(0, 0), item.card_set.keys()))
	Description.add_card(item.card_set, Description.create_card("craftmanship", {
		"singular": creator,
		"adjective": ["legendary", "epic"].pick_random(),
		"adverb": ["legendaryly", "masterfully"].pick_random(),
		"is_name": true,
	}), Utils.get_closest_position(Vector2i(0, 0), item.card_set.keys()))
	
	item.description = create_tooltip(item)
	item.description_plain = Skills.tooltip_remove_bb_code(item.description)
	item.story = create_description(item)
	item.component_description = create_component_tooltip(item)
	return item

func create_material_drop(type: String, creature: Dictionary, add_data:= {}) -> Dictionary:
	var material: Dictionary = materials[type].duplicate(true)
	var quality:= get_creature_quality(creature)
	if !creature.has("name_prefix"):
		creature.name_prefix = creature.base_name
	material.type = "material"
	if is_vegan && material.has("veggie_name"):
		material.name = sanitize_name(material.veggie_name.pick_random().format(creature)).capitalize()
	else:
		material.name = sanitize_name(material.name.pick_random().format(creature)).capitalize()
	if material.has("quality"):
		material.quality *= quality
	else:
		material.quality = quality
	if material.has("add"):
		merge_dicts(material.add, add_data)
	else:
		material.add = add_data.duplicate(true)
	for k in material.add.keys():
		match typeof(material.add[k]):
			TYPE_FLOAT:
				material.add[k] *= float(quality) / 100.0
			TYPE_INT:
				material.add[k] = int(material.add[k] * quality / 100)
			TYPE_DICTIONARY:
				if k in ["damage", "resistance"]:
					continue
				for c in material.add[k].keys():
					material.add[k][c] *= float(quality) / 100.0
	material.price = int(ceil(material.price*(0.5 +
		float(quality) / 100.0 * float(quality) / 100.0) + 0.25 * float(material.add.size() > 0)))
	material.source = Story.sanitize_string(tr("DROPPED_BY").format({
		"creature":creature.name,
	}))
	material.description = create_tooltip(material)
	material.description_plain = Skills.tooltip_remove_bb_code(material.description)
	material.erase("veggie_name")
	return material

func create_regional_material(type: String, region: Region, quality_mod:= 1.0) -> Dictionary:
	var material: Dictionary = materials[type].duplicate(true)
	var quality: int
	var named:= false
	var base_mat:= {}
	quality = int(get_creature_quality({
		"level":region.level,
		"tier":region.tier + randi_range(-1, 1),
	}) * quality_mod)
	material.type = "material"
	if material.has("quality"):
		quality *= material.quality
	for k in region.local_materials.keys():
		if k in material.tags:
			base_mat = region.local_materials[k].pick_random()
			break
	if base_mat.size()==0:
		for k in DEFAULT_MATERIALS.keys():
			if k in material.tags:
				base_mat = DEFAULT_MATERIALS[k].pick_random()
				break
	if base_mat.size()>0:
		quality *= base_mat.quality
		material.name = sanitize_name(material.name.pick_random().format({
			"base_name":base_mat.name,
			"name_prefix":base_mat.name,
		})).capitalize()
		if base_mat.has("mod"):
			if material.has("mod"):
				material.mod = merge_dicts(material.mod, base_mat.mod.duplicate(true))
			else:
				material.mod = base_mat.mod.duplicate(true)
		if base_mat.has("add"):
			if material.has("add"):
				material.add = merge_dicts(material.add, base_mat.add.duplicate(true))
			else:
				material.add = base_mat.add.duplicate(true)
		named = true
	if material.has("add"):
		for s in material.add.keys():
			if typeof(material.add[s]) == TYPE_INT:
				material.add[s] = int(material.add[s]*quality/100)
			elif typeof(material.add[s]) == TYPE_FLOAT:
				material.add[s] *= float(quality) / 100.0
	
	if !named:
		var dict: Dictionary = DEFAULT_MATERIAL_TYPES.pick_random()
		material.name = sanitize_name(material.name.pick_random().format({
			"base_name": dict.name,
			"name_prefix": dict.name,
		})).capitalize()
	material.price = int(material.price * (0.5 +
		0.5*float(quality) / 100.0 * float(quality) / 100.0))
	material.quality = quality
	material.description = create_tooltip(material)
	material.description_plain = Skills.tooltip_remove_bb_code(material.description)
	return material

func create_soul_stone_drop(creature: Dictionary) -> Dictionary:
	var tier: int = min(creature.soul_rarity + randi_range(-1, 1) + 2, SOUL_STONES.size())
	var type: String = SOUL_STONES[tier]
	return create_material_drop(type, creature, creature.soul_add)


func enchant_equipment_material(item: Dictionary, enchantment_type: String, material_list: Array,
		quality_bonus:= 0, enchantment_slot:= "") -> Dictionary:
	var add_data:= {}
	for material in material_list:
		if material.has("add"):
			merge_dicts(add_data, material.add)
	return enchant_equipment(item, enchantment_type,
		get_material_quality(material_list) + quality_bonus, enchantment_slot, add_data)

func enchant_equipment(item: Dictionary, enchantment_type: String, quality: int,
		enchantment_slot:= "", add_data:= {}) -> Dictionary:
	var dict: Dictionary = Enchantment.enchantments[enchantment_type].duplicate(true)
	var scale:= float(quality) / 100.0
	var total_quality:= quality
	var slot: String = dict.slot + enchantment_slot
	merge_dicts(dict, add_data)
	if "enchantments" in item && item.enchantments.has(slot):
		if item.enchantments[slot].quality > quality:
			return item
		quality -= item.enchantments[slot].quality
		scale -= float(item.enchantments[slot].quality) / 100.0
	for k in ATTRIBUTES:
		if dict.has(k):
			var value: int
			if k == "speed":
				value = ceil(max(dict[k], 0.0))
			else:
				value = ceil(max(dict[k] * scale, 0.0))
			if item.has(k):
				item[k] += value
			else:
				item[k] = value
	for k in Characters.DEFAULT_STATS.keys():
		if dict.has(k):
			var value: int = ceil(max(dict[k] * scale, 0.0))
			if item.has(k):
				item[k] += value
			else:
				item[k] = value
	for k in Characters.RESOURCES:
		if dict.has(k):
			if item.has(k):
				item[k] += int(ceil(max(dict[k] * scale, 0.0)))
			else:
				item[k] = int(ceil(max(dict[k] * scale, 0.0)))
		if dict.has(k + "_regen"):
			if item.has(k + "_regen"):
				item[k + "_regen"] += int(ceil(dict[k + "_regen"] * scale))
			else:
				item[k+"_regen"] = int(ceil(dict[k + "_regen"] * scale))
	if dict.has("damage"):
		if item.has("damage"):
			for k in dict.damage.keys():
				if item.damage.has(k):
					item.damage[k] += dict.damage[k] * (sqrt(1.0 + scale) - 1.0)
				else:
					item.damage[k] = dict.damage[k] * (sqrt(1.0 + scale) - 1.0)
		else:
			item.damage = {}
			for k in dict.damage.keys():
				item.damage[k] = dict.damage[k] * scale
	if dict.has("resistance"):
		if item.has("resistance"):
			for k in dict.resistance.keys():
				if item.resistance.has(k):
					item.resistance[k] += dict.resistance[k] * (sqrt(1.0 + scale) - 1.0)
				else:
					item.resistance[k] = dict.resistance[k] * (sqrt(1.0 + scale) - 1.0)
		else:
			item.resistance = {}
			for k in dict.resistance.keys():
				item.resistance[k] = dict.resistance[k] * scale
	if item.name.length() < 25:
		if dict.has("prefix"):
			var prefix = dict.prefix.pick_random()
			if typeof(prefix) == TYPE_ARRAY:
				var text:= ""
				for list in prefix:
					text += list.pick_random()
				item.name = text + " " + item.name
			else:
				item.name = str(prefix) + " " + item.name
		elif dict.has("suffix"):
			var suffix = dict.suffix.pick_random()
			if typeof(suffix) == TYPE_ARRAY:
				var text:= ""
				for list in suffix:
					text += list.pick_random()
				item.name = item.name + " " + text
			else:
				item.name = item.name + " " + str(suffix)
	item.price += int(ceil(dict.price*(0.75 +
		0.25 * float(quality) / 100.0 * float(quality) / 100.0)))
	item.quality = (item.quality + total_quality) / 2.0
	item.enchanted = true
	if !item.has("enchantments"):
		item.enchantments = {}
	item.enchantments[slot] = {
		"type":enchantment_type,
		"quality":total_quality,
	}
	if "enchantment_potential" in item:
		item.enchantment_potential -= 1
	else:
		item.enchantment_potential = 0
	item.description = create_tooltip(item)
	item.description_plain = Skills.tooltip_remove_bb_code(item.description)
	item.story = create_description(item)
	item.component_description = create_component_tooltip(item)
	return item


func craft_potion(type: String, material_list: Array, quality_bonus:= 0) -> Dictionary:
	var item:= create_potion(type, material_list.pick_random().name,
		get_material_quality(material_list) + quality_bonus)
	item.source = tr("MADE_OUT_OF").format({
		"items":make_list(material_list),
	})
	item.description = create_tooltip(item)
	item.description_plain = Skills.tooltip_remove_bb_code(item.description)
	return item

func create_potion(type: String, name_prefix: String, quality: int) -> Dictionary:
	var dict: Dictionary = potion_recipes[type]
	var item:= {
		"name":sanitize_name(name_prefix + " " + dict.name).capitalize(),
		"type":dict.type,
		"effect":dict.effect,
		"quality":quality,
		"source":tr("UNKNOWN_ORIGIN"),
	}
	var scale:= float(quality) / 100.0
	for k in dict.keys():
		if typeof(dict[k]) == TYPE_INT:
			item[k] = int(ceil(scale * dict[k]))
		elif typeof(dict[k]) == TYPE_FLOAT:
			item[k] = scale * dict[k]
	if dict.has("status"):
		item.status = dict.status.duplicate(true)
		for k in item.status.keys():
			if typeof(item.status[k]) == TYPE_INT:
				item.status[k] = int(ceil(scale * item.status[k]))
			elif typeof(item.status[k]) == TYPE_FLOAT:
				item.status[k] = scale * item.status[k]
	item.price = int(potion_recipes[type].price * (0.5 +
		0.5 * float(quality) / 100.0 * float(quality) / 100.0))
	return item


func cook(type: String, material_list: Array, quality_bonus:= 0) -> Dictionary:
	var item:= create_food(type, material_list.pick_random().name,
		get_material_quality(material_list) + quality_bonus)
	item.description = create_tooltip(item)
	item.description_plain = Skills.tooltip_remove_bb_code(item.description)
	return item

func create_food(type: String, name_prefix: String, quality: int) -> Dictionary:
	var dict: Dictionary = food_recipes[type]
	var item:= {
		"name": sanitize_name(name_prefix + " " + dict.name).capitalize(),
		"type": dict.type,
		"quality": quality,
	}
	var scale:= float(quality) / 100.0
	for k in dict.keys():
		if typeof(dict[k]) == TYPE_INT:
			item[k] = int(ceil(scale * dict[k]))
		elif typeof(dict[k]) == TYPE_FLOAT:
			item[k] = scale * dict[k]
	if dict.has("status"):
		item.status = dict.status.duplicate(true)
		for k in item.status.keys():
			if k == "duration":
				continue
			if typeof(item.status[k]) == TYPE_INT:
				item.status[k] = int(ceil(scale * item.status[k]))
			elif typeof(item.status[k]) == TYPE_FLOAT:
				item.status[k] = scale * item.status[k]
	item.price = int(food_recipes[type].price * (0.5 +
		0.5 * float(quality) / 100.0 * float(quality) / 100.0))
	item.description = create_tooltip(item)
	item.description_plain = Skills.tooltip_remove_bb_code(item.description)
	return item


func sanitize_name(string: String) -> String:
	string.replace("{", "").replace("}", "")
	for s in string.split(" ", false):
		while string.find(s) != string.rfind(s):
			var pos:= string.find(s)
			var pos2:= string.find(s, pos + s.length())
			string = string.substr(0, pos) + s + string.substr(pos2 + s.length())
	return string


func load_material_data(path: String):
	for file_name in Utils.get_file_paths(path):
		var file:= FileAccess.open(file_name, FileAccess.READ)
		var error:= FileAccess.get_open_error()
		if error != OK:
			print("Can't open file " + file_name + "!")
			continue
		else:
			print("Loading material " + file_name + '.')
		
		var raw:= file.get_as_text()
		var dict: Dictionary = JSON.parse_string(raw)
		if dict == null || dict.size() == 0:
			printt("Error parsing " + file_name + "!")
			continue
		for key in dict:
			materials[key] = dict[key]
		file.close()

func load_component_data(path: String):
	for file_name in Utils.get_file_paths(path):
		var file:= FileAccess.open(file_name, FileAccess.READ)
		var error:= FileAccess.get_open_error()
		if error != OK:
			print("Can't open file " + file_name + "!")
			continue
		else:
			print("Loading component " + file_name + '.')
		
		var raw:= file.get_as_text()
		var dict: Dictionary = JSON.parse_string(raw)
		if dict == null || dict.size() == 0:
			printt("Error parsing " + file_name + "!")
			continue
		for key in dict:
			equipment_components[key] = dict[key]
		file.close()

func load_recipe_data(path: String):
	for file_name in Utils.get_file_paths(path):
		var file:= FileAccess.open(file_name, FileAccess.READ)
		var error:= FileAccess.get_open_error()
		if error != OK:
			print("Can't open file " + file_name + "!")
			continue
		else:
			print("Loading crafting recipe " + file_name + '.')
		
		var raw:= file.get_as_text()
		var dict: Dictionary = JSON.parse_string(raw)
		if dict == null || dict.size() == 0:
			printt("Error parsing " + file_name + "!")
			continue
		for key in dict:
			equipment_recipes[key] = dict[key]
		file.close()

func load_potion_data(path: String):
	for file_name in Utils.get_file_paths(path):
		var file:= FileAccess.open(file_name, FileAccess.READ)
		var error:= FileAccess.get_open_error()
		if error != OK:
			print("Can't open file " + file_name + "!")
			continue
		else:
			print("Loading potion " + file_name + '.')
		
		var raw:= file.get_as_text()
		var dict: Dictionary = JSON.parse_string(raw)
		if dict == null || dict.size() == 0:
			printt("Error parsing " + file_name + "!")
			continue
		for key in dict:
			potion_recipes[key] = dict[key]
		file.close()

func load_food_data(path: String):
	for file_name in Utils.get_file_paths(path):
		var file:= FileAccess.open(file_name, FileAccess.READ)
		var error:= FileAccess.get_open_error()
		if error != OK:
			print("Can't open file " + file_name + "!")
			continue
		else:
			print("Loading cooking recipe " + file_name + '.')
		
		var raw:= file.get_as_text()
		var dict: Dictionary = JSON.parse_string(raw)
		if dict == null || dict.size() == 0:
			printt("Error parsing " + file_name + "!")
			continue
		for key in dict:
			food_recipes[key] = dict[key]
		file.close()

func _ready():
	load_material_data("res://data/materials")
	load_component_data("res://data/items/components")
	load_recipe_data("res://data/items/recipes")
	load_potion_data("res://data/items/potions")
	load_food_data("res://data/items/food")
