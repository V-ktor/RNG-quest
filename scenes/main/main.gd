extends Node
class_name Main

const MAX_STEPS = 100
const MAX_DELTA = 1.0/10.0
const SELLING_PRICE = 0.2
const MATERIAL_SELLING_PRICE = 0.2
const QUESTS_PER_CHAPTER = 50
const QUESTS_INCREASE_PER_CHAPTER = 20
const QUEST_GOLD_REWARD_MIN = 5
const QUEST_GOLD_REWARD_MAX = 20
const TRAVEL_DELAY = 180.0
const RETREAT_DELAY = 180.0
const RECOVER_DELAY = 300.0
const SEARCH_DELAY = 15.0
const LOOT_DELAY = 30.0
const POTION_DELAY = 2.0
const POTION_USE_DELAY = 10.0
const QUESTING_DELAY = 60.0
const SHOPPING_DELAY = 5.0
const CRAFTING_DELAY = 60.0
const COOKING_ATTEMPT_DELAY = 600.0
const REST_DELAY = 60.0*60.0
const SLEEP_DELAY = 7.0*60.0*60.0
const QUICKTRAVEL_DELAY = 60*60
const RETREAT_THRESHOLD = 0.1
const RECOVER_THRESHOLD = 0.4
const POTION_THRESHOLD = 0.7
const MAX_POTIONS = 20
const EQUIPMENT_SLOTS = [
	"weapon", "offweapon", "torso", "legs", "head", "hands", "feet", "cape", "belt",
	"amulet", "ring_left", "ring_right", "bracelet_left", "bracelet_right",
	"earring_left", "earring_right",
]
const EQUIPMENT_LEVEL_RESTRICTION = {
	"ring": 5, "ring_left": 5, "ring_right": 5,
	"belt": 10,
	"cape": 15,
	"bracelet": 25, "bracelet_left": 25, "bracelet_right": 25,
	"earring": 40, "earring_left": 40, "earring_right": 40,
}
const EQUIPMENT_LR_TYPES = [
	"ring", "earring", "bracelet"
]
const EQUIPMENT_QUALITY_SCALING = 0.1
const EQUIPMENT_BASE_PRICE = 30
const MAX_SUMMONS = 1
const ACTIONS = ["training", "grinding", "questing", "shopping", "crafting", "resting"]
var timetable:= {
	00: "sleeping",
	05: "shopping",
	07: "training",
	09: "grinding",
	11: "questing",
	12: "resting",
	13: "crafting",
	14: "shopping",
	15: "questing",
	17: "grinding",
	19: "resting",
	20: "questing",
	21: "crafting",
	22: "shopping",
	23: "sleeping",
}
const STAT_ATTRIBUTES = {
	"strength": {
		"attack": 1,
	},
	"intelligence": {
		"magic": 1,
	},
	"wisdom": {
		"willpower": 1,
	},
	"constitution": {
		"armour": 1,
	},
	"dexterity": {
		"accuracy": 1,
		"evasion": 1,
	},
}
const HANGOUT_LOCATIONS = [
	"TAVERN", "BAR", "PUB", "MARKET", "GROCERY_STORE", "PARK",
	"BATH_HOUSE", "TOILET", "BARBER_SHOP", "SPA", "DOCTOR", "DENTIST",
]

var version:= ""
var player_name:= "Player"
var player_gender:= "None"
var player_race:= "Unknown"
var player: Characters.Character
#var player_ability_exp:= {}
var player_inventory:= []
var player_potions:= []
var player_summons:= []
var player_gold:= 50
var player_stat_preference:= {}
var player_ability_preference:= {}
var player_potion_delay:= 0.0
var player_cooking_delay:= 0.0
var player_guild_lvl:= {}
var player_guild_exp:= {}
var player_exp:= 0
var player_vegan:= false
var player_creation_time:= 0
var player_settings:= Characters.CharacterSettings.new()
var player_delay:= 0.0
var player_battles_won:= 0
var player_battles_lost:= 0
var player_potions_used:= {}
var max_summons:= MAX_SUMMONS
var current_action_text: String
var current_task: String
var current_task_ID:= -1
var current_action: Dictionary
var current_region: Region
var current_location: String
var explored_locations: Array
var quest_chapter:= -1
var quest_progress:= 0
var current_quest: Dictionary
var quest_log:= ""
var summary_text:= ""
var action_failures:= 0
var enemies:= []
var loot:= []
var turn_counter:= 0
var current_time: float
var info_update:= false
var skill_update:= false
var equipment_update:= false
var inventory_update:= false
var status_update:= false
var character_update:= false
var time_offset:= 0
var autosave_delay:= 30.0
var historical_data:= {}

signal text_printed(text: String)
signal characters_updated(player: Array[Characters.Character], enemy: Array[Characters.Character])
signal gold_changed(value: int)
signal inventory_changed(inventory: Array)
signal potion_inventory_changed(inventory: Array)
signal story_inventory_changed(inventory: Array)
signal location_changed(region: Region, current_location: String)
signal quest_log_updated(text: String)
signal summary_updated(text: String)
signal skills_updated()
signal abilities_updated()
signal guilds_updated()
signal freed


func set_region(type: String) -> String:
	current_region = Regions.create_region(type)
	# Adjust difficulty.
	if player.level < current_region.level:
		current_region.tier -= 1
	elif current_region.level < player.level - 25:
		current_region.tier += 2
		current_region.level += 10
	elif current_region.level < player.level - 20:
		current_region.tier += 2
		current_region.level += 5
	elif current_region.level < player.level - 15:
		current_region.tier += 1
		current_region.level += 10
	elif current_region.level < player.level - 10:
		current_region.tier += 1
		current_region.level += 5
	elif current_region.level < player.level - 5:
		current_region.tier += 1
	Story.locations = current_region.locations
	Story.cities = current_region.cities
	Story.guilds = player_guild_lvl.keys()
	Story.factions = current_region.race
	Story.hostile_factions = current_region.enemy
	return current_region.name

func pick_skill_type() -> String:
	var dict:= {}
	var sum:= 0.0
	var rnd: float
	for k in player_ability_preference.keys():
		if !Skills.ABILITY_SKILLS.has(k):
			continue
		sum += player_ability_preference[k]*get_preference_bonus(k)
		dict[k] = sum
	rnd = randf()*sum
	for k in dict.keys():
		if rnd<=dict[k]:
			return k
	return ""

func pick_skill_upgrade() -> Dictionary:
	var dict:= {}
	var sum:= 0.0
	var rnd: float
	if randf()<0.25:
		return player.skills.pick_random()
	for skill in player.skills:
		if skill.has("cost") && skill.cost.has("focus") && player.max_focus-skill.cost.focus<=1.0:
			continue
		for s in skill.slots.keys():
			for t in skill.slots[s]:
				for a in player.abilities.keys():
					if !Skills.ABILITY_MODULES.has(a) || !Skills.ABILITY_MODULES[a].has(s) || !Skills.ABILITY_MODULES[a][s].has(t):
						continue
					if !player_ability_preference.has(a):
						player_ability_preference[a] = 0.0
					sum += player_ability_preference[a] * get_preference_bonus(a)
		dict[skill] = sum
	rnd = randf() * sum
	for k in dict.keys():
		if rnd <= dict[k]:
			return k
	if player.skills.size() == 0:
		return {}
	return player.skills.pick_random()

func learn_new_skill(force_type := "", basic := false):
	var skill := Skills.create_random_skill(player.abilities.keys(), force_type, basic, [], player_settings.disabled_skill_modules)
	var text := tr("LEARNED_SKILL_LOG").format(skill)
	for s in player.skills:
		if s.name == skill.name:
			var rnd := randf()
			if rnd < 0.25:
				skill.name += " " + tr("TYPE") + " " + str(randi_range(1, 9))
			elif rnd < 0.5:
				skill.name = ["Neo", "Second", "Ultimate", "Improved", "Enhanced"].pick_random() + " " + skill.name
			else:
				skill.name += " " + ["Ex", "Alt", "Improved", "Ultimate"].pick_random()
			break
	player.skills.push_back(skill)
	print_log_msg("\n" + text)
	print_summary_msg(text)
	emit_signal("skills_updated")
	store_historical_data("skills", 0, skill.name)
	store_historical_data("skills", skill.level, skill.name)

func get_level_scaling(level: int, scaling := 1.0):
	return (1.0 + 0.1 * scaling * (level - 1)) / (1.0 + 0.1 * scaling * (level - 2))

func inc_level(dict, level: int, scaling := 1.0):
	if typeof(dict) == TYPE_DICTIONARY:
		for k in dict.keys():
			var s:= scaling*(1.0 - 0.5 * float(k == "focus") + 1.0 * float(k == "mana" || k == "stamina" || k == "health"))
			match typeof(dict[k]):
				TYPE_FLOAT:
					dict[k] *= get_level_scaling(level, s)
				TYPE_INT:
					dict[k] = float(dict[k]) * get_level_scaling(level, s)
				TYPE_DICTIONARY, TYPE_ARRAY:
					inc_level(dict[k], level, scaling)
	elif typeof(dict)==TYPE_ARRAY:
		for i in range(dict.size()):
			match typeof(dict[i]):
				TYPE_FLOAT:
					dict[i] *= get_level_scaling(level, scaling)
				TYPE_INT:
					dict[i] = float(dict[i]) * get_level_scaling(level, scaling)
				TYPE_DICTIONARY, TYPE_ARRAY:
					inc_level(dict[i], level, scaling)

func upgrade_skill(skill:= {}):
	var text: String
	if skill.size()==0:
		skill = pick_skill_upgrade()
	if skill.size()==0:
		skill = player.skills.pick_random()
	skill.level = int(skill.level + 1)
	inc_level(skill.combat, skill.level)
	if skill.has("cost"):
		inc_level(skill.cost, skill.level)
	if skill.has("attributes"):
		inc_level(skill.attributes, skill.level)
	if skill.has("summon_damage"):
		inc_level(skill.summon_damage, skill.level)
	if skill.has("summon_resistance"):
		inc_level(skill.summon_resistance, skill.level)
	if skill.has("summoning"):
		inc_level(skill.summoning, skill.level)
	if skill.has("status"):
		inc_level(skill.status, skill.level)
	if skill.has("damage"):
		inc_level(skill.damage, skill.level)
	if skill.has("magic"):
		inc_level(skill.magic, skill.level)
	if skill.has("duration"):
		skill.duration *= get_level_scaling(skill.level, 0.25)
	if skill.has("cooldown"):
		skill.cooldown *= get_level_scaling(skill.level, 0.25)
	skill.description = Skills.create_tooltip(skill)
	skill.description_plain = Skills.tooltip_remove_bb_code(skill.description)
	if skill in player.skills:
		text = tr("SKILL_UPGRADE_LOG").format({"name":skill.name, "level":Skills.convert_to_roman_number(skill.level), "description":skill.description_plain})
		print_log_msg(text)
		print_summary_msg(text)
		emit_signal("skills_updated")
		store_historical_data("skills", skill.level, skill.name)

func pick_ability() -> String:
	var valid:= []
	var magical:= player.abilities.has("elemental_magic") || player.abilities.has("nature_magic") || player.abilities.has("celestial_magic") || player.abilities.has("defensive_magic") || player.abilities.has("healing")
	
	if !player.abilities.has("light_weapons") && (player.abilities.has("heavy_weapons") || player.abilities.has("dirty_fighting") || player.abilities.has("shield") || player.abilities.has("evasion") || player.abilities.has("weapon_smithing")):
		valid.push_back("light_weapons")
	if !player.abilities.has("heavy_weapons") && (player.abilities.has("light_weapons") || player.abilities.has("shield") || player.abilities.has("armour") || player.abilities.has("weapon_smithing")):
		valid.push_back("heavy_weapons")
	if !player.abilities.has("dirty_fighting") && (player.abilities.has("light_weapons")):
		valid.push_back("dirty_fighting")
	if !player.abilities.has("brawling") && (player.abilities.has("armour") || player.abilities.has("heavy_weapons")):
		valid.push_back("brawling")
	if !player.abilities.has("archery") && (((player.abilities.has("light_weapons") || player.abilities.has("woodwork")) && !magical) || ((magical || player.abilities.has("woodwork")) && !(player.abilities.has("light_weapons") || player.abilities.has("heavy_weapons")))):
		valid.push_back("archery")
	if !player.abilities.has("trapping") && (player.abilities.has("archery") || player.abilities.has("dirty_fighting")):
		valid.push_back("trapping")
	if !player.abilities.has("shield") && player.abilities.has("armour"):
		valid.push_back("shield")
	if !player.abilities.has("armour") && (player.abilities.has("shield") || player.abilities.has("heavy_weapons") || player.abilities.has("armour_smithing")):
		valid.push_back("armour")
	if !player.abilities.has("evasion") && (player.abilities.has("light_weapons") || player.abilities.has("dirty_fighting") || player.abilities.has("tayloring")):
		valid.push_back("evasion")
	if !player.abilities.has("elemental_magic") && magical:
		valid.push_back("elemental_magic")
	if !player.abilities.has("nature_magic") && magical:
		valid.push_back("nature_magic")
	if !player.abilities.has("celestial_magic") && magical:
		valid.push_back("celestial_magic")
	if !player.abilities.has("defensive_magic") && magical:
		valid.push_back("defensive_magic")
	if !player.abilities.has("blood_magic") && (player.abilities.has("necromancy") || player.abilities.has("celestial_magic")) && magical:
		valid.push_back("blood_magic")
	if !player.abilities.has("summoning") && magical:
		valid.push_back("summoning")
	if !player.abilities.has("necromancy") && magical:
		valid.push_back("necromancy")
	if !player.abilities.has("healing") && magical:
		valid.push_back("healing")
	if !player.abilities.has("alchemy") && (magical || player.abilities.has("archery") || player.abilities.has("dirty_fighting")):
		valid.push_back("alchemy")
	if !player.abilities.has("enchanting") && magical:
		valid.push_back("enchanting")
	if !player.abilities.has("soul_binding") && magical && player.abilities.has("enchanting"):
		valid.push_back("soul_binding")
	if !player.abilities.has("weapon_smithing") && (player.abilities.has("light_weapons") || player.abilities.has("heavy_weapons")):
		valid.push_back("weapon_smithing")
	if !player.abilities.has("armour_smithing") && (player.abilities.has("armour") || player.abilities.has("shield")):
		valid.push_back("armour_smithing")
	if !player.abilities.has("tayloring") && (magical || player.abilities.has("evasion") || player.abilities.has("dirty_fighting")):
		valid.push_back("tayloring")
	if !player.abilities.has("woodwork") && (magical || player.abilities.has("archery")):
		valid.push_back("woodwork")
	if !player.abilities.has("cooking"):
		valid.push_back("cooking")
	
	if valid.size() == 0:
		for k in Skills.ABILITIES.keys():
			if !player.abilities.has(k):
				valid.push_back(k)
	
	if valid.size() > 0:
		return valid.pick_random()
	return ""

func learn_new_ability(type := ""):
	if type.length() == 0:
		type = pick_ability()
	if type.length() == 0:
		for ability in player.abilities.keys():
			player.abilities[ability].level_up()
		return
	
	var text:= tr("LEARNED_ABIlITY_LOG").format({"ability": tr(Skills.ABILITIES[type].name.to_upper())})
	player.abilities[type] = Ability.new({
		"name": Skills.ABILITIES[type].name,
		"level": 1,
		"experience": 0,
	})
	#player_ability_exp[type] = 0
	learn_new_skill()
	print_log_msg(text)
	print_summary_msg(text)
	store_historical_data("abilities", 0, type)
	store_historical_data("abilities", 1, type)
	emit_signal("abilities_updated")

func join_guild(guild: String):
	var text:= tr("JOIN_GUILD").format({"guild": tr(guild.to_upper()), "rank": Guilds.get_rank(1, guild)})
	player_guild_exp[guild] = 0
	player_guild_lvl[guild] = 1
	print_log_msg(text)
	print_summary_msg(text)
	store_historical_data("guilds", 0, guild)
	store_historical_data("guilds", 1, guild)
	emit_signal("guilds_updated")

