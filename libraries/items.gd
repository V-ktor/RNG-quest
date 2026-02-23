extends Node

const ATTRIBUTES: Array[String] = [
	"attack", "magic", "willpower", "accuracy", "armour", "evasion",
	"penetration", "speed", "critical",
]
const RANK_COLORS: Array[Color] = [
	Color(0.6,0.6,0.6),
	Color(1.0,1.0,1.0),
	Color(0.3,1.0,0.2),
	Color(0.2,0.6,1.0),
	Color(1.0,1.0,0.2),
	Color(0.6,0.2,1.0),
	Color(0.6,0.5,0.1),
]
const EQUIPMENT_ATTRIBUTE_MULTIPLIER: Dictionary[String, float] = {
	"weapon": 1.5,
	"belt": 0.75,
	"amulet": 0.5,
	"ring": 0.5,
	"earring": 0.5,
	"bracelet": 0.5,
}
const EQUIPMENT_TYPE_NAME: Dictionary[String, Array] = {
	"weapon": [
		"weapon",
		"tool",
	],
	"torso": [
		"armour",
		"clothing",
		"chest",
		"harness",
	],
	"legs": [
		"pants",
		"greaves",
	],
	"head": [
		"hat",
		"helmet",
	],
	"hands": [
		"gloves",
	],
	"feet": [
		"boots",
	],
	"belt": [
		"belt",
	],
	"cape": [
		"cape",
		"cloak",
	],
	"amulet": [
		"amulet",
		"pendant",
	],
	"ring": [
		"ring",
	],
	"earring": [
		"earring",
	],
	"bracelet": [
		"bracelet",
	],
}
const EQUIPMENT_SUBTYPE_NAME: Dictionary[String, Array] = {
	"melee": [
		"basher",
		"smasher",
		"cutter",
		"piercer",
	],
	"ranged": [
		"thrower",
		"shooter",
		"projector",
		"launcher",
	],
	"magic": [
		"catalyst",
		"amplifier",
		"infuser",
		"artifact",
	],
}
const LEGENDARY_ITEM_NAME: Dictionary[String, Array] = {
	"dagger": [
		"knife",
		"scalpel",
		"shard",
	],
	"rapier": [
		"needle",
		"piercer",
	],
	"short_sword": [
		"blade",
		"razor",
	],
	"long_sword": [
		"edge",
		"cutlass",
		"saber",
	],
	"hand_axe": [
		"cleaver",
		"cutter",
	],
	"mace": [
		"club",
		"morning star",
		"pickle",
	],
	"greatsword": [
		"cutter",
		"obliterator",
		"bastard sword",
	],
	"greatmaul": [
		"maul",
		"obliterator",
		"basher",
		"trasher",
	],
	"battleaxe": [
		"feller",
		"waraxe",
	],
	"scythe": [
		"harvester",
	],
	"spear": [
		"pole",
		"lance",
		"spire",
	],
	"staff": [
		"rod",
		"sceptre",
		"spire",
	],
	"tome": [
		"grimoire",
		"spell book",
		"encyclopedia",
	],
	"orb": [
		"heartstone",
		"shard",
		"eye",
		"singularity",
	],
	"amplifier": [
		"aether core",
		"catalyst",
	],
	"blowgun": [
		"dart launcher",
		"needle thrower",
	],
	"pistol": [
		"blaster",
		"gun",
		"sidearm",
	],
	"bow": [
		"long bow",
		"war bow",
	],
	"crossbow": [
		"ballista",
		"arbalest",
	],
	"blunderbuss": [
		"shotgun",
		"rifle",
		"cannon",
	],
	"buckler": [
		"shield",
		"deflector",
	],
	"kite_shield": [
		"protector",
		"guard",
	],
	"tower_shield": [
		"protector",
		"tower",
	],
	"cloth_shirt": [
		"robe",
		"clothing",
	],
	"leather_chest": [
		"skin",
		"hide",
	],
	"chain_cuirass": [
		"scales",
		"scale male",
	],
	"plate_cuirass": [
		"harness",
		"cage",
	],
	"leather_gloves": [
		"fists",
		"wraps",
	],
	"chain_gauntlets": [
		"fists",
		"grip",
	],
	"cloth_hat": [
		"hat",
		"headband",
	],
	"leather_hat": [
		"hat",
		"cap",
	],
	"chain_coif": [
		"crown",
	],
	"plate_helm": [
		"helmet",
		"visor",
	],
	"cloth_sandals": [
		"sandals",
		"walker",
	],
	"leather_boots": [
		"boots",
		"walker",
	],
	"belt": [
		"girdle",
	],
	"cape": [
		"wrap",
		"cloak",
		"mantle",
	],
	"ring": [
		"circle",
		"jewel",
	],
	"amulet": [
		"pendant",
		"jewel",
	],
}
const DEFAULT_MATERIAL_PRICE := 10
const DEFAULT_MATERIAL_TYPES: Array[Dictionary] = [
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
const DEFAULT_MATERIALS: Dictionary[String, Array] = {
	"wood": [
		{
			"name": "pine",
			"quality": 0.75,
		},
		{
			"name": "cedar",
			"quality": 0.75,
		},
		{
			"name": "maple",
			"quality": 1.0,
		},
		{
			"name": "bamboo",
			"quality": 1.0,
		},
		{
			"name": "birch",
			"quality": 1.25,
		},
		{
			"name": "oak",
			"quality": 1.25,
		},
	],
	"paper": [
		{
			"name": "rough",
			"quality": 0.75,
		},
		{
			"name": "bleached",
			"quality": 1.0,
		},
		{
			"name": "common",
			"quality": 1.0,
		},
		{
			"name": "infused",
			"quality": 1.25,
		},
	],
	"cloth": [
		{
			"name": "wool",
			"quality": 0.75,
		},
		{
			"name": "polyester",
			"quality": 0.75,
		},
		{
			"name": "linen",
			"quality": 1.0,
		},
		{
			"name": "cotton",
			"quality": 1.0,
		},
		{
			"name": "velvet",
			"quality": 1.25,
		},
		{
			"name": "silk",
			"quality": 1.25,
		},
	],
	"leather": [
		{
			"name": "rough",
			"quality": 0.75,
		},
		{
			"name": "worn down",
			"quality": 0.75,
		},
		{
			"name": "reinforced",
			"quality": 1.0,
		},
		{
			"name": "wolf skin",
			"quality": 1.0,
		},
		{
			"name": "bear skin",
			"quality": 1.25,
		},
		{
			"name": "troll hide",
			"quality": 1.25,
		},
	],
	"metal": [
		{
			"name": "tin",
			"quality": 0.75,
		},
		{
			"name": "copper",
			"quality": 0.75,
		},
		{
			"name": "bronze",
			"quality": 1.0,
		},
		{
			"name": "iron",
			"quality": 1.0,
		},
		{
			"name": "steel",
			"quality": 1.25,
		},
		{
			"name": "silver",
			"quality": 1.25,
		},
	],
	"stone": [
		{
			"name": "clay",
			"quality": 0.75,
		},
		{
			"name": "graphite",
			"quality": 0.75,
		},
		{
			"name": "quartz",
			"quality": 1.0,
		},
		{
			"name": "sand stone",
			"quality": 1.0,
		},
		{
			"name": "granite",
			"quality": 1.25,
		},
		{
			"name": "basalt",
			"quality": 1.25,
		},
	],
	"gem": [
		{
			"name": "quartz",
			"quality": 0.75,
		},
		{
			"name": "peridot",
			"quality": 0.75,
		},
		{
			"name": "turquoise",
			"quality": 0.75,
		},
		{
			"name": "glass",
			"quality": 0.75,
		},
		{
			"name": "agate",
			"quality": 1.0,
		},
		{
			"name": "emerald",
			"quality": 1.0,
		},
		{
			"name": "amber",
			"quality": 1.0,
		},
		{
			"name": "lapis lazuli",
			"quality": 1.0,
		},
		{
			"name": "garnet",
			"quality": 1.25,
		},
		{
			"name": "hematite",
			"quality": 1.25,
		},
		{
			"name": "ruby",
			"quality": 1.25,
		},
		{
			"name": "sapphire",
			"quality": 1.25,
		},
	],
	"bone": [
		{
			"name": "withered",
			"quality": 0.75,
		},
		{
			"name": "beast",
			"quality": 1.0,
		},
		{
			"name": "tiger",
			"quality": 1.25,
		},
	],
	"soul": [
		{
			"name": "fleeting",
			"quality": 0.75,
		},
		{
			"name": "unremarkable",
			"quality": 1.0,
		},
		{
			"name": "greater",
			"quality": 1.25,
		},
	],
}
const LEGENDARY_MATERIALS: Dictionary[String, Array] = {
	"wood": [
		{
			"name": "redwood",
			"quality": 1.0,
			"add": {
				"attack": 0.5,
				"penetration": 0.75,
			},
		},
		{
			"name": "blackwood",
			"quality": 1.0,
			"add": {
				"accuracy": 0.5,
				"evasion": 0.5,
			},
		},
		{
			"name": "whitewood",
			"quality": 1.0,
			"add": {
				"health": 5,
				"stamina": 2.5,
				"mana": 2.5,
			},
		},
		{
			"name": "steelwood",
			"quality": 1.0,
			"add": {
				"armour": 1,
			},
		},
	],
	"paper": [
		{
			"name": "forgotten beast",
			"quality": 1.0,
			"add": {
				"willpower": 1,
			},
		},
		{
			"name": "ancient beast",
			"quality": 1.0,
			"add": {
				"magic": 0.5,
				"accuracy": 0.5,
			},
		},
		{
			"name": "aether infused",
			"quality": 1.0,
			"add": {
				"mana": 2.5,
				"mana_regen": 1.5,
			},
		},
	],
	"cloth":[
		{
			"name": "aramid",
			"quality": 1.0,
			"add": {
				"resistance": {
					"piercing": 0.025,
					"fire": 0.025,
					"light": 0.025,
				},
			},
		},
		{
			"name": "ancient beast fur",
			"quality": 1.0,
			"add": {
				"resistance": {
					"cutting": 0.025,
					"ice": 0.025,
					"water": 0.025,
				},
			},
		},
		{
			"name": "exquisite velvet",
			"quality": 1.0,
			"add": {
				"willpower": 0.5,
				"evasion": 0.5,
			},
		},
		{
			"name": "resilient silk",
			"quality": 1.0,
			"add": {
				"willpower": 0.5,
				"armour": 0.5,
			},
		},
	],
	"leather": [
		{
			"name": "infused troll",
			"quality": 1.0,
			"add": {
				"health_regen": 2.5,
			},
		},
		{
			"name": "ancient beast",
			"quality": 1.0,
			"add": {
				"armour": 0.5,
				"accuracy": 0.5,
			},
		},
		{
			"name": "forgotten beast",
			"quality": 1.0,
			"add": {
				"armour": 0.5,
				"evasion": 0.5,
			},
		},
	],
	"metal": [
		{
			"name": "mithril",
			"quality": 1.0,
			"add": {
				"accuracy": 0.5,
				"evasion": 0.5,
			},
		},
		{
			"name": "black steel",
			"quality": 1.0,
			"add": {
				"attack": 0.5,
				"penetration": 0.75,
			},
		},
		{
			"name": "quicksilver",
			"quality": 0.95,
			"add": {
				"speed": 0.5,
			},
		},
	],
	"stone": [
		{
			"name": "granite",
			"quality": 1.0,
			"add": {
				"resistance": {
					"cutting": 0.02,
					"piercing": 0.02,
					"impact": 0.02,
				},
			},
		},
		{
			"name": "basalt",
			"quality": 1.0,
			"add": {
				"attack": 1,
			},
		},
		{
			"name": "marble",
			"quality": 1.0,
			"add": {
				"magic": 0.5,
				"mana_regen": 1.5,
			},
		},
	],
	"gem": [
		{
			"name": "pure diamond",
			"quality": 1.0,
			"add": {
				"magic": 1,
			},
		},
		{
			"name": "star saphire",
			"quality": 1.0,
			"add": {
				"magic": 0.5,
				"willpower": 0.5,
			},
		},
		{
			"name": "blood ruby",
			"quality": 1.0,
			"add": {
				"health": 2.5,
				"health_regen": 1,
			},
		},
	],
	"bone": [
		{
			"name": "ancient beast",
			"quality": 1.0,
			"add": {
				"resitance": {
					"impact": 0.02,
					"cutting": 0.02,
					"piercing": 0.02,
				},
			},
		},
		{
			"name": "ancient beast",
			"quality": 1.0,
			"add": {
				"damage": {
					"impact": 0.015,
					"cutting": 0.015,
					"piercing": 0.015,
				},
			},
		},
	],
}
const SOUL_STONES: Array[String] = [
	"soul_splinter", "soul_shard", "soul_stone", "soul_gem", "soul_jewel", "soul_orb"
]

var is_vegan:= false
var materials: Dictionary[String, Dictionary] = {}
var equipment_components: Dictionary[String, Dictionary] = {}
var equipment_recipes: Dictionary[String, Dictionary] = {}
var potion_recipes: Dictionary[String, Dictionary] = {}
var food_recipes: Dictionary[String, Dictionary] = {}

@onready
var Description:= $Description as ItemDescription
@onready
var Enchantment:= $Enchantment as ItemEnchantment


func pick_random_equipment(type: String) -> String:
	var valid:= []
	for k in equipment_recipes:
		if equipment_recipes[k].type == type:
			valid.push_back(k)
	if valid.size() > 0:
		return valid.pick_random()
	return ""


func get_material_quality(material_list: Array[ItemMaterial]) -> int:
	var quality:= 0.0
	for mat in material_list:
		quality += mat.quality
	quality /= material_list.size()
	return floori(quality)

func get_creature_quality(creature: Dictionary) -> int:
	var quality: int
	var tier_multiplier:= 1.0
	var level_multiplier: float = 1.0 + 0.1 * (creature.level - 1)
	if creature.tier < 0:
		tier_multiplier = 1.0 / sqrt(-2.0 * float(creature.tier))
	elif creature.tier > 0:
		tier_multiplier = sqrt(2.0 * float(creature.tier))
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


func merge_dicts(dict: Dictionary, add: Dictionary, multiplier:= 1.0) -> Dictionary:
	for k: String in add:
		if k!="speed" && (typeof(add) == TYPE_INT || typeof(add) == TYPE_FLOAT):
			add[k] *= multiplier
		if dict.has(k):
			if typeof(dict[k]) == TYPE_STRING:
				dict[k] = [dict[k], add[k]]
			elif typeof(add[k]) == TYPE_DICTIONARY:
				merge_dicts(dict[k] as Dictionary, add[k] as Dictionary, multiplier)
			else:
				if typeof(dict[k]) == TYPE_ARRAY && typeof(add[k]) != TYPE_ARRAY:
					dict[k].push_back(add[k])
				else:
					dict[k] += add[k]
		else:
			dict[k] = add[k]
	return dict

func pick_random_material(type: String) -> String:
	var valid:= []
	for k in materials:
		if type in materials[k].tags:
			valid.push_back(k)
	if valid.size() > 0:
		return valid.pick_random()
	return materials.keys().pick_random()

func create_material_list(components: Array[String]) -> Array[Array]:
	var array: Array[Array] = []
	for type in components:
		array.push_back(equipment_components[type].material)
	return array

func create_random_materials(list: Array, region: Region, quality_mod:= 1.0) -> Array[ItemMaterial]:
	var material_list: Array[ItemMaterial] = []
	for array: Array in list:
		var type: String = array.pick_random()
		material_list.push_back(create_regional_material(pick_random_material(type),
			region, quality_mod))
	return material_list

func create_random_equipment(type: String, components: Array[String], region: Region,
		info:= {}, tier:= 0, quality_mod:= 1.0, quality_bonus:= 0) -> ItemEquipment:
	var item: ItemEquipment
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
			item.name += tr((info.get("name", "") as String).to_upper()).capitalize()
		elif info.has("type"):
			item.name += tr((info.get("type", "") as String).to_upper()).capitalize()
		else:
			item.name += tr(type.to_upper()).capitalize()
	elif tier>=2:
		item.name = item.name.split(' ')[0] + " " + tr("PROTO").capitalize() + " "
		if info.has("name"):
			item.name += tr((info.get("name", "") as String).to_upper()).capitalize()
		elif info.has("type"):
			item.name += tr((info.get("type", "") as String).to_upper()).capitalize()
		else:
			item.name += tr(type.to_upper()).capitalize()
	return item

func create_random_standard_equipment(type: String, region: Region, tier:= 0,
		quality_mod:= 1.0, quality_bonus:= 0) -> ItemEquipment:
	var item: ItemEquipment
	var dict: Dictionary = equipment_recipes[type].duplicate(true)
	dict.base_type = type
	item = create_random_equipment(
		dict.type as String,
		Array(dict.components as Array, TYPE_STRING, "", null),
		region,
		dict,
		tier,
		quality_mod,
		quality_bonus,
	)
	item.recipe = type
	return item

func create_randomized_equipment(type: String, slot: String, subtype: String, num_components: int,
		region: Region, tier:= 0, quality_mod:= 1.0, quality_bonus:= 0) -> ItemEquipment:
	var item: ItemEquipment
	var valid:= []
	var components:= []
	var nm: String
	components.resize(num_components)
	for k in equipment_components:
		if "subtype" in equipment_components[k] && equipment_components[k].subtype == subtype:
			valid.push_back(k)
	if valid.size() > 0:
		components[0] = valid.pick_random()
	for i in range(1, num_components):
		components[i] = equipment_components.keys().pick_random()
	if randf() < 0.5 && subtype in EQUIPMENT_SUBTYPE_NAME:
		nm = tr((EQUIPMENT_SUBTYPE_NAME[subtype].pick_random() as String).to_upper()).capitalize()
	elif EQUIPMENT_TYPE_NAME.has(slot):
		nm = tr((EQUIPMENT_TYPE_NAME[slot].pick_random() as String).to_upper()).capitalize()
	item = create_random_equipment(type, components, region, {
		"type": slot,
		"name": nm,
	}, tier, quality_mod, quality_bonus)
	if slot == "weapon" && num_components >= 4:
		item["2h"] = true
	return item

func create_equipment(type: String, components: Array[String], material_list: Array[ItemMaterial], info:= {},
		quality_bonus:= 0) -> ItemEquipment:
	var item: ItemEquipment
	var item_data := info.duplicate(true)
	var component_list := []
	if item_data.has("name"):
		item_data.name = tr((item_data.get("name", "") as String).to_upper()).capitalize()
	elif item_data.has("base_type"):
		item_data.name = tr((item_data.get("base_type", "") as String).to_upper()).capitalize()
	else:
		item_data.name = tr(type.to_upper()).capitalize()
	item_data.type = type
	if info.has("base_type"):
		item_data.base_type = type
	elif item_data.has("name"):
		item_data.base_type = item_data.name
	elif info.has("type"):
		item_data.base_type = item_data.type
	else:
		item_data.base_type = type
	item_data.quality = 0
	item_data.price = 0
	item_data.enchantment_potential = randi_range(1, 4)
	for i in range(components.size()):
		var dict: Dictionary = equipment_components[components[i]]
		var mat := material_list[i]
		var quality := mat.quality + quality_bonus
		var mat_data := {
			"name": mat.name.to_lower(),
			"properties": {},
		}
		var comp_data := {
			"name": tr(components[i].to_upper()),
			"material": mat_data,
			"properties": {},
		}
		if (comp_data.name as String).right(1) == 's' and (comp_data.name as String).right(2) != "ss":
			comp_data.properties.plural = comp_data.name
		else:
			comp_data.properties.singular = comp_data.name
		if mat.name.right(1) == 's' and mat.name.right(2) != "ss":
			mat_data.properties.plural = mat_data.name
		else:
			mat_data.properties.singular = mat_data.name
		merge_dicts(item_data, dict, quality)
		if mat.add.size() > 0:
			merge_dicts(item_data, mat.add)
		component_list.push_back(comp_data)
		item_data.quality += quality
		item_data.price += DEFAULT_MATERIAL_PRICE
	item_data.quality /= maxf(components.size(), 1.0)
	item_data.price *= (0.5 + 0.5 * (item_data.quality as float) / 100.0 * (item_data.quality as float) / 100.0)
	for i in range(material_list.size()):
		var mat := material_list[i]
		if not mat.mod.size() > 0:
			continue
		for k: String in mat.mod:
			if item_data.has(k):
				item_data[k] *= 1.0 + mat.mod[k]
	if EQUIPMENT_ATTRIBUTE_MULTIPLIER.has(type):
		var multiplier: float = EQUIPMENT_ATTRIBUTE_MULTIPLIER[type]
		for k: String in item_data:
			if typeof(item_data[k]) == TYPE_FLOAT:
				item_data[k] = roundi(multiplier * (item_data.get(k, 0.0) as float))
	else:
		for k: String in item_data:
			if typeof(item_data[k]) == TYPE_FLOAT:
				item_data[k] = roundi(item_data.get(k, 0.0) as float)
	item_data.components = component_list
	item_data.erase("material")
	item_data.properties = {}
	if (item_data.name as String).right(1) == 's' and (item_data.name as String).right(2) != "ss":
		item_data.properties.plural = (item_data.name as String).to_lower()
	else:
		item_data.properties.singular = (item_data.name as String).to_lower()
	if "subtype" in item_data and typeof(item_data.subtype) != TYPE_ARRAY:
		item_data.subtype = [item_data.subtype]
	if material_list.size()>0:
		var prefix: String = material_list.pick_random().name
		if ' ' in prefix:
			if randf()<0.667:
				prefix = prefix.left(prefix.find(' '))
			else:
				var l:= prefix.find(' ', prefix.find(' ') + 1)
				if l>0:
					prefix = prefix.left(l)
		item_data.name = prefix + " " + item_data.name
	item_data.name = sanitize_name(item_data.name as String)
	item = ItemEquipment.new(item_data)
	item.description = item.create_tooltip()
	item.story = item.create_description()
	item.component_description = item.create_component_tooltip()
	return item

func craft_equipment(type: String, material_list: Array, quality_bonus:= 0) -> ItemEquipment:
	var item: ItemEquipment
	var dict: Dictionary = equipment_recipes[type].duplicate(true)
	dict.base_type = type
	item = create_equipment(
		dict.type as String,
		Array(dict.components as Array, TYPE_STRING, "", null),
		material_list,
		dict,
		quality_bonus,
	)
	item.recipe = type
	item.source = tr("CRAFTED_ITEM")
	item.description = item.create_tooltip()
	item.story = item.create_description()
	item.component_description = item.create_component_tooltip()
	return item

func create_equipment_drop(creature: Dictionary) -> ItemEquipment:
	var item: ItemEquipment
	var quality:= 100
	var num_enchantments:= 0
	var recipe: String = equipment_recipes.keys().pick_random()
	if creature.has("equipment_quality"):
		quality *= creature.equipment_quality
	item = create_random_standard_equipment(
		recipe,
		Region.new({
			"level":creature.level,
			"tier":creature.tier,
			"local_materials":DEFAULT_MATERIALS,
		}),
		floori((creature.tier as int) * randf_range(0.25, 0.75) + randf_range(0.0, 0.5)),
		float(quality) / 100.0,
	)
	item.recipe = recipe
	num_enchantments -= int(item.is_enchanted)
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
			item.enchant_equipment(enchantment, int(quality * randf_range(0.75, 1.25)))
	item.source = Story.sanitize_string(tr("DROPPED_BY").format({
		"creature":creature.name,
	}))
	if "race" in creature:
		item.source_race = creature.race
	item.description = item.create_tooltip()
	item.story = item.create_description()
	item.component_description = item.create_component_tooltip()
	return item

func create_legendary_equipment(type: String, level: int, quality:= 150) -> ItemEquipment:
	var item: ItemEquipment
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
		base_name = (LEGENDARY_ITEM_NAME[type].pick_random() as String).capitalize()
	else:
		base_name = item.base_name.capitalize()
	item.recipe = type
	item.name = base_name
	item.enchant_equipment(
		(Enchantment.enchantments_by_tier_and_slot.legendary.minor as Array).pick_random() as String,
		quality + add_quality + 10 * level, "1")
	item.enchant_equipment(
		(Enchantment.enchantments_by_tier_and_slot.legendary.greater as Array).pick_random() as String,
		quality + add_quality + 10 * level, "2")
	item.enchantment_potential = 0
	item.is_legendary = true
	
	item.card_set = Description.create_description_data(item, 6)
	
	if randf() < 0.75:
		var prefixes:= []
		var suffixes:= []
		for card: Dictionary in item.card_set.values():
			if "prefix" in card.properties:
				prefixes.append(card.properties.prefix)
			if "suffix" in card.properties:
				suffixes.append(card.properties.suffix)
		
		item.name = base_name
		if prefixes.size() > 0:
			item.name = prefixes.pick_random() + " " + item.name
		if suffixes.size() > 0:
			item.name += " " + suffixes.pick_random()
	
	if randf() < 0.25:
		var rnd:= randf()
		var prefix := (Names.PREFIX.pick_random() as String).capitalize()
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
		creator = Names.create_name(Names.NAME_DATA.keys().pick_random() as String, randi_range(-1, 1))
	item.source = tr("ARTIFACT_BY_CREATOR").format({
		"creator": creator,
	})
	
	for pos in item.card_set:
		if item.card_set[pos].type == "craftmanship":
			#item.card_set.erase(pos)
			item.card_set[pos].properties.singular = creator
	Description.add_card(item.card_set, Description.create_card("theme"),
	Utils.get_closest_position(Vector2i(0, 0), item.card_set.keys()))
	Description.add_card(item.card_set, Description.create_card("craftmanship", {
		"singular": creator,
		"adjective": ["legendary", "epic"].pick_random(),
		"adverb": ["legendaryly", "masterfully"].pick_random(),
		"is_name": true,
	}), Utils.get_closest_position(Vector2i(0, 0), item.card_set.keys()))
	
	item.description = item.create_tooltip()
	item.story = item.create_description()
	item.component_description = item.create_component_tooltip()
	return item

func create_material_drop(type: String, creature: Dictionary, add_data:= {}) -> ItemMaterial:
	var material: ItemMaterial
	var material_data: Dictionary = materials[type].duplicate(true)
	var quality:= get_creature_quality(creature)
	if !creature.has("name_prefix"):
		creature.name_prefix = creature.base_name
	material_data.type = "material"
	if is_vegan && material_data.has("veggie_name"):
		material_data.name = sanitize_name(
			((material_data.veggie_name as Array).pick_random() as String).format(creature),
		).capitalize()
	else:
		material_data.name = sanitize_name(
			((material_data.name as Array).pick_random() as String).format(creature),
		).capitalize()
	if material_data.has("quality"):
		material_data.quality *= quality
	else:
		material_data.quality = quality
	if material_data.has("add"):
		merge_dicts(material_data.add as Dictionary, add_data)
	else:
		material_data.add = add_data.duplicate(true)
	for k: String in material_data.add:
		match typeof(material_data.add[k]):
			TYPE_FLOAT:
				material_data.add[k] *= float(quality) / 100.0
			TYPE_INT:
				material_data.add[k] = int((material_data.add[k] as float) * quality / 100)
			TYPE_DICTIONARY:
				if k in ["damage", "resistance"]:
					continue
				for c: String in material_data.add[k]:
					material_data.add[k][c] *= float(quality) / 100.0
	material_data.price = ceili((material_data.price as float) * (0.5 +
		float(quality) / 100.0 * float(quality) / 100.0) + 0.25 *
		float((material_data.add as Dictionary).size() > 0))
	material_data.source = Story.sanitize_string(tr("DROPPED_BY").format({
		"creature":creature.name,
	}))
	
	material = ItemMaterial.new(material_data)
	material.description = material.create_tooltip()
	return material

func create_regional_material(type: String, region: Region, quality_mod:= 1.0) -> ItemMaterial:
	var material: ItemMaterial
	var material_data: Dictionary = materials[type].duplicate(true)
	var quality: int
	var named:= false
	var base_mat:= {}
	quality = int(get_creature_quality({
		"level":region.level,
		"tier":region.tier + randi_range(-1, 1),
	}) * quality_mod)
	material_data.type = "material"
	if material_data.has("quality"):
		quality *= material_data.quality
	for k in region.local_materials:
		if k in material_data.tags:
			base_mat = region.local_materials[k].pick_random()
			break
	if base_mat.size()==0:
		for k in DEFAULT_MATERIALS:
			if k in material_data.tags:
				base_mat = DEFAULT_MATERIALS[k].pick_random()
				break
	if base_mat.size()>0:
		quality *= base_mat.quality
		material_data.name = sanitize_name(((material_data.name as Array).pick_random() as String).format({
			"base_name":base_mat.name,
			"name_prefix":base_mat.name,
		})).capitalize()
		if base_mat.has("mod"):
			if material_data.has("mod"):
				material_data.mod = merge_dicts(
					material_data.mod as Dictionary,
					(base_mat.mod as Dictionary).duplicate(true) as Dictionary,
				)
			else:
				material_data.mod = (base_mat.mod as Dictionary).duplicate(true)
		if base_mat.has("add"):
			if material_data.has("add"):
				material_data.add = merge_dicts(
					material_data.add as Dictionary,
					(base_mat.add as Dictionary).duplicate(true) as Dictionary,
				)
			else:
				material_data.add = (base_mat.add as Dictionary).duplicate(true)
		named = true
	if material_data.has("add"):
		for s: String in material_data.add:
			if typeof(material_data.add[s]) == TYPE_INT:
				material_data.add[s] = floori((material_data.add[s] as float) * quality / 100.0)
			elif typeof(material_data.add[s]) == TYPE_FLOAT:
				material_data.add[s] *= float(quality) / 100.0
	
	if !named:
		var dict: Dictionary = DEFAULT_MATERIAL_TYPES.pick_random()
		material_data.name = sanitize_name(
			((material_data.name as Array).pick_random() as String).format({
				"base_name": dict.name,
				"name_prefix": dict.name,
			}),
		).capitalize()
	material_data.price = floori((material_data.price as float) * (0.5 +
		0.5*float(quality) / 100.0 * float(quality) / 100.0))
	material_data.quality = quality
	
	material = ItemMaterial.new(material_data)
	material.description = material.create_tooltip()
	return material

func create_soul_stone_drop(creature: Dictionary) -> ItemMaterial:
	var tier: int = min(creature.soul_rarity + randi_range(-1, 1) + 2, SOUL_STONES.size())
	var type: String = SOUL_STONES[tier]
	return create_material_drop(type, creature, creature.get("soul_add", {}) as Dictionary)


func enchant_equipment_material(item: ItemEquipment, enchantment_type: String, material_list: Array[ItemMaterial],
		quality_bonus:= 0, enchantment_slot:= "") -> ItemEquipment:
	var add_data:= {}
	for material in material_list:
		if material.add.size() > 0:
			merge_dicts(add_data, material.add)
	item.enchant_equipment(enchantment_type, get_material_quality(material_list) + quality_bonus,
		enchantment_slot, add_data)
	return item


#func create_relic() -> Dictionary:
	#var info := {
		#"type": "relic",
		#"name": "relic",
		#"components":[]
	#}
	#var equipment := create_equipment("relic", [], [], info)
	#
	#return equipment


func craft_potion(type: String, material_list: Array[ItemMaterial], quality_bonus:= 0) -> ItemPotion:
	var item := create_potion(type, (material_list.pick_random() as ItemMaterial).name,
		get_material_quality(material_list) + quality_bonus)
	item.source = tr("MADE_OUT_OF").format({
		"items":make_list(material_list),
	})
	item.description = item.create_tooltip()
	return item

func create_potion(type: String, name_prefix: String, quality: int) -> ItemPotion:
	var dict: Dictionary = potion_recipes[type]
	var item_data := {
		"name": sanitize_name(name_prefix + " " + (dict.get("name", "") as String)).capitalize(),
		"type": dict.type,
		"effect": dict.effect,
		"quality": quality,
		"source": tr("UNKNOWN_ORIGIN"),
	}
	var scale := float(quality) / 100.0
	for k: String in dict:
		if typeof(dict[k]) == TYPE_INT:
			item_data[k] = ceili(scale * (dict[k] as float))
		elif typeof(dict[k]) == TYPE_FLOAT:
			item_data[k] = scale * dict[k]
	if dict.has("status"):
		item_data.status = (dict.status as Dictionary).duplicate(true)
		for k: String in item_data.status:
			if typeof(item_data.status[k]) == TYPE_INT:
				item_data.status[k] = ceili(scale * (item_data.status[k] as float))
			elif typeof(item_data.status[k]) == TYPE_FLOAT:
				item_data.status[k] = scale * item_data.status[k]
	item_data.price = floori((potion_recipes[type].price as float) * (0.5 +
		0.5 * float(quality) / 100.0 * float(quality) / 100.0))
	return ItemPotion.new(item_data)


func cook(type: String, material_list: Array, quality_bonus:= 0) -> ItemFood:
	var item := create_food(type, material_list.pick_random().name as String,
		get_material_quality(material_list) + quality_bonus)
	item.description = item.create_tooltip()
	return item

func create_food(type: String, name_prefix: String, quality: int) -> ItemFood:
	var item: ItemFood
	var dict: Dictionary = food_recipes[type]
	var item_data := {
		"name": sanitize_name(name_prefix + " " + (dict.name as String)).capitalize(),
		"type": dict.type,
		"quality": quality,
	}
	var scale:= float(quality) / 100.0
	for k: String in dict:
		if typeof(dict[k]) == TYPE_INT:
			item_data[k] = ceili(scale * (dict[k] as float))
		elif typeof(dict[k]) == TYPE_FLOAT:
			item_data[k] = scale * dict[k]
	if dict.has("status"):
		item_data.status = (item_data.status as Dictionary).duplicate(true)
		for k: String in item_data.status:
			if k == "duration":
				continue
			if typeof(item_data.status[k]) == TYPE_INT:
				item_data.status[k] = ceili(scale * (item_data.status[k] as float))
			elif typeof(item_data.status[k]) == TYPE_FLOAT:
				item_data.status[k] = scale * item_data.status[k]
	item_data.price = floori((food_recipes[type].price as float) * (0.5 +
		0.5 * float(quality) / 100.0 * float(quality) / 100.0))
	
	item = ItemFood.new(item_data)
	item.description = item.create_tooltip()
	return item


func sanitize_name(string: String) -> String:
	string.replace("{", "").replace("}", "")
	for s in string.split(" ", false):
		while string.find(s) != string.rfind(s):
			var pos:= string.find(s)
			var pos2:= string.find(s, pos + s.length())
			string = string.substr(0, pos) + s + string.substr(pos2 + s.length())
	return string


func load_material_data(path: String) -> void:
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
		for key: String in dict:
			materials[key] = dict[key]
		file.close()

func load_component_data(path: String) -> void:
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
		for key: String in dict:
			equipment_components[key] = dict[key]
		file.close()

func load_recipe_data(path: String) -> void:
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
		for key: String in dict:
			equipment_recipes[key] = dict[key]
		file.close()

func load_potion_data(path: String) -> void:
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
		for key: String in dict:
			potion_recipes[key] = dict[key]
		file.close()

func load_food_data(path: String) -> void:
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
		for key: String in dict:
			food_recipes[key] = dict[key]
		file.close()

func _ready() -> void:
	load_material_data("res://data/materials")
	load_component_data("res://data/items/components")
	load_recipe_data("res://data/items/recipes")
	load_potion_data("res://data/items/potions")
	load_food_data("res://data/items/food")