func get_preference_bonus(type: String) -> float:
	var multiplier:= 1.0
	if type in ["infuse_elemental", "infuse_nature", "cleric"]:
		multiplier *= 1.5
	if type in ["light_weapons", "heavy_weapons", "archery"] && (player.abilities.has("infuse_elemental") || player.abilities.has("infuse_nature") || player.abilities.has("cleric")):
		multiplier *= 1.5
	return multiplier

func get_attribute_preference() -> Dictionary:
	var dict:= {}
	var sum:= 0.0
	for k in player.attributes.keys():
		dict[k] = 0.0
	for stat in player_stat_preference.keys():
		if !STAT_ATTRIBUTES.has(stat):
			continue
		for k in STAT_ATTRIBUTES[stat].keys():
			dict[k] += STAT_ATTRIBUTES[stat][k]*player_stat_preference[stat]
	for ability in player_ability_preference.keys():
		for k in dict.keys():
			if Skills.ABILITIES[ability].has(k):
				dict[k] += player_ability_preference[ability]*Skills.ABILITIES[ability][k]
	if player.abilities.has("armour") || player.abilities.has("shield"):
		dict.armour *= 2.0
	if player.abilities.has("evasion"):
		dict.evasion *= 2.0
	dict.penetration *= 1.0 + 0.5*float(player.abilities.has("light_weapon")) + 0.5*float(player.abilities.has("dirty_fighting"))
	for k in dict.keys():
		sum += dict[k]
	for k in dict.keys():
		dict[k] = 1.0 + 4.0*dict[k]/sum
	if !player.abilities.has("elemental_magic") && !player.abilities.has("nature_magic") && !player.abilities.has("celestial_magic"):
		dict.magic -= 1.0
	if !player.abilities.has("light_weapons") && !player.abilities.has("heavy_weapons") && !player.abilities.has("archery") && !player.abilities.has("shield"):
		dict.attack -= 1.0
	if !player.abilities.has("healing") && !player.abilities.has("summoning") && !player.abilities.has("necromancy"):
		dict.willpower -= 0.5
	dict.speed *= (0.5 + (0.025-0.005*float(player.abilities.has("armour"))) * (dict.attack*player.attributes.attack + dict.magic*player.attributes.magic))
	return dict

func add_item(item: Dictionary, amount:= 1):
	for i in range(amount):
		player_inventory.push_back(item)
	emit_signal("inventory_changed", player_inventory)

func remove_item(item: Dictionary, amount:= 1):
	for i in range(amount):
		player_inventory.erase(item)
	emit_signal("inventory_changed", player_inventory)

func sell_item(item: Dictionary, amount:= 1) -> int:
	if !(item in player_inventory):
		return 0
	var price: int
	if item.type=="material":
		price = max(item.price*amount*MATERIAL_SELLING_PRICE, 1)
	else:
		price = max(item.price*amount*SELLING_PRICE, 1)
	player_gold += price
	remove_item(item, amount)
	emit_signal("gold_changed", player_gold)
	return price

func buy_item(item: Dictionary, amount:= 1) -> bool:
	if player_gold<item.price*amount:
		return false
	player_gold -= item.price*amount
	emit_signal("gold_changed", player_gold)
	return true

func unequip(type: String) -> bool:
	if !player.equipment.has(type):
		return false
	add_item(player.equipment[type])
	player.equipment.erase(type)
	return true

func equip(item: Dictionary) -> bool:
	if !item.has("type"):
		return false
	if item.has("2h") && item["2h"]:
		unequip("offweapon")
	if player.equipment.has(item.type):
		if item.type=="weapon":
			if !(item.has("2h") && item["2h"]):
				if !player.equipment.has("weapon"):
					player.equipment.weapon = item
					return true
				elif !player.equipment.has("offweapon") && !(player.equipment.weapon.has("2h") && player.equipment.weapon["2h"]):
					player.equipment.offweapon = item
					return true
				else:
					if player.equipment.has("offweapon") && player.equipment.offweapon.base_type==item.base_type:
						unequip("offweapon")
						player.equipment.offweapon = item
					else:
						unequip("weapon")
						player.equipment.weapon = item
					return true
			else:
				if player.equipment.has("weapon"):
					unequip("weapon")
					player.equipment.weapon = item
					return true
	if item.type in EQUIPMENT_LR_TYPES:
		var l: String = item.type + "_left"
		var r: String = item.type + "_right"
		if !player.equipment.has(l):
			player.equipment[l] = item
			return true
		if !player.equipment.has(r):
			player.equipment[r] = item
			return true
		if compare_items([item], [player.equipment[l]])>0:
			unequip(l)
			player.equipment[l] = item
			return true
		else:
			unequip(r)
			player.equipment[r] = item
			return true
	player.equipment[item.type] = item
	return true

func get_equipment_quality(type: String) -> float:
	var search_type:= type
	for t in player.equipment.keys():
		if t != search_type:
			continue
		var item: Dictionary = player.equipment[t]
		return item.quality
	return 0.0

func get_worst_equipment_type() -> String:
	var valid:= []
	var min_quality:= 1e99
	for k in EQUIPMENT_SLOTS:
		if EQUIPMENT_LEVEL_RESTRICTION.has(k) && player.level < EQUIPMENT_LEVEL_RESTRICTION[k]:
			continue
		var quality:= get_equipment_quality(k) * randf_range(0.95, 1.05)
		if quality == min_quality:
			valid.push_back(k)
			min_quality = quality
		if quality < min_quality:
			valid = [k]
			min_quality = quality
	if valid.size() == 0:
		return ""
	return valid.pick_random()

func pick_random_potion_type(type:= "health") -> String:
	var valid:= []
	for t in Items.potion_recipes.keys():
		if Items.potion_recipes[t].effect == type:
			valid.push_back(t)
	if valid.size() > 0:
		return valid.pick_random()
	return Items.potion_recipes.keys().pick_random()

func create_shop_equipment(type: String, quality_mod:= 1.0) -> Dictionary:
	var item: Dictionary
	var num_enchantments:= 0
	item = Items.create_random_standard_equipment(type, current_region, 0, quality_mod)
	for i in range(3):
		if randf() < current_region.enchantment_chance:
			num_enchantments += 1
	for i in range(num_enchantments):
		var quality: int
		var tier_multiplier:= 1.0
		var level_multiplier: float = 1.0 + 0.05 * (current_region.level + player.level - 2)
		if current_region.tier < 0:
			tier_multiplier = 1.0 / sqrt(-1.5 * current_region.tier)
		elif current_region.tier > 0:
			tier_multiplier = sqrt(1.5 * current_region.tier)
		quality = int(100*level_multiplier * tier_multiplier)
		item = Items.enchant_equipment(item, Items.Enchantment.enchantments_by_tier.regular.pick_random(), quality)
		if randf() < 0.02:
			item = Items.enchant_equipment(item, Items.Enchantment.enchantments_by_tier.curse.pick_random(), quality)
	item.source = tr("BOUGHT_FROM_SHOP").format({"location": current_location})
	item.description = Items.create_tooltip(item)
	item.description_plain = Skills.tooltip_remove_bb_code(item.description)
	return item

func create_shop_potion(type:="") -> Dictionary:
	var item: Dictionary
	var dict: Dictionary
	var material: Dictionary = current_region.local_materials.alchemy.pick_random().duplicate(true)
	var quality: int
	var tier_multiplier:= 1.0
	var level_multiplier: float = 1.0 + 0.05 * (current_region.level + player.level - 2)
	if current_region.tier < 0:
		tier_multiplier = 1.0 / sqrt(-1.5 * current_region.tier)
	elif current_region.tier > 0:
		tier_multiplier = sqrt(1.5 * current_region.tier)
	quality = int(100 * level_multiplier * tier_multiplier)
	if type == "":
		if player_settings.valid_potion_types.size() > 0 && randf() < 0.25:
			type = pick_random_potion_type(player_settings.valid_potion_types.pick_random())
		else:
			type = pick_random_potion_type()
	dict = Items.potion_recipes[type]
	for m in dict.material_types[0]:
		if !current_region.local_materials.has(m):
			continue
		material = current_region.local_materials[m].pick_random().duplicate(true)
		break
	material.quality *= quality
	item = Items.craft_potion(type, [material])
	item.source = tr("BOUGHT_FROM_SHOP").format({"location": current_location})
	item.description = Items.create_tooltip(item)
	item.description_plain = Skills.tooltip_remove_bb_code(item.description)
	return item

func create_shop_material(material:= "") -> Dictionary:
	var item: Dictionary
	var valid_abilities:= []
	var recipe: String
	
	if material == "":
		var valid:= []
		var type: String
		for k in player.abilities:
			if Skills.ABILITIES[k].has("recipes"):
				valid_abilities.push_back(k)
		if valid_abilities.size() == 0:
			return {}
		recipe = Skills.ABILITIES[valid_abilities.pick_random()].recipes.pick_random()
		if Items.equipment_recipes.has(recipe):
			type = Items.equipment_components[
				Items.equipment_recipes[recipe].components.pick_random()].material.pick_random()
		elif Items.potion_recipes.has(recipe):
			type = Items.potion_recipes[recipe].material_types.pick_random().pick_random()
		elif Items.food_recipes.has(recipe):
			type = Items.food_recipes[recipe].material_types.pick_random().pick_random()
		elif Items.Enchantment.enchantments.has(recipe):
			type = Items.Enchantment.enchantments[recipe].material_types.pick_random().pick_random()
		for mat in Items.materials.keys():
			if type in Items.materials[mat].tags:
				valid.push_back(mat)
		if player.abilities.has("soul_binding"):
			valid.push_back("empty_soul_stone")
		if valid.size()>0:
			material = valid.pick_random()
		else:
			material = Items.materials.keys().pick_random()
	
	item = Items.create_regional_material(material, current_region)
	item.source = tr("BOUGHT_FROM_SHOP").format({
		"location": current_location,
	})
	item.description = Items.create_tooltip(item)
	item.description_plain = Skills.tooltip_remove_bb_code(item.description)
	return item

func can_do_damage_type(type: String) -> bool:
	for skill in player.skills:
		if !skill.combat.has("damage"):
			continue
		for array in skill.combat.damage:
			for dict in array:
				if dict.has("type") && dict.type==type:
					return true
	return false

func calc_item_score(item: Dictionary, preference: Dictionary) -> int:
	var score:= 0
	var multiplier := 1.0 + 1.0*float(player.abilities.has("archery") && item.has("ranged") && item.ranged) - 0.75*float(!player.abilities.has("archery") && item.has("ranged") && item.ranged) + 0.25*float(player.abilities.has("shield") && item.has("subtype") && "shield" in item.subtype)
	for k in player.attributes.keys():
		if item.has(k):
			score += item[k]*preference[k]
	for k in player.stats.keys():
		if !item.has(k):
			continue
		if Characters.STATS_ATTRIBUTES.has(k):
			for attr in Characters.STATS_ATTRIBUTES[k]:
				score += item[k]*Characters.STATS_ATTRIBUTES[k][attr]*preference[attr]
		if Characters.STATS_METERS.has(k):
			for meter in Characters.STATS_METERS[k]:
				var factor:= 0.2
				if "regen" in meter:
					factor = 0.5
				score += item[k]*Characters.STATS_METERS[k][meter]*factor
	for k in ["health", "stamina", "mana"]:
		if item.has(k):
			score += item[k]/5.0
		if item.has(k+"_regen"):
			score += item[k+"_regen"]/2.0
	if item.has("focus"):
		score += item.focus*2
	if item.has("resistance"):
		for c in item.resistance.keys():
			score += 15.0*item.resistance[c]
	if item.has("damage"):
		for c in item.damage.keys():
			if can_do_damage_type(c):
				score += 30.0*item.damage[c]
	return int(score*multiplier)

func compare_items(new_items: Array, old_items: Array) -> int:
	var diff:= 0
	var preference := get_attribute_preference()
	for item in new_items:
		diff += calc_item_score(item, preference)
	for item in old_items:
		diff -= calc_item_score(item, preference)
	return diff

func get_slot_type(slot: String) -> String:
	if slot=="offweapon":
		return "weapon"
	elif slot=="ring_left":
		return "ring"
	elif slot=="ring_right":
		return "ring"
	elif slot=="earring_left":
		return "earring"
	elif slot=="earring_right":
		return "earring"
	elif slot=="bracelet_left":
		return "bracelet"
	elif slot=="bracelet_right":
		return "bracelet"
	return slot

func optimize_equipment():
	var i:= 0
	while i<player_inventory.size():
		var item: Dictionary = player_inventory[i]
		if item.has("2h") && item["2h"]:
			if !player_settings.weapon_2h_alowed:
				i += 1
				continue
		elif !player_settings.weapon_1h_alowed:
			i += 1
			continue
		if item.has("subtype"):
			if typeof(item.subtype) == TYPE_ARRAY:
				var valid:= false
				for k in item.subtype:
					if k in player_settings.valid_weapon_types || k in player_settings.valid_armour_types:
						valid = true
						break
				if !valid:
					i += 1
					continue
			elif !(item.subtype in player_settings.valid_weapon_types || item.subtype in player_settings.valid_armour_types || (player_settings.valid_weapon_types.size() == 0 && item.type == "weapon")):
				i += 1
				continue
		for k in EQUIPMENT_SLOTS:
			if get_slot_type(k) != item.type:
				continue
			if !player.equipment.has(k) && !(item.has("2h") && item["2h"]) && player_inventory.has(item):
				equip(item)
				player_inventory.erase(item)
				break
			elif item.has("2h") && item["2h"]:
				if k == "weapon" || k == "offweapon":
					if player.equipment.has("offweapon") && player_inventory.has(item) && compare_items([item], [player.equipment[k], player.equipment.offweapon]) > 0:
						equip(item)
						player_inventory.erase(item)
						break
			elif player.equipment[k].has("2h") && player.equipment[k]["2h"] && player_settings.weapon_1h_alowed:
				for j in range(player_inventory.size()):
					var it: Dictionary = player_inventory[j]
					if item==it:
						continue
					if it.has("2h") && it["2h"]:
						continue
					if it.has("subtype"):
						if !(it.subtype in player_settings.valid_weapon_types || it.subtype in player_settings.valid_armour_types || (player_settings.valid_weapon_types.size() == 0 && it.type == "weapon")):
							continue
					if it.type != "weapon":
						continue
					if compare_items([player.equipment[k]], [item, it]) < 0 && player_inventory.has(item) && player_inventory.has(it):
						equip(item)
						equip(it)
						player_inventory.erase(item)
						player_inventory.erase(it)
						break
			elif k == "weapon" && !player.equipment.has("offweapon") && player_inventory.has(item):
				equip(item)
				player_inventory.erase(item)
				break
			elif compare_items([item], [player.equipment[k]]) > 0 && player_inventory.has(item):
				equip(item)
				player_inventory.erase(item)
				break
		i += 1
	emit_signal("inventory_changed", player_inventory)

func get_equipment_gold_limit() -> int:
	return int(2 * EQUIPMENT_BASE_PRICE * (0.5 + 0.1 * (player.level - 1) * (player.level - 1)))

func get_potion_gold_limit() -> int:
	return int(0.75 * EQUIPMENT_BASE_PRICE * (0.5 + 0.1 * (player.level - 1) * (player.level - 1)))

func get_material_gold_limit() -> int:
	return int(8 * EQUIPMENT_BASE_PRICE * (0.5 + 0.1 * (player.level - 1) * (player.level - 1)))


func get_max_exp(lvl: int) -> int:
	return 50 + 50 * lvl * lvl

#func get_ability_exp(lvl: int) -> int:
#	return 100 + 75 * lvl + 25 * lvl * lvl

func get_delay_scale(speed: int) -> float:
	var s := Characters.get_resistance(speed / 10.0) * 10
	return 20.0 / max(10.0 + s, 1.0)

func get_min_character_dist(character: Characters.Character, opponents: Array[Characters.Character]) -> int:
	var min_dist := 9
	for c in opponents:
		var dist: int = abs(character.position - c.position)
		if dist == 0:
			return 0
		if dist < min_dist:
			min_dist = dist
	return min_dist

func get_soul_stone_drop_chance() -> float:
	if player.abilities.has("soul_binding"):
		return min(0.05 + 0.005 * player.abilities.soul_binding.level, 0.25)
	return 0.05

func get_empty_soul_stone():
	for item in player_inventory:
		if item.type == "material" && item.has("tags") && "cage" in item.tags:
			return item

func extract_soul() -> float:
	for item in player_inventory:
		if item.type == "material" && item.has("tags") && "soul" in item.tags:
			var scaling: float = max(sqrt(1.0 + float(item.quality) / 200.0 + 0.01*player.abilities.soul_binding.level) - 1.0, 0.0)
			item.name = Items.materials.empty_soul_stone.name.pick_random().capitalize()
			item.tags = ["cage"]
			item.quality = int(item.quality * 0.75)
			item.price /= 4
			item.erase("add")
			item.description = Items.create_tooltip(item)
			item.description_plain = Skills.tooltip_remove_bb_code(item.description)
			emit_signal("inventory_changed", player_inventory)
			use_ability("soul_binding", 2.0)
			add_ability_exp("soul_binding", 10.0)
			return scaling
	return 0.0

func pick_enchantment(item: Dictionary) -> String:
	if "enchantments" in item:
		if "minor" in item.enchantments && "greator" not in item.enchantments:
			return Items.Enchantment.enchantments_by_tier_and_slot.regular.greater.pick_random()
		elif "greater" in item.enchantments && "minor" not in item.enchantments:
			return Items.Enchantment.enchantments_by_tier_and_slot.regular.minor.pick_random()
	return Items.Enchantment.enchantments_by_tier.regular.pick_random()

func level_up():
	var text: String
	player.experience -= get_max_exp(player.level)
	player.level += 1
	text = tr("LEVEL_UP_LOG").format({"level": player.level})
	print_log_msg("\n" + text)
	print_summary_msg(text)
	distribute_stat_points()
	if player.level%20 == 10:
		learn_new_ability()
	elif player.level%5 == 0:
		learn_new_skill()
	upgrade_skill()
	if player_settings.auto_update_options:
		player_settings.valid_potion_types = ["health"]
		for skill in player.skills:
			if "cost" not in skill:
				continue
			for k in skill.cost.keys():
				if k == "focus":
					continue
				if k not in player_settings.valid_potion_types:
					player_settings.valid_potion_types.push_back(k)
	print_log_msg("\n")
	
	store_historical_data("level", player.level)

func add_exp(amount: int):
	player.experience += amount
	player_exp += amount
	if player.experience >= get_max_exp(player.level):
		level_up()

func add_guild_exp(type: String, exp_scale := 1.0):
	for guild in player_guild_exp.keys():
		if type in Guilds.GUILDS[guild].exp_gain:
			player_guild_exp[guild] += int(ceil(exp_scale * Guilds.GUILDS[guild].exp_gain[type]))
	emit_signal("guilds_updated")

func guild_level_up(guild: String):
	var item: Dictionary
	var amount := 1
	var text: String
	player_guild_exp[guild] -= Guilds.get_max_exp(player_guild_lvl[guild])
	player_guild_lvl[guild] += 1
	text = tr("GUILD_LEVEL_UP").format({"guild": tr(Guilds.GUILDS[guild].name.to_upper()), "rank": Guilds.get_rank(player_guild_lvl[guild], guild)})
	print_log_msg("\n" + text)
	print_summary_msg(text)
	
	match Guilds.GUILDS[guild].equipment_reward.pick_random():
		"accessoiry":
			var valid:= ["rope_amulet", "metal_amulet"]
			if player.level>=EQUIPMENT_LEVEL_RESTRICTION.cape:
				valid += ["cloth_cape", "metal_cape"]
			if player.level>=EQUIPMENT_LEVEL_RESTRICTION.belt:
				valid += ["rope_belt", "leather_belt", "chain_belt"]
			if player.level>=EQUIPMENT_LEVEL_RESTRICTION.ring:
				valid += ["metal_ring", "leather_ring"]
			if player.level>=EQUIPMENT_LEVEL_RESTRICTION.earring:
				valid += ["gem_earring", "orb_earring"]
			if player.level>=EQUIPMENT_LEVEL_RESTRICTION.bracelet:
				valid += ["metal_bracelet", "wood_bracelet"]
			item = create_shop_equipment(valid.pick_random(), 1.5)
		"heavy_weapon":
			if player.abilities.has("archery"):
				if player.abilities.has("light_weapons") || player.abilities.has("heavy_weapons") || player.abilities.has("dirty_fighting"):
					item = create_shop_equipment(["sword", "axe", "mace", "greatsword", "battleaxe", "greatmaul", "scythe", "bow", "crossbow", "blunderbuss"].pick_random(), 1.5)
				else:
					item = create_shop_equipment(["bow", "crossbow", "blunderbuss"].pick_random(), 1.5)
			else:
				item = create_shop_equipment(["sword", "axe", "mace", "greatsword", "battleaxe", "greatmaul", "scythe"].pick_random(), 1.5)
		"light_weapon":
			if player.abilities.has("archery"):
				if player.abilities.has("light_weapons") || player.abilities.has("heavy_weapons") || player.abilities.has("dirty_fighting"):
					item = create_shop_equipment(["dagger", "sword", "spear", "sling", "pistol"].pick_random(), 1.5)
				else:
					item = create_shop_equipment(["sling", "pistol"].pick_random(), 1.5)
			else:
				item = create_shop_equipment(["dagger", "sword", "spear"].pick_random(), 1.5)
		"ranged_weapon":
			item = create_shop_equipment(["sling", "pistol", "bow", "crossbow", "blunderbuss"].pick_random(), 1.5)
		"magic_weapon":
			item = create_shop_equipment(["quarterstaff", "magestaff", "tome", "orb", "amplifier"].pick_random(), 1.5)
		"shield":
			item = create_shop_equipment(["buckler", "kite_shield", "tower_shield"].pick_random(), 1.5)
		"cloth_armour":
			item = create_shop_equipment(["cloth_shirt", "cloth_pants"].pick_random(), 1.5)
		"leather_armour":
			item = create_shop_equipment(["leather_chest", "leather_pants"].pick_random(), 1.5)
		"chain_armour":
			item = create_shop_equipment(["chain_cuirass", "plate_cuirass", "chain_greaves", "plate_greaves"].pick_random(), 1.5)
		"material":
			if current_region.location_resources.has(current_location):
				item = Items.create_regional_material(pick_random_resource(), current_region, 1.5)
			else:
				item = Items.create_regional_material(current_region.resources.pick_random(), current_region, 1.5)
			amount = randi_range(10, 14)
	item.source = tr("GUILD_REWARD").format({"guild": tr(Guilds.GUILDS[guild].name.to_upper())})
	item.description = Items.create_tooltip(item)
	item.description_plain = Skills.tooltip_remove_bb_code(item.description)
	add_item(item, amount)
	optimize_equipment()
	print_log_msg(tr("GUILD_ITEM_REWARD").format(item))
	store_historical_data("guilds", player_guild_lvl[guild], guild)
	emit_signal("guilds_updated")

func pick_random_resource() -> String:
	if current_region.locations[current_location].resources.size() > 0:
		return current_region.locations[current_location].resources.pick_random()
	else:
		return Items.materials.keys().pick_random()


func recalc_attributes():
	player.recalc_attributes()

func distribute_stat_points():
	var dict := {}
	var sum := 0.0
	for k in player_stat_preference.keys():
		sum += player_stat_preference[k]
		dict[k] = sum
	for i in range(Characters.STAT_POINTS_PER_LEVEL):
		if randf() < 0.1:
			player.stats.constitution += 1
			continue
		var rnd := randf()*sum
		for k in dict.keys():
			if rnd <= dict[k]:
				player.stats[k] += 1
				break
	for stat in player.stats:
		store_historical_data("stats", player.stats[stat], stat)

func get_max_potions() -> int:
	return MAX_POTIONS + int(sqrt(player.level))

func get_task_ID() -> int:
	var time_zone := Time.get_time_zone_from_system()
	var data := Time.get_time_dict_from_unix_time(int(current_time + 60 * time_zone.bias))
	var hour: int = posmod(data.hour + time_offset, 24)
	var index := timetable.size()
	for i in range(timetable.size() - 1, -1, -1):
		if timetable.keys()[i] >= hour && i <= index:
			index = i
	if index >= timetable.size():
		index = timetable.size()-2
	return index

func pick_random_materials(dict: Dictionary) -> Array:
	var materials := []
	if dict.has("components"):
		for c in dict.components:
			var valid_materials:= []
			var mat_types: Array = Items.equipment_components[c].material
			for item in player_inventory:
				if item.type != "material":
					continue
				for k in item.tags:
					if k in mat_types:
						valid_materials.push_back(item)
						break
			if valid_materials.size() > 0:
				materials.push_back(valid_materials.pick_random())
	elif dict.has("material_types"):
		for mat_types in dict.material_types:
			var valid_materials := []
			for item in player_inventory:
				if item.type != "material":
					continue
				for k in item.tags:
					if k in mat_types:
						valid_materials.push_back(item)
						break
			if valid_materials.size() > 0:
				materials.push_back(valid_materials.pick_random())
	return materials

func pick_recipe() -> String:
	var valid_recipes: Array[String] = []
	for ability in player.abilities:
		if ability == "alchemy":
			continue
		
		var ability_data:= Skills.ABILITIES[ability]
		if "recipes" not in ability_data:
			continue
		
		for recipe in ability_data.recipes:
			if recipe in player_settings.disabled_recipes:
				continue
			
			valid_recipes.push_back(recipe)
	
	if valid_recipes.size() > 0:
		return valid_recipes.pick_random()
	return ""

func get_recipe_abilities(recipe: String) -> Array[String]:
	var abilities: Array[String] = []
	for ability in player.abilities:
		var ability_data:= Skills.ABILITIES[ability]
		if "recipes" not in ability_data or recipe not in ability_data.recipes:
			continue
		
		abilities.push_back(ability)
	
	return abilities

func get_recipe_level(recipe: String) -> int:
	var level:= 0
	for ability in player.abilities:
		var ability_data:= Skills.ABILITIES[ability]
		if "recipes" not in ability_data or recipe not in ability_data.recipes:
			continue
		
		if player.abilities[ability].level > level:
			level = player.abilities[ability].level
	
	return level


func next_chapter():
	var title:= Story.get_title(quest_chapter + 1)
	var pos:= quest_log.rfind("[center]Chapter")
	var npcs:= {}
	quest_progress = 0
	quest_chapter += 1
	for _i in range(min(randi_range(2, 5),Story.persons.size())):
		var k: String = Story.persons.keys().pick_random()
		npcs[k] = Story.persons[k]
	for k in Story.persons.keys():
		if "story" in Story.persons[k].tags && randf() < 0.5:
			npcs[k] = Story.persons[k]
	Story.persons = npcs
	for i in range(max(randi_range(15, 30) - Story.persons.size(), 0)):
		if randf() < 0.1:
			Story.create_person(Names.NAME_DATA.keys().pick_random(), current_region.cities.keys().pick_random())
		else:
			Story.create_person(current_region.race.pick_random(), current_region.cities.keys().pick_random())
	if quest_chapter > 0:
		@warning_ignore("integer_division")
		var item:= Items.create_legendary_equipment(player.equipment.values().pick_random().base_type, maxi(10 * (current_region.tier + 1) + (player.level + current_region.level) / 2, 1))
		var log_text:= tr("QUEST_ARTIFACT_REWARD").format({"item":item.name, "description":item.description_plain, "chapter":quest_chapter})
		var journal_text:= tr("CHAPTER_CONCLUDED").format({"chapter":quest_chapter})
		print_log_msg(log_text)
		print_summary_msg(journal_text)
		add_item(item)
		optimize_equipment()
	
	if pos >= 0:
		var rpos: = quest_log.find('\n', pos + 1)
		quest_log = quest_log.left(rpos) + "\n[center]- [color=green]done[/color] -[/center]\n"
	var text:= tr("CHAPTER_STARTED").format({"title":title})
	quest_log += "[center]Chapter " + str(quest_chapter + 1) + ": [u]" + title + "[/u][/center]"
	print_log_msg("\n" + text)
	print_summary_msg(text)
	update_quest_log()
	
	if abs(player.level - current_region.level) >= 4:
		var region:= Regions.select_next_region(player.level)
		do_action("wander", {"region":region, "region_type":tr(region.to_upper())}, QUICKTRAVEL_DELAY)

func start_quest():
	var quest:= Story.next_quest(current_region)
	print_log_msg(tr("QUEST_ACCEPTED")+"\n"+quest.name)
	if quest.has("npc"):
		if quest.npc.location == current_location:
			print_log_msg("[color=blue][hint=" + Story.get_person_description(quest.npc) + "]" + quest.npc.name + '[/hint][/color]: "' + Names.GREETINGS[quest.npc.personality].pick_random() + '"')
		else:
			quest.npc.location = current_location
	quest_log += "\n• " + quest.name
	current_quest = quest
	if quest.requires.has("loot"):
		for k in quest.requires.loot:
			var item:= create_shop_equipment(k, randf_range(0.9,1.1))
			item.source = tr("FOUND_IN_LOCATION").format({"location": current_location})
			item.description = Items.create_tooltip(item)
			item.description_plain = Skills.tooltip_remove_bb_code(item.description)
			loot.push_back(item)
	update_quest_log()

func quest_done():
	var pos:= quest_log.rfind('•') + 1
	if current_quest.has("log"):
		print_log_msg(current_quest.log)
	if current_quest.has("npc") && current_quest.npc.location == current_location:
		print_log_msg("[color=blue][hint=" + Story.get_person_description(current_quest.npc) + "]" + current_quest.npc.name + '[/hint][/color]: "' + Names.QUEST_DONE[current_quest.npc.personality].pick_random() + '"')
	quest_progress += 1
	if current_quest.has("guild"):
		player_guild_exp[current_quest.guild] += 50
		emit_signal("guilds_updated")
	if current_quest.has("reward"):
		if current_quest.reward.has("exp"):
			add_exp(current_quest.exp)
		if current_quest.has("equipment_chance") && randf() < current_quest.equipment_chance:
			var item:= create_shop_equipment(player.equipment.values().pick_random().base_type)
			if current_quest.has("person"):
				item.source = tr("QUEST_REWARD_PERSON").format(current_quest)
			elif current_quest.has("location"):
				item.source = tr("QUEST_REWARD_LOCATION").format(current_quest)
			else:
				item.source = tr("QUEST_REWARD")
			item.description = Items.create_tooltip(item)
			item.description_plain = Skills.tooltip_remove_bb_code(item.description)
			print_log_msg(tr("QUEST_ITEM_REWARD").format(item))
			add_item(item)
			optimize_equipment()
		elif current_quest.has("potion_chance") && randf()<current_quest.potion_chance:
			var item:= create_shop_potion()
			if current_quest.has("person"):
				item.source = tr("QUEST_REWARD_PERSON").format(current_quest)
			elif current_quest.has("location"):
				item.source = tr("QUEST_REWARD_LOCATION").format(current_quest)
			else:
				item.source = tr("QUEST_REWARD")
			item.description = Items.create_tooltip(item)
			item.description_plain = Skills.tooltip_remove_bb_code(item.description)
			print_log_msg(tr("QUEST_ITEM_REWARD").format(item))
			player_potions.push_back(item)
			emit_signal("potion_inventory_changed", player_potions)
		elif current_quest.reward.has("gold"):
			player_gold += current_quest.reward.gold
			emit_signal("gold_changed", player_gold)
	current_quest.clear()
	quest_log = quest_log.left(pos) + "[color=dark_gray][s]" + quest_log.substr(pos) + "[/s][/color]"
	update_quest_log()
	if quest_progress>=QUESTS_PER_CHAPTER + quest_chapter*QUESTS_INCREASE_PER_CHAPTER:
		next_chapter()
		return
	do_action("questing", {}, QUESTING_DELAY)


func use_stat(stat: String, amount:= 1.0):
	if player_stat_preference.has(stat):
		player_stat_preference[stat] += amount
	else:
		player_stat_preference[stat] = amount

func use_ability(ability: String, amount:= 1.0):
	if player_ability_preference.has(ability):
		player_ability_preference[ability] += amount
	else:
		player_ability_preference[ability] = amount

func add_ability_exp(ability: String, amount: float):
	var a:= player.abilities[ability]
	var ability_level_up:= a.add_exp(ceili(amount))
	if ability_level_up:
		if a.level > 10:
			upgrade_skill()
		store_historical_data("abilities", a.name, ability)

func do_action(action: String, args: Dictionary, delay: float, string:=""):
	player.delay = delay
	player_delay = delay
	player.action_duration = delay
	current_action = {
		"action": action,
		"args": args,
	}
	if string.length()==0:
		string = tr(action.to_upper()+"_DESC").format(args)
	current_action_text = string
	player.current_action = string

func action_done(action: Dictionary):
	match action.action:
		"goto":
			current_location = action.args.location
			if current_location in explored_locations:
				print_log_msg("\n" + tr("GOTO_LOG").format(action.args))
			else:
				var text:= tr("DISCOVER_LOG").format(action.args)
				explored_locations.push_back(current_location)
				print_log_msg("\n" + text)
				print_summary_msg(text)
				add_guild_exp("exploration")
			if current_location in current_region.cities:
				for guild in player_guild_exp.keys():
					if player_guild_exp[guild] >= Guilds.get_max_exp(player_guild_lvl[guild]):
						guild_level_up(guild)
				if player.level >= 20*player_guild_lvl.size() - 10:
					var guild:= Guilds.pick_guild(player.abilities.keys(), player_guild_lvl.keys())
					if guild != "":
						join_guild(guild)
			emit_signal("location_changed", current_region, current_location)
		"engage":
			for c in enemies:
				c.position += sign(player.position-c.position)
		"find_enemies":
			if randf() < current_region.resource_chance:
				for i in range(randi_range(current_region.resource_amount[0], current_region.resource_amount[1])):
					var item:= Items.create_regional_material(pick_random_resource(), current_region)
					item.source = tr("HARVESTED_IN_LOCATION").format({"location": current_location})
					item.description = Items.create_tooltip(item)
					item.description_plain = Skills.tooltip_remove_bb_code(item.description)
					loot.push_back(item)
				print_log_msg("\n"+tr("FIND_RESOURCE_LOG"))
				add_guild_exp("harvest",loot.size())
			else:
				var enemy_list:= ""
				var valid_enemies:= []
				var tier_sum:= 0
				loot.clear()
				enemies.clear()
				player_summons.clear()
				player.position = 1
				if current_region.locations[current_location].enemies.size() > 0:
					valid_enemies = current_region.locations[current_location].enemies
				else:
					valid_enemies = current_region.enemies
				for i in range(randf_range(current_region.enemy_amount[0], current_region.enemy_amount[1])):
					@warning_ignore("integer_division")
					var lvl: int = max(min((current_region.level + player.level) / 2, current_region.level + 15) + randi()%5 - 2, 1)
					var tier: int = clamp(round(randf_range(-1.25,1.25) - 0.5*tier_sum), -2, 2)
					tier_sum += tier
					enemies.push_back(Enemies.create_enemy(valid_enemies.pick_random(), lvl,  current_region.tier + tier))
				action.args.enemy_list = make_desc_list(enemies)
				print_log_msg("\n"+tr("FIND_ENEMIES_LOG").format(action.args))
				update_characters()
				if player.abilities.has("trapping"):
					var trap: Dictionary = Skills.TRAPS.values().pick_random().duplicate(true)
					var target: Characters.Enemy = enemies.pick_random()
					var status:= Characters.create_status(trap, player, target, 1.0 + 0.2 * (player.abilities.trapping.level - 1))
					var dict:= status.duplicate()
					trap.level = 2 * player.abilities.trapping.level - 1
					dict.name = dict.name.capitalize()
					dict.description = Skills.tooltip_remove_bb_code(Skills.create_tooltip(trap))
					print_log_msg(tr("TRAPPING_LOG").format(dict))
					target.add_status(status)
					use_ability("trapping", 1.0)
					add_ability_exp("trapping", 2.0)
					if typeof(trap.effect_stat)==TYPE_ARRAY:
						for k in trap.effect_stat:
							use_stat(k, 0.5)
					else:
						use_stat(trap.effect_stat, 0.5)
					add_guild_exp("trapping")
		"find_quest_enemies":
			loot.clear()
			enemies.clear()
			player_summons.clear()
			player.position = 1
			for i in range(action.args.amount):
				@warning_ignore("integer_division")
				var lvl: int = max(min((current_region.level + player.level) / 2, current_region.level + 20) + randi()%5 - 2, 1)
				enemies.push_back(Enemies.create_enemy(action.args.enemy, lvl,  current_region.tier))
			action.args.enemy_list = make_desc_list(enemies)
			print_log_msg("\n"+tr("FIND_ENEMIES_LOG").format(action.args))
			update_characters()
			if player.abilities.has("trapping"):
				var trap: Dictionary = Skills.TRAPS.values().pick_random()
				var target: Characters.Enemy = enemies.pick_random()
				var status:= Characters.create_status(trap, player, target, 1.0 + 0.2 * (player.abilities.trapping.level - 1))
				print_log_msg(tr("TRAPPING_LOG").format(status))
				target.add_status(status)
				use_ability("trapping", 1.0)
				if typeof(trap.effect_stat)==TYPE_ARRAY:
					for k in trap.effect_stat:
						use_stat(k, 0.5)
				else:
					use_stat(trap.effect_stat, 0.5)
				add_guild_exp("trapping")
		"find_dummy":
			loot.clear()
			enemies.clear()
			player_summons.clear()
			player.position = 1
			enemies.push_back(Enemies.create_enemy("dummy", current_region.level,  current_region.tier - 1 + randi()%3))
			action.args.enemy_list = make_desc_list(enemies)
			print_log_msg("\n"+tr("FIND_DUMMY_LOG").format(action.args))
			update_characters()
			if player.abilities.has("trapping"):
				var trap: Dictionary = Skills.TRAPS.values().pick_random()
				var target: Characters.Enemy = enemies.pick_random()
				var status:= Characters.create_status(trap, player, target, 1.0 + 0.2 * (player.abilities.trapping.level - 1))
				print_log_msg(tr("TRAPPING_LOG").format(status))
				target.add_status(status)
				use_ability("trapping", 1.0)
				add_ability_exp("trapping", 2.0)
				if typeof(trap.effect_stat)==TYPE_ARRAY:
					for k in trap.effect_stat:
						use_stat(k, 0.5)
				else:
					use_stat(trap.effect_stat, 0.5)
		"loot":
			for item in loot:
				add_item(item)
				if item.has("enchanted") && item.enchanted:
					add_guild_exp("identifiy")
				elif item.type!="material":
					add_guild_exp("identifiy", 0.1)
			action.args.item_list = make_desc_list(loot)
			loot.clear()
			print_log_msg(tr("LOOT_LOG").format(action.args))
			add_guild_exp("loot")
		"quaff_potion":
			var item
			if action.args.has("type"):
				item = pick_potion(action.args.type)
			if item==null || !player_potions.has(item):
				item = player_potions.pick_random()
			print_log_msg(tr("QUAFF_POTION_LOG").format(item))
			quaff_potion(item)
			player_potions.erase(item)
			emit_signal("potion_inventory_changed", player_potions)
		"retreat":
			enemies.clear()
			player_summons.clear()
			player.position = 1
			update_characters()
			print_log_msg("\n"+tr("RETREAT_LOG").format(action.args))
			do_action("recover", {}, RECOVER_DELAY/(1.0 + float(player.abilities.has("healing"))))
			use_stat("constitution", 6)
			player_battles_lost += 1
			return
		"recover":
			enemies.clear()
			player_summons.clear()
			player.position = 1
			player.recover()
			update_characters()
			print_log_msg("\n"+tr("RECOVER_LOG").format(action.args))
			use_stat("constitution", 2)
		"selling":
			if player_inventory.size() > 0:
				var item: Dictionary = player_inventory.pick_random()
				var price:= sell_item(item)
				var description: String = item.get("description_plain", item.get("description", ""))
				print_log_msg(tr("SOLD_LOG").format({"name": item.name, "description": description, "amount": 1, "price": price}))
				add_guild_exp("sell")
			else:
				action_failures += 1
		"sell_potions":
			var sold:= false
			for potion in player_potions:
				if !(potion.effect in player_settings.valid_potion_types) or player_potions.size() > get_max_potions():
					var price:= sell_item(potion)
					var description: String = potion.get("description_plain", potion.get("description", ""))
					player_potions.erase(potion)
					print_log_msg(tr("SOLD_LOG").format({"name": potion.name, "description": description, "amount": 1, "price": price}))
					sold = true
					emit_signal("potion_inventory_changed", player_potions)
					break
			if !sold:
				print_log_msg(tr("POTIONS_SORTED_LOG"))
				action_failures += 1
		"buy_equipment":
			var type:= ""
			var replace: String
			if randf()<0.75:
				replace = get_worst_equipment_type()
				type = replace
				if type=="mainhand":
					type = "weapon"
					replace = "weapon"
				elif type=="offhand":
					type = "weapon"
					replace = "offweapon"
				else:
					type = get_slot_type(type)
				
				if player.equipment.has(replace):
					type = player.equipment[replace].base_type
				else:
					type = Items.pick_random_equipment(type)
			if type == "":
				var item: Dictionary
				type = Items.equipment_recipes.keys().pick_random()
				while EQUIPMENT_LEVEL_RESTRICTION.has(Items.equipment_recipes[type].type) && \
					player.level < EQUIPMENT_LEVEL_RESTRICTION[Items.equipment_recipes[type].type]:
						type = Items.equipment_recipes.keys().pick_random()
				item = Items.equipment_recipes[type]
				replace = item.type
				if replace == "weapon":
					if !("2h" in item && item["2h"]):
						if randf() < 0.5:
							replace = "offweapon"
				elif replace in EQUIPMENT_LR_TYPES:
					replace += ["_left", "_right"][randi() % 2]
			if type != "":
				var item: Dictionary
				if type not in Items.equipment_recipes:
					type = Items.pick_random_equipment(type)
				if type == "":
					type = Items.equipment_recipes.keys().pick_random()
				item = create_shop_equipment(type)
				if replace not in player.equipment || \
					compare_items([item], [player.equipment[replace]]) > 0:
						var bought:= buy_item(item)
						if bought:
							print_log_msg(tr("BUY_LOG").format({
								"name": item.name,
								"description": item.description_plain,
								"amount": 1,
								"price": item.price,
							}))
							equip(item)
							add_guild_exp("buy",2.0)
						else:
							print_log_msg(tr("BUY_NOTHING_PRICE_TOO_HIGH_LOG"))
							action_failures += 1
				else:
					print_log_msg(tr("BUY_NOTHING_POOR_QUALITY_LOG"))
					action_failures += 1
			else:
				print_log_msg(tr("BUY_NOTHING_LOG"))
				action_failures += 1
		"buy_potions":
			var item:= create_shop_potion()
			var bought:= buy_item(item)
			if bought:
				print_log_msg(tr("BUY_LOG").format({"name": item.name, "description": item.description_plain, "amount": 1, "price": item.price}))
				player_potions.push_back(item)
				emit_signal("potion_inventory_changed", player_potions)
				add_guild_exp("buy")
			else:
				print_log_msg(tr("BUY_NOTHING_PRICE_TOO_HIGH_LOG"))
				action_failures += 1
		"buy_materials":
			var item:= create_shop_material()
			if item.size() == 0:
				print_log_msg(tr("BUY_NOTHING_LOG"))
				action_failures += 5
			else:
				var bought:= buy_item(item)
				if bought:
					print_log_msg(tr("BUY_LOG").format({
						"name": item.name,
						"description": item.description_plain,
						"amount": 1, 
						"price": item.price,
					}))
					add_item(item)
					add_guild_exp("buy", 0.5)
				else:
					print_log_msg(tr("BUY_NOTHING_PRICE_TOO_HIGH_LOG"))
					action_failures += 1
		"rest":
			player.recover()
			print_log_msg(tr("REST_LOG"))
		"sleep":
			player.recover()
			print_log_msg(tr("SLEEP_LOG"))
		"craft":
			var materials:= pick_random_materials(Items.equipment_recipes[action.args.recipe])
			if materials.size() == Items.equipment_recipes[action.args.recipe].components.size():
				var item: Dictionary
				item = Items.craft_equipment(action.args.recipe, materials, 10.0 * (action.args.level - 1.0))
				item.source += "\n" + tr("PLAYER_CREATION")
				item.description = Items.create_tooltip(item)
				item.description_plain = Skills.tooltip_remove_bb_code(item.description)
				add_item(item)
				print_log_msg(tr("CRAFT_EQUIPMENT_LOG").format({"name":item.name, "description":item.description_plain, "quality":str(int(item.quality))}))
				for ability in get_recipe_abilities(action.args.recipe):
					add_ability_exp(ability, 20.0)
				for mat in materials:
					remove_item(mat)
				add_guild_exp("craft")
			else:
				action_failures += 1
				print_log_msg(tr("MISSING_MATERIALS_LOG"))
		"enchanting":
			var crafted:= false
			for k in player.equipment.keys():
				if player.equipment[k].has("enchantment_potential") && player.equipment[k].enchantment_potential <= 0:
					continue
				var item: Dictionary = player.equipment[k]
				var enchantment:= pick_enchantment(item)
				var dict: Dictionary = Items.Enchantment.enchantments[enchantment]
				var materials:= pick_random_materials(dict)
				if materials.size()==dict.material_types.size():
					item = Items.enchant_equipment_material(item, enchantment, materials, 10.0*(action.args.level-1.0))
					if tr("PLAYER_ENCHANTED") not in item.source:
						item.source += "\n" + tr("PLAYER_ENCHANTED")
					item.description = Items.create_tooltip(item)
					item.description_plain = Skills.tooltip_remove_bb_code(item.description)
					player.equipment[k] = item
					print_log_msg(tr("ENCHANT_EQUIPMENT_LOG").format({"name":item.name, "description":item.description_plain, "quality":str(int(item.quality))}))
					add_ability_exp(action.args.ability, 50.0)
					for mat in materials:
						remove_item(mat)
					add_guild_exp("enchant")
				else:
					action_failures += 1
					print_log_msg(tr("MISSING_MATERIALS_LOG"))
				crafted = true
				break
			if !crafted:
				for item in player_inventory:
					if item.type=="material" || (item.has("enchanted") && item.enchanted):
						continue
					var enchantment:= pick_enchantment(item)
					var dict: Dictionary = Items.Enchantment.enchantments[enchantment]
					var materials:= pick_random_materials(dict)
					if materials.size()==dict.material_types.size():
						remove_item(item)
						item = Items.enchant_equipment_material(item, enchantment, materials,
							10.0 * (action.args.level - 1.0))
						item.source += "\n" + tr("PLAYER_ENCHANTED")
						item.description = Items.create_tooltip(item)
						item.description_plain = Skills.tooltip_remove_bb_code(item.description)
						add_item(item)
						print_log_msg(tr("ENCHANT_EQUIPMENT_LOG").format({
							"name": item.name,
							"description": item.description_plain,
							"quality": str(int(item.quality)),
						}))
						optimize_equipment()
						add_ability_exp(action.args.ability, 50.0)
						for mat in materials:
							remove_item(mat)
						add_guild_exp("enchant")
					else:
						action_failures += 1
						print_log_msg(tr("MISSING_MATERIALS_LOG"))
					break
		"alchemy":
			var type: String = Skills.ABILITIES[action.args.ability].recipes.pick_random()
			var materials:= pick_random_materials(Items.potion_recipes[type])
			if materials.size() == Items.potion_recipes[type].material_types.size():
				var item: Dictionary
				item = Items.craft_potion(type, materials, 10.0 * (action.args.level - 1.0))
				item.source += "\n" + tr("PLAYER_CREATION")
				item.description = Items.create_tooltip(item)
				item.description_plain = Skills.tooltip_remove_bb_code(item.description)
				player_potions.push_back(item)
				emit_signal("potion_inventory_changed", player_potions)
				print_log_msg(tr("CRAFT_POTION_LOG").format({"name":item.name, "description":item.description_plain, "quality":str(int(item.quality))}))
				add_ability_exp(action.args.ability, 20.0)
				for mat in materials:
					remove_item(mat)
				add_guild_exp("alchemy")
			else:
				action_failures += 1
				print_log_msg(tr("MISSING_MATERIALS_LOG"))
		"cook":
			var type: String = Items.food_recipes.keys().pick_random()
			var materials:= pick_random_materials(Items.food_recipes[type])
			if materials.size() == Items.food_recipes[type].material_types.size():
				var item: Dictionary
				item = Items.cook(type, materials, 10.0 * (action.args.level - 1.0))
				print_log_msg(tr("COOKING_LOG").format({
					"name": item.name,
					"description": item.description_plain,
					"quality": str(int(item.quality)),
				}))
				add_ability_exp("cooking", 40.0)
				if item.has("status"):
					var status:= Characters.create_status(item.status, player, player)
					player.status.push_back(status)
					update_characters()
				for mat in materials:
					remove_item(mat)
				add_guild_exp("cook")
			else:
				action_failures += 1
				print_log_msg(tr("MISSING_MATERIALS_LOG"))
			player_cooking_delay = COOKING_ATTEMPT_DELAY
		"talk":
			print_log_msg(tr("TALK_LOG").format(action.args))
			add_guild_exp("quest")
		"collect":
			Story.add_quest_item(action.args.item, 1)
			emit_signal("story_inventory_changed", Story.inventory)
			print_log_msg(tr("COLLECT_LOG").format({"item": action.args.item.name, "item_description": action.args.item.description}))
			add_guild_exp("quest")
		"deliver":
			Story.remove_quest_item(action.args.item, action.args.amount)
			emit_signal("story_inventory_changed", Story.inventory)
			add_guild_exp("quest")
		"visit":
			player.recover()
			print_log_msg(tr("VISIT_LOG").format(action.args))
		"visit_church":
			if action.args.has("god_dict"):
				var status:= Characters.create_status(action.args.god_dict, player, player)
				for dict in player.status:
					if dict.type=="blessing":
						player.remove_status(dict)
				for k in status.keys():
					if typeof(status[k]) == TYPE_FLOAT && !("duration" in k):
						status[k] *= 1.0 + 0.1 * (player.level - 1)
				if status.has("attributes"):
					for k in status.attributes.keys():
						status.attributes[k] *= 1.0 + 0.1 * (player.level - 1)
				player.add_status(status)
			player.recover()
			print_log_msg(tr("VISIT_CHURCH_LOG").format(action.args))
			add_guild_exp("visit_church")
		"craft_quest":
			var item_types:= []
			for k in player.abilities.keys():
				if k in Skills.CRAFTING_ABILITIES:
					add_ability_exp(k, 10.0)
				if Skills.ABILITIES.has(k) && Skills.ABILITIES[k].has("recipes"):
					item_types += Skills.ABILITIES[k].recipes
			if item_types.size()==0:
				print_log_msg(tr("CRAFT_QUEST_LOG"))
			else:
				var dict: Dictionary
				var type: String = item_types.pick_random()
				if Items.EQUIPMENT.has(type):
					dict = Items.EQUIPMENT[type]
				elif type in Items.potion_recipes:
					dict = Items.potion_recipes[type]
				if dict.size()==0:
					print_log_msg(tr("CRAFT_QUEST_LOG"))
				else:
					print_log_msg(Story.sanitize_string(tr("CRAFT_QUEST_ITEM_LOG").format(dict)))
		"steal":
			player_gold += int(action.args.amount * 5.0 * (1.0 + 0.1 * (player.level - 1) * (player.level - 1)))
			emit_signal("gold_changed", player_gold)
		"wander":
			var text:= tr("TRAVEL_LOG").format({"region_type": current_region.name})
			for k in player_ability_preference.keys():
				player_ability_preference[k] *= 0.5
			for k in player_stat_preference.keys():
				player_stat_preference[k] *= 0.5
			set_region(action.args.region)
			print_log_msg(text)
			print_summary_msg(text)
	
	# Next action.
	var new_task:= get_task_ID()
	if new_task!=current_task_ID:
		current_task_ID = new_task
		start_task(current_task_ID)
		return
	if enemies.size()>0:
		turn_counter += 1
		
		if player.health<=RETREAT_THRESHOLD*player.max_health || action_failures>50 || turn_counter > 1000:
			enemies.clear()
			player_summons.clear()
			update_characters()
			loot.clear()
			action_failures = 0
			turn_counter = 0
			do_action("retreat", {}, RETREAT_DELAY/(1.0 + float(player.abilities.has("trapping"))))
			return
		elif player.health<=POTION_THRESHOLD*player.max_health && player_potions.size()>0 && player_potion_delay<=0.0:
			do_action("quaff_potion", {"type": "health"}, POTION_DELAY)
			return
		elif player.mana<=0.5*POTION_THRESHOLD*player.max_mana && player_potions.size()>0 && player_potion_delay<=0.0:
			do_action("quaff_potion", {"type": "mana"}, POTION_DELAY)
			return
		elif player.stamina<=0.5*POTION_THRESHOLD*player.max_stamina && player_potions.size()>0 && player_potion_delay<=0.0:
			do_action("quaff_potion", {"type": "stamina"}, POTION_DELAY)
			return
	elif enemies.size() == 0:
		turn_counter = 0
		if loot.size()>0:
			do_action("loot", {}, LOOT_DELAY)
			return
		elif player.health<=RECOVER_THRESHOLD*player.max_health:
			do_action("recover", {}, RECOVER_DELAY/(1.0 + float(player.abilities.has("healing"))))
			return
		elif player.health<=POTION_THRESHOLD*player.max_health || player.stamina<0.25*player.max_stamina || player.mana<0.25*player.max_mana:
			do_action("recover", {}, RECOVER_DELAY/(1.0 + float(player.abilities.has("healing")))/2.0)
			return
	match current_task:
		"training":
			if enemies.size() == 0:
				if player.health<player.max_health || player.stamina<0.25*player.max_stamina || player.mana<0.25*player.max_mana:
					do_action("recover", {}, RECOVER_DELAY/(1.0 + float(player.abilities.has("healing"))))
				else:
					do_action("find_dummy", {}, SEARCH_DELAY)
			else:
				fight()
		"grinding":
			if enemies.size() == 0:
				if player.abilities.has("cooking") && player_cooking_delay<=0.0:
					do_action("cook", {"level": player.abilities.cooking.level}, CRAFTING_DELAY)
				else:
					do_action("find_enemies", {}, SEARCH_DELAY)
			else:
				fight()
		"questing":
			if quest_chapter < 0:
				next_chapter()
				return
			if current_quest.size() == 0:
				start_quest()
			elif enemies.size() > 0:
				fight()
				return
			else:
				current_quest.stage += 1
			if current_quest.has("location") && current_location != current_quest.location:
				do_action("goto", {"location": current_quest.location}, TRAVEL_DELAY)
				return
			match current_quest.action:
				"talk":
					if current_quest.stage<1:
						do_action("talk", {"name": current_quest.npc.display_name, "description": Story.get_person_description(current_quest.npc)}, QUESTING_DELAY)
					else:
						quest_done()
					return
				"fetch_rumours":
					if current_quest.stage<current_quest.amount:
						do_action("fetch_rumours", {"city": current_quest.city}, QUESTING_DELAY)
					else:
						quest_done()
					return
				"look_for_clues":
					if current_quest.stage<current_quest.amount:
						if !current_quest.has("location"):
							current_quest.location = current_location
						do_action("look_for_clues", {"location": current_quest.location}, QUESTING_DELAY)
					else:
						quest_done()
					return
				"search":
					if current_quest.stage < current_quest.amount:
						do_action("searching", {"location": current_quest.location}, QUESTING_DELAY)
					else:
						quest_done()
					return
				"dig":
					if current_quest.stage < 1:
						if !current_quest.has("location"):
							current_quest.location = current_location
						do_action("dig", {"location": current_quest.location}, QUESTING_DELAY)
					else:
						quest_done()
					return
				"map_location":
					if current_quest.stage < 1:
						do_action("map_location", {"location": current_quest.location}, QUESTING_DELAY)
					else:
						quest_done()
					return
				"collect", "fetch":
					if current_quest.stage < current_quest.amount:
						do_action("collect", {"item": current_quest.item, "item_name": current_quest.item.name, "amount": current_quest.amount}, QUESTING_DELAY)
					else:
						quest_done()
					return
				"deliver":
					if current_quest.stage<1:
						do_action("deliver", {"item": current_quest.item, "item_name": current_quest.item.name, "amount": current_quest.amount, "name": current_quest.npc.display_name, "description":Story.get_person_description(current_quest.npc)}, QUESTING_DELAY)
					else:
						quest_done()
					return
				"retrieve":
					if current_quest.stage<1:
						do_action("searching", {}, QUESTING_DELAY)
					elif current_quest.stage<2:
						Story.add_quest_item(action.args.item, current_quest.amount)
						emit_signal("story_inventory_changed", Story.inventory)
						current_quest.location = current_quest.city
						do_action("questing", {}, QUESTING_DELAY)
					elif current_quest.stage<3:
						do_action("deliver", {"item": current_quest.item, "item_name": current_quest.item.name, "amount": current_quest.amount, "name": current_quest.person}, QUESTING_DELAY)
					else:
						quest_done()
					return
				"fight", "kill":
					if player.abilities.has("cooking") && player_cooking_delay <= 0.0:
						do_action("cook", {"level": player.abilities.cooking.level}, CRAFTING_DELAY)
					elif current_quest.stage < current_quest.amount && enemies.size() == 0:
						if player.abilities.has("cooking") && player_cooking_delay<=0.0:
							current_quest.stage -= 1
							do_action("cook", {"level": player.abilities.cooking.level}, CRAFTING_DELAY)
						else:
							do_action("find_quest_enemies", {"enemy": current_quest.enemy, "amount": 1}, SEARCH_DELAY)
					else:
						quest_done()
					return
				"explore":
					if player.abilities.has("cooking") && player_cooking_delay <= 0.0:
						do_action("cook", {"level": player.abilities.cooking.level}, CRAFTING_DELAY)
					elif current_quest.stage < 1 + current_quest.amount:
						match randi()%4:
							0:
								do_action("find_quest_enemies", {"enemy": Enemies.base_enemies.keys().pick_random(), "amount": 1}, QUESTING_DELAY)
							1:
								var item:= Items.create_regional_material(Items.materials.keys().pick_random(), current_region, 1.1)
								item.source = tr("FOUND_IN_LOCATION").format({"location": current_location})
								item.description = Items.create_tooltip(item)
								item.description_plain = Skills.tooltip_remove_bb_code(item.description)
								loot.push_back(item)
								do_action("loot", {}, QUESTING_DELAY)
							2:
								do_action("searching", {}, QUESTING_DELAY)
							3:
								do_action("making_light", {}, QUESTING_DELAY)
					else:
						quest_done()
					return
				"loot":
					if current_quest.stage<1:
						do_action("loot", {}, QUESTING_DELAY)
					else:
						quest_done()
					return
				"craft_job":
					if current_quest.stage<current_quest.amount+1:
						do_action("craft_quest", {}, QUESTING_DELAY)
					else:
						quest_done()
					return
				"support":
					if current_quest.stage<current_quest.amount+1:
						do_action("support", {}, QUESTING_DELAY)
					else:
						quest_done()
					return
				"steal":
					if current_quest.stage<current_quest.amount+1:
						do_action("steal", {"amount":randi_range(2,14)}, QUESTING_DELAY)
					else:
						quest_done()
					return
			do_action("questing", {}, SEARCH_DELAY)
		"shopping":
			if player_potions.size()>0 && action_failures<1:
				do_action("sell_potions", {}, SHOPPING_DELAY)
			elif player_inventory.size()>0 && action_failures<2:
				do_action("selling", {}, SHOPPING_DELAY)
			elif player_gold > get_equipment_gold_limit() && action_failures < 15:
				action_failures = max(action_failures, 1)
				do_action("buy_equipment", {}, SHOPPING_DELAY)
			elif player_gold > get_potion_gold_limit() && player_potions.size() < get_max_potions() && action_failures < 25:
				do_action("buy_potions", {}, SHOPPING_DELAY)
			elif player_gold>get_material_gold_limit() && action_failures < 30:
				action_failures = max(action_failures, 20)
				do_action("buy_materials", {}, SHOPPING_DELAY)
			else:
				start_task(current_task_ID, "grinding")
		"crafting":
			if player.health<player.max_health:
				do_action("recover", {}, RECOVER_DELAY/(1.0 + float(player.abilities.has("healing"))))
			elif action_failures>25:
				start_task(current_task_ID, "shopping")
			else:
				var valid_tasks:= []
				var crafting_abilities:= []
				var recipe:= pick_recipe()
				for ability in Skills.CRAFTING_ABILITIES:
					if player.abilities.has(ability):
						crafting_abilities.push_back(ability)
				if crafting_abilities.size() > 0 and recipe != "":
					valid_tasks.push_back("crafting")
				if player.abilities.has("enchanting"):
					valid_tasks.push_back("enchanting")
				if player.abilities.has("alchemy"):
					valid_tasks.push_back("alchemy")
				if valid_tasks.size()>0:
					match valid_tasks.pick_random():
						"crafting":
							do_action("craft", {"recipe": recipe, "level": get_recipe_level(recipe)}, CRAFTING_DELAY)
						"enchanting":
							do_action("enchanting", {"ability": "enchanting", "level": player.abilities.enchanting.level}, CRAFTING_DELAY)
						"alchemy":
							do_action("alchemy", {"ability": "alchemy", "level": player.abilities.alchemy.level}, CRAFTING_DELAY)
						_:
							start_task(current_task_ID, "shopping")
				else:
					start_task(current_task_ID, "shopping")
		"resting":
			match randi()%4:
				0:
					var god_dict:= Names.get_god()
					do_action("visit_church", {"god": god_dict.god, "god_dict": god_dict}, REST_DELAY / 2.0)
				_:
					do_action("visit", {"type": tr(HANGOUT_LOCATIONS.pick_random())}, REST_DELAY / 2.0)
		"sleeping":
			var time_zone:= Time.get_time_zone_from_system()
			var time_data:= Time.get_time_dict_from_unix_time(int(current_time + 60 * time_zone.bias))
			do_action("sleep", {}, min(SLEEP_DELAY, 60 * 60 * abs(5.0 - time_data.hour)))
	
	

func pick_skill(actor: Characters.Character):
	var valid_skills := []
	for skill in actor.skills:
		if skill.current_cooldown > 0.0:
			continue
		if skill.has("cost"):
			var valid:= true
			for k in skill.cost.keys():
				if actor.get(k) < skill.cost[k]:
					valid = false
					if actor == player:
						for s in Characters.STATS_METERS.keys():
							if Characters.STATS_METERS[s].has("max_" + k):
								use_stat(s, Characters.STATS_METERS[s]["max_" + k])
					else:
						break
			if !valid:
				continue
		match skill.usage:
			"attack":
				var valid:= false
				if actor is Characters.Enemy:
					if abs(player.position - actor.position) <= skill.range:
						valid = true
					else:
						for c in player_summons:
							if abs(c.position - actor.position) <= skill.range:
								valid = true
								break
				else:
					for c in enemies:
						if abs(c.position - actor.position) <= skill.range:
							valid = true
							break
				if !valid:
					continue
			"heal":
				var valid:= false
				var type:= ""
				for combat_array in skill.combat.healing:
					for c in combat_array:
						var t: String = c.get("type", "")
						if t != "":
							# Prioritize health
							if t == "health":
								type = "health"
							elif type != "health":
								type = t
				if actor is Characters.Enemy:
					for c in enemies:
						if c.get(type) < 0.75 * c.get("max_" + type):
							valid = true
							break
				else:
					if player.get(type) < 0.75 * player.get("max_" + type):
						valid = true
					else:
						for c in player_summons:
							if c.get(type) < 0.75 * c.get("max_" + type):
								valid = true
								break
				if !valid:
					continue
			"summon":
				if actor is Characters.Enemy:
					if enemies.size() >= 4:
						continue
				else:
					if player_summons.size() >= max_summons:
						continue
			"buff":
				if randf() > 2.0 / (actor.status.size() + 1.0) * actor.focus / actor.max_focus:
					continue
		valid_skills.push_back(skill)
	
	if valid_skills.size() > 0:
		return valid_skills.pick_random()

func chose_engagement_target(actor: Characters.Character):
	var min_dist:= 10
	var closest_target: Characters.Character
	if actor is Characters.Enemy:
		min_dist = abs(player.position - actor.position)
		closest_target = player
		for c in player_summons:
			var dist: int = abs(c.position - actor.position)
			if dist < min_dist:
				min_dist = dist
				closest_target = c
	else:
		for c in enemies:
			var dist: int = abs(c.position - actor.position)
			if dist < min_dist:
				min_dist = dist
				closest_target = c
	if min_dist>0:
		return closest_target

func create_damage_info(damage: Dictionary) -> String:
	var text: String = tr("ATTACK") + ": " + str(damage.attack)
	if damage.critical > 0:
		text += " (" + str(int(100*damage.critical)) + "% " + tr("CRITICAL_HIT") + ")"
	if damage.absorbed > 0:
		text += "\n" + tr("ABSORBED") + ": " + str(damage.absorbed)
	if damage.blocked_armour > 0:
		text += "\n" + tr("BLOCKED_BY_ARMOUR") + ": " + str(damage.blocked_armour)
	if damage.blocked_willpower > 0:
		text += "\n" + tr("BLOCKED_BY_WILLPOWER") + ": " + str(damage.blocked_willpower)
	if damage.resisted > 0:
		text += "\n" + tr("RESISTED") + ": " + str(damage.resisted)
	if damage.enhanced > 0:
		text += "\n" + tr("ENHANCED") + ": " + str(damage.enhanced)
	if damage.penetrated > 0:
		text += "\n" + tr("PENETRATED") + ": " + str(damage.penetrated)
	text += "\n" + tr("TOTAL_DAMAGE") + ": " +str(damage.damage)
	return text

func summarize_heal(data: Dictionary) -> String:
	var text:= ""
	for i in range(data.size()):
		text += str(int(data.values()[i])) + " " + tr(data.keys()[i].to_upper())
		if i < data.size() - 1:
			text += ", "
	return text

func merge_dicts(dict: Dictionary, add: Dictionary) -> Dictionary:
	for k in add.keys():
		if dict.has(k):
			if typeof(dict[k]) == TYPE_ARRAY:
				dict[k].push_back(add[k])
			else:
				dict[k] = [dict[k], add[k]]
		else:
			dict[k] = add[k]
	return dict

func use_attack(skill: Dictionary, actor: Characters.Character, target: Characters.Character, dam_multiplier:= 1.0, splash:= false) -> Dictionary:
	var result:= {
		"skill": skill.name,
		"skill_description": skill.description_plain,
		"actor": actor.name,
		"actor_description": "",
		"target": target.name,
		"target_description": "",
		"hit": 0,
		"kill": 0,
		"buff": 0,
		"debuff": 0,
		"total_damage": 0,
		"total_heal": {},
	}
	if actor is Characters.Enemy || actor is Characters.Summon:
		result.actor_description = actor.description
	if splash:
		result.splash_target = target.name
		if target is Characters.Enemy || actor is Characters.Summon:
			result.splash_target_description = target.description
	else:
		if target is Characters.Enemy || actor is Characters.Summon:
			result.target_description = target.description
	if Characters.check_hit(actor, target, skill):
		var damage:= Characters.calc_damage(skill, actor, target, dam_multiplier)
		result.hit += 1
		result.total_damage += damage.damage
		result.damage_info = create_damage_info(damage)
		target.health -= damage.damage
		if skill.has("health_steal"):
			var heal: int = skill.health_steal*damage.damage
			if result.total_heal.has("health"):
				result.total_heal.health += heal
			else:
				result.total_heal.health = heal
			actor.add_health(heal)
		if target.health<=0.0:
			result.kill += 1
		else:
			for st in skill.combat.status:
				var status:= Characters.create_status(st, actor, target)
				target.add_status(status)
				result.debuff += 1
		if skill.has("push"):
			target.position -= skill.push*sign(actor.position-target.position)
	if result.has("reflected"):
		actor.health -= result.reflected
	result.total_damage = int(result.total_damage)
	for k in result.total_heal.keys():
		result.total_heal[k] = int(result.total_heal[k])
	return result

func use_heal(skill: Dictionary, actor: Characters.Character, target: Characters.Character, heal_multiplier:= 1.0, splash:= false) -> Dictionary:
	var result:= {
		"skill": skill.name,
		"skill_description": skill.description_plain,
		"actor": actor.name,
		"actor_description": "",
		"target": target.name,
		"target_description": "",
		"hit": 0,
		"buff": 0,
		"debuff": 0,
		"total_damage": 0,
		"total_heal": {},
	}
	var heal:= Characters.calc_heal(skill, actor, heal_multiplier)
	if actor is Characters.Enemy || actor is Characters.Summon:
		result.actor_description = actor.description
	if splash:
		result.splash_target = [target.name]
		if target is Characters.Enemy || target is Characters.Summon:
			result.splash_target_description = [target.description]
	else:
		if target is Characters.Enemy || target is Characters.Summon:
			result.target_description = target.description
	result.total_heal = heal
	for k in heal.keys():
		target.add_meter(k, heal[k])
	for st in skill.combat.status:
		var status:= Characters.create_status(st, actor, target)
		target.add_status(status)
		result.buff += 1
	result.total_damage = int(result.total_damage)
	for k in result.total_heal.keys():
		result.total_heal[k] = int(result.total_heal[k])
	return result

func use_buff(skill: Dictionary, actor: Characters.Character, target: Characters.Character, duration_multiplier:= 1.0) -> Dictionary:
	var result:= {
		"skill": skill.name,
		"skill_description": skill.description_plain,
		"actor": actor.name,
		"actor_description": "",
		"target": target.name,
		"target_description": "",
		"hit": 0,
		"buff": 0,
		"debuff": 0,
		"total_damage": 0,
		"total_heal": {},
	}
	for st in skill.combat.status:
		var status:= Characters.create_status(st, actor, target, duration_multiplier)
		target.add_status(status)
		if st.type == "buff":
			result.buff += 1
		elif st.type == "debuff":
			result.debuff += 1
	if skill.combat.has("shielding"):
		for array in skill.combat.shielding:
			var dict: Dictionary = {
				"type": "buff",
				"name": "shield",
				"shielding": array.duplicate(true),
				"duration": skill.duration,
			}
			var status:= Characters.create_status(dict, actor, target, duration_multiplier)
			target.add_status(status)
			result.buff += 1
	if skill.has("push"):
		target.position -= skill.push*sign(actor.position - target.position)
	if actor is Characters.Enemy || actor is Characters.Summon:
		result.actor_description = actor.description
	if target is Characters.Enemy || actor is Characters.Summon:
		result.target_description = target.description
	result.total_damage = int(result.total_damage)
	for k in result.total_heal.keys():
		result.total_heal[k] = int(result.total_heal[k])
	return result

func use_summon(skill: Dictionary, actor: Characters.Character, attribute_scale:= 1.0) -> Dictionary:
	var result:= {
		"skill": skill.name,
		"skill_description": skill.description_plain,
		"actor": actor.name,
		"actor_description": "",
		"hit": 0,
		"buff": 0,
		"debuff": 0,
		"total_damage": 0,
		"total_heal": {},
	}
	var creature:= Characters.create_summon(skill, actor, attribute_scale)
	if actor is Characters.Enemy || actor is Characters.Summon:
		result.actor_description = actor.description
		enemies.push_back(creature)
	else:
		player_summons.push_back(creature)
	result.summon = creature.name
	result.description = creature.description
	update_characters()
	return result

func use_skill(actor: Characters.Character, skill: Dictionary) -> Dictionary:
	var result:={
		"buff":0,
		"effectiveness":0.0,
	}
	var target
	var effectiveness_bonus:= 0.0
	actor.current_action = skill.name
	# Select target(s).
	match skill.target_type:
		"self":
			target = actor
		"ally":
			if actor is Characters.Enemy:
				target = enemies.pick_random()
			elif player_summons.size()>0 && randf()<0.5:
				target = player_summons.pick_random()
			else:
				target = player
		"all_allies":
			if actor is Characters.Enemy:
				target = enemies
			else:
				target = [player] + player_summons
		"all_enemies":
			if actor is Characters.Enemy:
				target = [player] + player_summons
			else:
				target = enemies
		_:
			if actor is Characters.Enemy:
				if player_summons.size() > 0 && randf() < 0.5:
					target = player_summons.pick_random()
				else:
					target = player
			else:
				target = enemies.pick_random()
	
	if skill.has("cost"):
		for k in skill.cost.keys():
			actor.set(k, max(actor.get(k) - skill.cost[k], 0))
	
	if actor is Characters.Character && actor.abilities.has("soul_binding") && randf() < min(0.01 + 0.005 * actor.abilities.soul_binding.level, 0.2):
		effectiveness_bonus += extract_soul()
		result.soul_enchantment = true
		result.soul_bonus = effectiveness_bonus
	
	for st in skill.combat.status_self:
		var status:= Characters.create_status(st, actor, actor)
		actor.add_status(status)
		result.buff += 1
	if skill.has("move"):
		var to_pos:= 0
		if typeof(target)==TYPE_ARRAY:
			for t in target:
				to_pos += t.position
			to_pos /= target.size()
		else:
			to_pos = target.position
		actor.position += skill.move*sign(to_pos-actor.position)
	match skill.usage:
		"attack":
			if typeof(target)==TYPE_ARRAY:
				for t in target:
					var r:= use_attack(skill, actor, t, 1.0 + effectiveness_bonus)
					result = merge_dicts(result, r)
					if typeof(result.total_damage)==TYPE_ARRAY:
						for d in result.total_damage:
							result.effectiveness += float(d) / max(float(t.max_health), 1.0)
					else:
						result.effectiveness += float(result.total_damage) / max(float(t.max_health), 1.0)
				result.effectiveness /= max(target.size(), 1.0)
			else:
				var rr:= use_attack(skill, actor, target, 1.0 + effectiveness_bonus)
				result = merge_dicts(result, rr)
				result.effectiveness = float(result.total_damage) / max(float(target.max_health), 1.0)
				if skill.has("splash_damage"):
					if actor is Characters.Enemy:
						for t in [player] + player_summons:
							if t==target:
								continue
							var r:= use_attack(skill, actor, t, skill.splash_damage*randf_range(0.75,1.25) + 0.5*effectiveness_bonus, true)
							result = merge_dicts(result, r)
					else:
						for t in enemies:
							if t==target:
								continue
							var r:= use_attack(skill, actor, t, skill.splash_damage*randf_range(0.75,1.25) + 0.5*effectiveness_bonus, true)
							result = merge_dicts(result, r)
		"heal":
			if typeof(target)==TYPE_ARRAY:
				for t in target:
					var r:= use_heal(skill, actor, t, 1.0 + effectiveness_bonus)
					result = merge_dicts(result, r)
					result.effectiveness += float(skill.total_heal) / max(float(t.max_health), 1.0)
				result.effectiveness /= max(target.size(), 1.0)
			else:
				var rr:= use_heal(skill, actor, target, 1.0 + effectiveness_bonus)
				result = merge_dicts(result, rr)
				for k in result.total_heal:
					if target.get("max_"+k)==null:
						continue
					result.effectiveness += float(result.total_heal[k]) / max(float(target.get("max_"+k)), 1.0)
				if skill.has("splash_damage"):
					if actor is Characters.Enemy:
						for t in [player]+player_summons:
							if t==target:
								continue
							var r:= use_heal(skill, actor, t, skill.splash_damage*randf_range(0.75,1.25) + 0.5*effectiveness_bonus)
							result = merge_dicts(result, r)
					else:
						for t in enemies:
							if t==target:
								continue
							var r:= use_heal(skill, actor, t, skill.splash_damage*randf_range(0.75,1.25) + 0.5*effectiveness_bonus)
							result = merge_dicts(result, r)
		"buff":
			if typeof(target)==TYPE_ARRAY:
				for t in target:
					var r:= use_buff(skill, actor, t, 1.0 + effectiveness_bonus)
					result = merge_dicts(result, r)
			else:
				var rr:= use_buff(skill, actor, target, 1.0 + effectiveness_bonus)
				result = merge_dicts(result, rr)
				if skill.has("splash_damage"):
					if actor is Characters.Enemy:
						for t in [player] + player_summons:
							if t==target:
								continue
							var r:= use_buff(skill, actor, t, skill.splash_damage*randf_range(0.75,1.25) + 0.5*effectiveness_bonus)
							result = merge_dicts(result, r)
					else:
						for t in enemies:
							if t==target:
								continue
							var r:= use_buff(skill, actor, t, skill.splash_damage*randf_range(0.75,1.25) + 0.5*effectiveness_bonus)
							result = merge_dicts(result, r)
			result.effectiveness = 0.5
		"summon":
			result = use_summon(skill, actor, 1.0 + effectiveness_bonus)
	result.target_data = target
	if !result.has("actor_description"):
		if actor is Characters.Enemy || actor is Characters.Summon:
			result.actor_description = actor.description
		else:
			result.actor_description = ""
	if skill.has("cooldown"):
		skill.current_cooldown = skill.cooldown
	return result

func fight():
	var skill = pick_skill(player)
	var delay: float = get_delay_scale(player.attributes.speed)
	if skill==null:
		var target: Characters.Character = chose_engagement_target(player)
		if target==null:
			skill = player.skills.pick_random()
		else:
			do_action("engage", {"target": target.name, "target_description": target.description}, delay)
			return
	
	var result:= use_skill(player, skill)
	if skill.has("delay_multiplier"):
		delay *= 1.0 + skill.delay_multiplier
	for n in result.buff:
		if n>0:
			update_characters()
			break
	if result.has("soul_enchantment") && result.soul_enchantment:
		print_log_msg(tr("SKILL_SOUL_ENCHANTMENT").format({"soul_bonus": int(100 * result.soul_bonus)}))
	match skill.usage:
		"attack":
			add_guild_exp("attack")
			if typeof(result.target) == TYPE_ARRAY:
				for i in range(result.target.size()):
					var dict:= {
						"target": result.target[i],
						"target_description": result.target_description[i],
						"skill": result.skill[i],
						"skill_description": result.skill_description[i],
						"hit": result.hit[i],
						"total_damage": result.total_damage[i],
						"debuff": result.debuff[i],
					}
					if result.has("damage_info"):
						if typeof(result.damage_info) == TYPE_ARRAY && result.damage_info.size() > i:
							dict.damage_info = result.damage_info[i]
						else:
							dict.damage_info = result.damage_info
					print_log_msg(tr("ATTACK_LOG").format(dict))
					if dict.hit == 0:
						print_log_msg(tr("MISSED_LOG"))
						use_stat("dexterity", delay)
						add_guild_exp("miss")
						action_failures += 1
					else:
						print_log_msg(tr("HIT_LOG").format(dict))
						if dict.total_damage==0:
							action_failures += 1
						else:
							action_failures = 0
					if dict.debuff>0:
						add_guild_exp("debuff")
					add_guild_exp("hit", 1.0/float(result.target.size()))
			else:
				print_log_msg(tr("ATTACK_LOG").format(result))
				if result.hit==0:
					print_log_msg(tr("MISSED_LOG"))
					use_stat("dexterity", delay)
					add_guild_exp("miss")
					action_failures += 1
				else:
					print_log_msg(tr("HIT_LOG").format(result))
					if result.total_damage==0:
						action_failures += 1
					else:
						action_failures = 0
				
				for s in Characters.STATS_ATTRIBUTES.keys():
					if Characters.STATS_ATTRIBUTES[s].has(skill.attribute):
						use_stat(s, Characters.STATS_ATTRIBUTES[s][skill.attribute]*delay)
				
				if result.debuff>0:
					add_guild_exp("debuff", result.debuff)
				add_guild_exp("hit")
			if result.total_heal.size()>0:
				if typeof(result.total_heal)==TYPE_ARRAY:
					var dict:= result.duplicate(true)
					for heal_dict in result.total_heal:
						if heal_dict.size()>0:
							dict.total_heal = summarize_heal(heal_dict)
							print_log_msg(tr("HEAL_LOG").format(dict))
				else:
					result.total_heal = summarize_heal(result.total_heal)
					print_log_msg(tr("HEAL_LOG").format(result))
			if result.has("reflected") && result.reflected>0:
				print_log_msg(tr("REFLECTED_DAMAGE_LOG").format(result))
		"heal":
			if typeof(result.target)==TYPE_ARRAY:
				for i in range(result.target.size()):
					var dict:= {
						"target":result.target[i],
						"target_description":result.target_description[i],
						"skill":result.skill[i],
						"skill_description":result.skill_description[i],
						"hit":result.hit[i],
						"total_damage":result.total_damage[i],
						"buff":result.buff[i],
					}
					if result.total_heal[i].size()>0:
						dict.total_heal = summarize_heal(result.total_heal[i])
						print_log_msg(tr("BUFF_LOG").format(dict))
						print_log_msg(tr("HEAL_LOG").format(dict))
						add_guild_exp("heal")
						add_guild_exp("buff", dict.buff)
			else:
				result.total_heal = summarize_heal(result.total_heal)
				print_log_msg(tr("BUFF_LOG").format(result))
				print_log_msg(tr("HEAL_LOG").format(result))
				add_guild_exp("heal")
		"buff":
			if typeof(result.target)==TYPE_ARRAY:
				for i in range(result.target.size()):
					var dict:= {
						"target":result.target[i],
						"target_description":result.target_description[i],
						"skill":result.skill[i],
						"skill_description":result.skill_description[i],
						"hit":result.hit[i],
						"total_damage":result.total_damage[i],
					}
					print_log_msg(tr("BUFF_LOG").format(dict))
					add_guild_exp("buff")
			else:
				print_log_msg(tr("BUFF_LOG").format(result))
				add_guild_exp("buff")
		"summon":
			if player_summons.size() > max_summons:
				player_summons.pop_front()
				update_characters()
			print_log_msg(tr("SUMMON_LOG").format(result))
			add_guild_exp("summon")
	
	var num:= 0
	if !result.has("effectiveness"):
		result.effectiveness = 1.0
	for s in skill.slots.keys():
		for t in skill.slots[s]:
			for a in player.abilities.keys():
				if !Skills.ABILITY_MODULES.has(a) || !Skills.ABILITY_MODULES[a].has(s) || !Skills.ABILITY_MODULES[a][s].has(t):
					continue
				use_ability(a, result.effectiveness/delay*(1.0 + float(skill.usage=="attack") + float(skill.usage=="summon")))
				num += 1
	for s in skill.slots.keys():
		for t in skill.slots[s]:
			for a in player.abilities.keys():
				if !Skills.ABILITY_MODULES.has(a) || !Skills.ABILITY_MODULES[a].has(s) || !Skills.ABILITY_MODULES[a][s].has(t):
					continue
				add_ability_exp(a, 1.0/float(num))
	
	do_action("fight", result, delay, skill.name)

func pick_potion(type: String):
	var valid:= []
	for potion in player_potions:
		if potion.effect==type:
			valid.push_back(potion)
	if valid.size()>0:
		return valid.pick_random()
	return

func quaff_potion(potion: Dictionary):
	player_potion_delay = POTION_USE_DELAY
	if potion.has("healing"):
		player[potion.effect] = min(player[potion.effect] + potion.healing, player["max_" + potion.effect])
	if potion.has("status"):
		var status: Dictionary = potion.status.duplicate()
		status.max_duration = status.duration
		player.status.push_back(status)
		update_characters()
	if potion.effect not in player_potions_used:
		player_potions_used[potion.effect] = 1
	else:
		player_potions_used[potion.effect] += 1
	store_historical_data("potions", player_potions_used[potion.effect], potion.effect)

func enemy_attack(enemy: Characters.Enemy):
	if enemy.skills.size() == 0:
		enemy.delay = 1.0
		enemy.action_duration = 1.0
		print_log_msg(tr("ENEMY_NO_ACTION_LOG").format({"actor":enemy.name, "actor_description":enemy.description}))
		return
	
	var skill = pick_skill(enemy)
	var delay: float = get_delay_scale(enemy.attributes.speed)
	
	if skill==null:
		var target: Characters.Character = chose_engagement_target(enemy)
		if target==null:
			skill = enemy.skills.pick_random()
		else:
			enemy.position += sign(target.position-enemy.position)
			print_log_msg(tr("ENEMY_ENGAGE_LOG").format({"actor":enemy.name, "actor_description":enemy.description}))
			return
	
	var result:= use_skill(enemy, skill)
	
	match skill.usage:
		"attack":
			add_guild_exp("attacked")
			if typeof(result.target)==TYPE_ARRAY:
				for i in range(result.target.size()):
					var dict:= {
						"actor":result.actor[i],
						"actor_description":result.actor_description[i],
						"target":result.target[i],
						"target_description":result.target_description[i],
						"skill":result.skill[i],
						"skill_description":result.skill_description[i],
						"hit":result.hit[i],
						"total_damage":result.total_damage[i],
						"debuff":result.debuff[i],
					}
					if result.has("damage_info"):
						if typeof(result.damage_info)==TYPE_ARRAY && result.damage_info.size()>i:
							dict.damage_info = result.damage_info[i]
						else:
							dict.damage_info = result.damage_info
					if result.target_data is Characters.Character && result.target_data==player:
						print_log_msg(tr("ENEMY_ATTACK_LOG").format(dict))
						if player.abilities.has("evasion"):
							add_ability_exp("evasion", 0.5/float(result.target.size()))
					else:
						print_log_msg(tr("ENEMY_ATTACK_ALLY_LOG").format(dict))
						if player.abilities.has("armour"):
							add_ability_exp("armour", 0.5/float(result.target.size()))
					if dict.hit==0:
						print_log_msg(tr("ENEMY_MISS_LOG").format(dict))
					else:
						print_log_msg(tr("ENEMY_HIT_LOG").format(dict))
			else:
				if result.target_data is Characters.Character && result.target_data==player:
					print_log_msg(tr("ENEMY_ATTACK_LOG").format(result))
					if player.abilities.has("evasion"):
						add_ability_exp("evasion", 0.5)
				else:
					print_log_msg(tr("ENEMY_ATTACK_ALLY_LOG").format(result))
					if player.abilities.has("armour"):
						add_ability_exp("armour", 0.5)
				if result.hit==0:
					print_log_msg(tr("ENEMY_MISS_LOG").format(result))
				else:
					print_log_msg(tr("ENEMY_HIT_LOG").format(result))
			if result.total_heal.size()>0:
				if typeof(result.total_heal)==TYPE_ARRAY:
					var dict:= result.duplicate(true)
					for heal_dict in result.total_heal:
						if heal_dict.size()>0:
							dict.total_heal = summarize_heal(heal_dict)
							print_log_msg(tr("ENEMY_HEAL_LOG").format(dict))
				else:
					result.total_heal = summarize_heal(result.total_heal)
					print_log_msg(tr("ENEMY_HEAL_LOG").format(result))
		"heal":
			if typeof(result.target)==TYPE_ARRAY:
				for i in range(result.target.size()):
					var dict:= {
						"actor":result.actor[i],
						"actor_description":result.actor_description[i],
						"target":result.target[i],
						"target_description":result.target_description[i],
						"skill":result.skill[i],
						"skill_description":result.skill_description[i],
						"hit":result.hit[i],
						"total_damage":result.total_damage[i],
						"buff":result.buff[i],
					}
					if result.total_heal[i].size()>0:
						dict.total_heal = summarize_heal(result.total_heal[i])
						print_log_msg(tr("ENEMY_BUFF_LOG").format(dict))
						print_log_msg(tr("ENEMY_HEAL_LOG").format(dict))
			else:
				result.total_heal = summarize_heal(result.total_heal)
				print_log_msg(tr("ENEMY_BUFF_LOG").format(result))
				print_log_msg(tr("ENEMY_HEAL_LOG").format(result))
		"buff":
			if typeof(result.target)==TYPE_ARRAY:
				for i in range(result.target.size()):
					var dict:= {
						"actor":result.actor[i],
						"actor_description":result.actor_description[i],
						"target":result.target[i],
						"target_description":result.target_description[i],
						"skill":result.skill[i],
						"skill_description":result.skill_description[i],
						"hit":result.hit[i],
						"total_damage":result.total_damage[i],
					}
					print_log_msg(tr("ENEMY_SELF_BUFF_LOG").format(dict))
			else:
				print_log_msg(tr("ENEMY_SELF_BUFF_LOG").format(result))
		"summon":
			print_log_msg(tr("ENEMY_SUMMON_LOG").format(result))
	
	if skill.has("delay_multiplier"):
		delay *= 1.0 + skill.delay_multiplier
	enemy.delay = delay
	enemy.action_duration = delay

func summon_attack(summon: Characters.Character):
	if summon.skills.size()==0:
		summon.delay = 1.0
		summon.action_duration = 1.0
		print_log_msg(tr("ENEMY_NO_ACTION_LOG").format({"actor":summon.name}))
		return
	
	var skill = pick_skill(summon)
	var delay: float = get_delay_scale(summon.attributes.speed)
	
	if skill==null:
		var target: Characters.Character = chose_engagement_target(summon)
		if target==null:
			skill = summon.skills.pick_random()
		else:
			summon.position += sign(target.position-summon.position)
			print_log_msg(tr("SUMMON_ENGAGE_LOG").format({"actor":summon.name, "actor_description":summon.description, "target":target.name, "target_description":target.description}))
			return
	
	var result:= use_skill(summon, skill)
	
	match skill.usage:
		"attack":
			if typeof(result.target)==TYPE_ARRAY:
				for i in range(result.target.size()):
					var dict:= {
						"actor":result.actor[i],
						"actor_description":result.actor_description[i],
						"target":result.target[i],
						"target_description":result.target_description[i],
						"skill":result.skill[i],
						"skill_description":result.skill_description[i],
						"hit":result.hit[i],
						"total_damage":result.total_damage[i],
						"debuff":result.debuff[i],
					}
					if result.has("damage_info"):
						if typeof(result.damage_info)==TYPE_ARRAY && result.damage_info.size()>i:
							dict.damage_info = result.damage_info[i]
						else:
							dict.damage_info = result.damage_info
					print_log_msg(tr("SUMMON_ATTACK_LOG").format(dict))
					if dict.hit==0:
						print_log_msg(tr("SUMMON_MISS_LOG").format(dict))
					else:
						print_log_msg(tr("SUMMON_HIT_LOG").format(dict))
			else:
				print_log_msg(tr("SUMMON_ATTACK_LOG").format(result))
				if result.hit==0:
					print_log_msg(tr("SUMMON_MISS_LOG").format(result))
				else:
					print_log_msg(tr("SUMMON_HIT_LOG").format(result))
			if result.total_heal.size()>0:
				if typeof(result.total_heal)==TYPE_ARRAY:
					var dict:= result.duplicate(true)
					for heal_dict in result.total_heal:
						if heal_dict.size()>0:
							dict.total_heal = summarize_heal(heal_dict)
							print_log_msg(tr("SUMMON_HEAL_LOG").format(dict))
				else:
					result.total_heal = summarize_heal(result.total_heal)
					print_log_msg(tr("SUMMON_HEAL_LOG").format(result))
		"heal":
			if typeof(result.target)==TYPE_ARRAY:
				for i in range(result.target.size()):
					var dict:= {
						"actor":result.actor[i],
						"actor_description":result.actor_description[i],
						"target":result.target[i],
						"target_description":result.target_description[i],
						"skill":result.skill[i],
						"skill_description":result.skill_description[i],
						"hit":result.hit[i],
						"total_damage":result.total_damage[i],
						"buff":result.buff[i],
					}
					if result.total_heal[i].size()>0:
						dict.total_heal = summarize_heal(result.total_heal[i])
						print_log_msg(tr("SUMMON_BUFF_LOG").format(dict))
						print_log_msg(tr("SUMMON_HEAL_LOG").format(dict))
			else:
				result.total_heal = summarize_heal(result.total_heal)
				print_log_msg(tr("SUMMON_BUFF_LOG").format(result))
				print_log_msg(tr("SUMMON_HEAL_LOG").format(result))
		"buff":
			if typeof(result.target)==TYPE_ARRAY:
				for i in range(result.target.size()):
					var dict:= {
						"actor":result.actor[i],
						"actor_description":result.actor_description[i],
						"target":result.target[i],
						"target_description":result.target_description[i],
						"skill":result.skill[i],
						"skill_description":result.skill_description[i],
						"hit":result.hit[i],
						"total_damage":result.total_damage[i],
					}
					print_log_msg(tr("SUMMON_SELF_BUFF_LOG").format(dict))
			else:
				print_log_msg(tr("SUMMON_SELF_BUFF_LOG").format(result))
		"summon":
			result = use_summon(skill, summon)
			print_log_msg(tr("ENEMY_SUMMON_LOG").format(result))
	
	if skill.has("delay_multiplier"):
		delay *= 1.0 + skill.delay_multiplier
	summon.delay = delay
	summon.action_duration = delay

func die(enemy: Characters.Enemy):
	if not enemies.has(enemy):
		return
	
	var dict:= enemy.to_dict()
	var soul_rng:= randf()
	var soul_chance:= get_soul_stone_drop_chance()
	var soul_cage = get_empty_soul_stone()
	print_log_msg(tr("DIE_LOG").format(dict))
	add_exp(enemy.experience)
	add_guild_exp("kill")
	if enemy.materials.size()>0:
		loot.push_back(Items.create_material_drop(enemy.materials.pick_random(), dict))
	if randf()<enemy.equipment_drop_chance:
		var item:= Items.create_equipment_drop(dict)
		if !EQUIPMENT_LEVEL_RESTRICTION.has(item.type) || player.level>=EQUIPMENT_LEVEL_RESTRICTION[item.type]:
			loot.push_back(item)
	if soul_rng<soul_chance:
		if player.abilities.has("soul_binding"):
			use_ability("soul_binding", soul_rng/soul_chance)
			add_ability_exp("soul_binding", 8.0*soul_rng/soul_chance)
		loot.push_back(Items.create_soul_stone_drop(dict))
	if player.abilities.has("soul_binding") && soul_cage!=null && soul_cage is Dictionary:
		var charge: int = max(4 + enemy.soul_rarity, 1)
		if player.abilities.has("soul_binding"):
			charge += round(randf_range(0.05, 0.2) * player.abilities.soul_binding.level)
		if soul_cage.has("charges"):
			soul_cage.charges += charge
		else:
			soul_cage.charges = charge
		if soul_cage.charges>=33 + randi()%25 + randi()%25 + randi()%25:
			remove_item(soul_cage)
			dict.soul_rarity = int(clamp(round(soul_cage.charges/15.0 - 2.75), -1, 2))
			add_item(Items.create_soul_stone_drop(dict))
			use_ability("soul_binding", 2.0)
			add_ability_exp("soul_binding", 5.0 + 2.0*max(dict.soul_rarity, 0.0))
		else:
			add_ability_exp("soul_binding", 0.25)
	
	enemies.erase(enemy)
	update_characters()
	
	if enemies.size() == 0:
		player_battles_won += 1
		player.reset_focus()

func start_task(task_ID: int, task:= ""):
	if task=="":
		task = timetable.values()[task_ID]
	if task==current_task:
		return
	turn_counter = 0
	
	if task=="crafting":
		if player_inventory.size()<2:
			if player_gold > get_potion_gold_limit() || player_inventory.size() > 50:
				task = "shopping"
			else:
				task = "grinding"
		else:
			var has_crafting_ability:= player.abilities.has("enchanting") || player.abilities.has("alchemy")
			for k in player.abilities.keys():
				if k in Skills.CRAFTING_ABILITIES:
					has_crafting_ability = true
					break
			if !has_crafting_ability:
				if player_gold > get_potion_gold_limit() || player_inventory.size() > 50:
					task = "shopping"
				else:
					task = "grinding"
	elif task == "shopping" && (player_gold <= get_potion_gold_limit() && player_inventory.size() == 0):
		task = "crafting"
	if task == "sleeping":
		store_historical_data("experience", player_exp)
		store_historical_data("gold", player_gold)
		store_historical_data("battles_won", player_battles_won)
		store_historical_data("battles_lost", player_battles_lost)
		for attribute in player.attributes:
			store_historical_data("attributes", player.attributes[attribute], attribute)
		for type in player.equipment:
			var base_type: String = player.equipment[type].get("base_type", type)
			store_historical_data("equipment_quality", player.equipment[type].quality, base_type)
		if current_time - player_creation_time < 12 * 60 * 60:
			task = "grinding"
	current_task = task
	enemies.clear()
	player_summons.clear()
	loot.clear()
	player.position = 1
	action_failures = 0
	update_characters()
	optimize_equipment()
	match task:
		"grinding":
			var target_location: String = current_region.locations.keys().pick_random()
			do_action("goto", {"location":target_location}, TRAVEL_DELAY)
		"training", "questing", "shopping", "crafting", "resting", "sleeping":
			if current_location in current_region.cities:
				do_action("goto", {"location": current_location}, 0.1)
			else:
				var target_location: String = current_region.cities.keys().pick_random()
				do_action("goto", {"location":target_location}, TRAVEL_DELAY)


func make_desc_list(array: Array) -> String:
	if array.size()==0:
		return ""
	var string:= ""
	var description: String
	if "description_plain" in array[0]:
		description = array[0].description_plain
	elif "description" in array[0]:
		description = Skills.tooltip_remove_bb_code(array[0].description)
	else:
		description = ""
	if array.size()==1:
		string = Story.get_a_an(array[0].name) + "[hint=" + description + "]" + array[0].name + "[/hint]"
	elif array.size()==2:
		if "description_plain" in array[1]:
			description = array[1].description_plain
		elif "description" in array[1]:
			description = Skills.tooltip_remove_bb_code(array[1].description)
		else:
			description = ""
		string = Story.get_a_an(array[0].name) + "[hint=" + description + "]" + array[0].name + "[/hint] and " + Story.get_a_an(array[1].name) + "[hint=" + description + "]" + array[1].name + "[/hint]"
	else:
		for i in range(array.size()):
			if "description_plain" in array[i]:
				description = array[i].description_plain
			elif "description" in array[i]:
				description = Skills.tooltip_remove_bb_code(array[i].description)
			else:
				description = ""
			string += Story.get_a_an(array[i].name) + "[hint=" + description + "]" + array[i].name + "[/hint]"
			if i<array.size()-2:
				string += ", "
			elif i==array.size()-2:
				string += ", and "
	return string

func update_characters():
	var player_array: Array = Array([player] + player_summons, TYPE_OBJECT, &"RefCounted", Characters.Character)
	var enemy_array: Array = Array(enemies, TYPE_OBJECT, &"RefCounted", Characters.Character)
	emit_signal("characters_updated", player_array, enemy_array)

func update_quest_log():
	emit_signal("quest_log_updated", quest_log)

func print_log_msg(text: String):
	if abs(current_time - Time.get_unix_time_from_system()) > 8 * 60 * 60:
		return
	
	text[0] = text[0].to_upper()
	emit_signal("text_printed", text + "\n")

func print_summary_msg(text: String):
	var time_zone:= Time.get_time_zone_from_system()
	var time_data:= Time.get_datetime_dict_from_unix_time(int(current_time + 60 * time_zone.bias))
	if summary_text.length() > 8000:
		@warning_ignore("integer_division")
		summary_text = summary_text.right(summary_text.length() - summary_text.find("\n", summary_text.length() / 2) - 1)
	text[0] = text[0].to_upper()
	text = "\n" + Time.get_datetime_string_from_datetime_dict(time_data, true) + ": " + text
	summary_text += text
	emit_signal("summary_updated", summary_text)


func time_step(delta: float, time: float):
	if current_task == "training" && abs(time - current_time) > 10*60:
		var _exp:= 5.0 * 60.0 / float(player.skills.size())
		current_time += 10*60
		for skill in player.skills:
			for s in skill.slots.keys():
				for t in skill.slots[s]:
					for a in player.abilities.keys():
						if !Skills.ABILITY_MODULES.has(a) || !Skills.ABILITY_MODULES[a].has(s) || !Skills.ABILITY_MODULES[a][s].has(t):
							continue
						add_ability_exp(a, _exp / float(skill.slots[s].size()))
		action_done(current_action)
		return
	
	delta = clamp(player.delay, delta, abs(time - current_time))
	
	current_time += delta
	player.update(delta)
	player_potion_delay -= delta
	player_cooking_delay -= delta
	
	if player.delay <= 0.0:
		recalc_attributes()
		player.reset_focus()
		action_done(current_action)
	
	for enemy in enemies:
		enemy.update(delta)
		if enemy.health <= 0.0:
			die(enemy)
		elif enemy.delay <= 0.0:
			enemy.reset_focus()
			enemy_attack(enemy)
	
	for summon in player_summons:
		if !(summon is Characters.Summon):
			player_summons.erase(summon)
			continue
		summon.update(delta)
		summon.duration -= delta
		if summon.duration <= 0.0 || enemies.size() == 0:
			print_log_msg(tr("SUMMON_EXPIRED_LOG").format({"name":summon.name, "description":summon.description}))
			player_summons.erase(summon)
			update_characters()
		elif summon.health <= 0.0:
			print_log_msg(tr("SUMMON_DEFEATED_LOG").format({"name":summon.name, "description":summon.description}))
			player_summons.erase(summon)
			update_characters()
		elif summon.delay <= 0.0:
			summon.reset_focus()
			summon_attack(summon)
	
	return

func _process(delta: float):
	var steps:= 0
	var time:= Time.get_unix_time_from_system()
	
	delta = min(delta, MAX_DELTA)
	
	while current_time < time && steps < max(MAX_STEPS*min(1.0 / 30.0 / delta, 1.0), 1):
		time_step(delta, time)
		steps += 1
	
	autosave_delay -= delta
	if autosave_delay <= 0.0:
		_save()


func get_dict_text(file: FileAccess) -> String:
	var text:= ""
	var brackets:= 0
	while true:
		var is_key:= false
		var new_line:= file.get_line()
		text += new_line
		for i in range(new_line.length()):
			match new_line[i]:
				'"':
					is_key = !is_key
				'{':
					brackets += int(!is_key)
				'}':
					brackets -= int(!is_key)
		if brackets <= 0 or file.eof_reached():
			break
	if brackets != 0:
		printt("EOF reached unexpectedly", brackets)
	return text

func _save():
	var dir:= DirAccess.open("user://saves")
	if dir == null || DirAccess.get_open_error() != OK:
		var error: int
		dir = DirAccess.open("user://")
		error = dir.make_dir_recursive("user://saves")
		if error != OK:
			print("Can't create save directory!")
			return
		dir = DirAccess.open("user://saves")
	
	var file: FileAccess
	var player_data:= player.to_dict()
	var enemy_data:= []
	var summon_data:= []
	for enemy in enemies:
		enemy_data.push_back(enemy.to_dict())
	for summon in player_summons:
		summon_data.push_back(summon.to_dict())
	var data:= {
		"player_name": player_name.replace("{", "").replace("}", ""),
		"player_gender": player_gender,
		"player_race": player_race,
		"player_inventory": player_inventory,
		"player_potions": player_potions,
		"player_stat_preference": player_stat_preference,
		"player_ability_preference": player_ability_preference,
		"player_gold": player_gold,
		"player_potion_delay": player_potion_delay,
		"player_cooking_delay": player_cooking_delay,
		"player_guild_lvl": player_guild_lvl,
		"player_guild_exp": player_guild_exp,
		"player_exp": player_exp,
		"player_vegan": player_vegan,
		"player_creation_time": player_creation_time,
		"player_battles_lost": player_battles_lost,
		"player_battles_won": player_battles_won,
		"player_potions_used": player_potions_used,
		"current_task": current_task,
		"current_action_text": current_action_text,
		"current_task_ID": current_task_ID,
		"action_failures": action_failures,
		"current_time": current_time,
		"current_action": current_action,
		"current_region": current_region.to_dict(),
		"current_location": current_location,
		"explored_locations":explored_locations,
		"quest_chapter":quest_chapter,
		"quest_progress":quest_progress,
		"current_quest": current_quest,
		"quest_log":quest_log,
		"valid_weapon_types": player_settings.valid_weapon_types,
		"valid_armour_types": player_settings.valid_armour_types,
		"valid_potion_types": player_settings.valid_potion_types,
		"weapon_1h_alowed": player_settings.weapon_1h_alowed,
		"weapon_2h_alowed": player_settings.weapon_2h_alowed,
		"disabled_skill_modules": player_settings.disabled_skill_modules,
		"auto_update_options": player_settings.auto_update_options,
		"loot": loot,
		"player_summons": summon_data,
		"enemies": enemy_data,
		"progress_delay": player_delay,
		"timetable": timetable,
		"time_offset": time_offset,
		"summary_text": summary_text,
	}
	file = FileAccess.open("user://saves/" + player_name + ".dat", FileAccess.WRITE)
	file.store_line(JSON.stringify({
		"version": version,
		"name": player_name,
		"race": player_race,
		"level": player.level,
		"location": current_region.name
	}, "\t"))
	file.store_line(JSON.stringify(player_data, "\t"))
	file.store_line(JSON.stringify(data, "\t"))
	file.store_line(JSON.stringify({
		"persons": Story.persons,
		"story": Story.story,
		"inventory": Story.inventory,
		"current_state": Story.current_state
	}, "\t"))
	file.store_line(JSON.stringify(historical_data, "\t"))
	
	print("Game saved")
	autosave_delay = 120.0

func _load():
	var file:= FileAccess.open("user://saves/" + player_name + ".dat", FileAccess.READ)
	if FileAccess.get_open_error() != OK:
		print("Can't open save file " + player_name + ".dat!")
		return
	
	var data: Dictionary
	#var first_line:= get_dict_text(file)
	get_dict_text(file)
	# TODO: check version info
	data = JSON.parse_string(get_dict_text(file)) as Dictionary
	if data == null:
		print("Can't load save file " + player_name + ".dat!")
	data.delay = minf(data.get("delay", 0.0), 6.0 * 60.0 * 60.0)
	
	# compatibility with older versions: update skill descriptions
	for skill in data.skills:
		if skill.has("description_plain"):
			continue
		skill.description = Skills.create_tooltip(skill)
		skill.description_plain = Skills.tooltip_remove_bb_code(skill.description)
		skill.module_description = Skills.create_module_tooltip(skill)
	for item in data.equipment.values():
		if item.has("description_plain") && item.has("component_description"):
			continue
		item.description = Items.create_tooltip(item)
		item.description_plain = Skills.tooltip_remove_bb_code(item.description)
		item.component_description = Items.create_component_tooltip(item)
	for ability_id in data.abilities:
		if typeof(data.abilities[ability_id]) != TYPE_DICTIONARY:
			data.abilities[ability_id] = {
				"name": str(ability_id),
				"level": int(data.abilities[ability_id]),
				"experience": 0.0,
			}
	
	player = Characters.Character.new(data)
	data = JSON.parse_string(get_dict_text(file)) as Dictionary
	if data.has("timetable"):
		var dict:= {}
		for t in data.timetable.keys():
			dict[int(t)] = data.timetable[t]
		data.timetable = dict
	for k in data.keys():
		if k in player_settings:
			player_settings.set(k, data[k])
		else:
			match k:
				"current_region":
					self.current_region = Region.new(data[k])
				_:
					set(k, data[k])
	for i in range(enemies.size()):
		for skill in enemies[i].skills:
			if skill.has("description_plain"):
				continue
			skill.description = Skills.create_tooltip(skill)
			skill.description_plain = Skills.tooltip_remove_bb_code(skill.description)
		enemies[i] = Characters.Enemy.new(enemies[i])
	for i in range(player_summons.size()):
		for skill in player_summons[i].skills:
			if skill.has("description_plain"):
				continue
			skill.description = Skills.create_tooltip(skill)
			skill.description_plain = Skills.tooltip_remove_bb_code(skill.description)
		player_summons[i] = Characters.Summon.new(player_summons[i])
	Items.is_vegan = player_vegan
	recalc_attributes()
	
	# fix broken vectors
	for item in player_inventory + player.equipment.values():
		if "card_set" not in item:
			continue
		var card_set:= {}
		for key in item.card_set:
			var card: Dictionary = item.card_set[key]
			card.position = Vector2i(Utils.parse_vector2(card.position))
			card_set[card.position] = card
		item.card_set = card_set
	
	# compatibility with older versions: update item descriptions
	for item in player_inventory + player.equipment.values():
		if item.has("description_plain") && item.has("component_description"):
			continue
		item.description = Items.create_tooltip(item)
		item.description_plain = Skills.tooltip_remove_bb_code(item.description)
		item.component_description = Items.create_component_tooltip(item)
	
	# compatibility fixes
	if typeof(current_region.cities) != TYPE_DICTIONARY:
		var dict:= {}
		for city_name in current_region.cities:
			dict[city_name] = {"name": city_name, "type": "town"}
		current_region.cities = dict
	if typeof(current_region.locations) != TYPE_DICTIONARY:
		var dict:= {}
		for location_name in current_region.locations:
			dict[location_name] = {"name": location_name, "type": "field"}
		current_region.locations = dict
	
	data = JSON.parse_string(get_dict_text(file)) as Dictionary
	Story.persons = data.persons
	Story.story = data.story
	Story.inventory = data.inventory
	Story.current_state = data.current_state
	Story.locations = current_region.locations
	Story.cities = current_region.cities
	Story.guilds = player_guild_lvl.keys()
	Story.factions = current_region.race
	# compatibility fixes
	if "enemy" not in current_region:
		current_region.enemy = ["goblin"]
	Story.hostile_factions = current_region.enemy
	
	var hist_data: Variant = JSON.parse_string(get_dict_text(file))
	if hist_data != null && typeof(hist_data) == TYPE_DICTIONARY:
		historical_data = hist_data

func gui_ready():
	update_characters()
	emit_signal("gold_changed", player_gold)
	emit_signal("inventory_changed", player_inventory)
	emit_signal("potion_inventory_changed", player_potions)
	emit_signal("story_inventory_changed", Story.inventory)
	emit_signal("location_changed", current_region, current_location)
	emit_signal("quest_log_updated", quest_log)
	emit_signal("summary_updated", summary_text)
	emit_signal("abilities_updated")
	emit_signal("skills_updated")
	emit_signal("guilds_updated")


func store_historical_data(type: String, value: Variant, sub := ""):
	if type not in historical_data:
		if sub == "":
			historical_data[type] = [
				[current_time, value],
			]
		else:
			historical_data[type] = {
				sub: [[current_time, value]],
			}
	else:
		if sub == "":
			if historical_data[type].size() > 200:
				# remove the first 10 entries
				historical_data[type] = historical_data[type].slice(10, historical_data[type].size())
			historical_data[type].append([current_time, value])
		else:
			if sub not in historical_data[type]:
				historical_data[type][sub] = [[current_time, value]]
			else:
				if historical_data[type][sub].size() > 100:
					# remove the first 10 entries
					historical_data[type][sub] = historical_data[type][sub].slice(10, historical_data[type][sub].size())
				historical_data[type][sub].append([current_time, value])


func _set_timetable(ID: int, index: int):
	var type: String = ACTIONS[ID]
	index += 5
	for i in range(1, index - 4):
		if timetable.has(index - i):
			if timetable[index - i] == type:
				timetable.erase(index)
				return
			break
	timetable[index] = type
	autosave_delay = 10.0

func _set_time_offset(value: int):
	time_offset = value
	autosave_delay = 10.0


func _settings_changed():
	# queue an autosave if a setting has been changed
	autosave_delay = min(autosave_delay, 10.0)


func _notification(what: int):
	if what==NOTIFICATION_WM_CLOSE_REQUEST:
		_save()
		get_tree().quit()

func _input(event: InputEvent):
	if event.is_action_pressed("ui_cancel"):
		_save()
		get_tree().change_scene_to_file("res://gui/menu.tscn")
		emit_signal("freed")
		queue_free()

func _ready():
	randomize()
	
#	debug
	#current_time -= 7*24*60*60
	
	if player_settings.valid_weapon_types.size() == 0:
		player_settings.valid_weapon_types = player.valid_weapon_subtypes
	if player_settings.valid_armour_types.size() == 0:
		player_settings.valid_armour_types = player.valid_armour_subtypes
	
	if current_task_ID == -1:
		current_task_ID = 0
		start_task(current_task_ID)
