extends Node

const BASE_SOUL_PREFIX = [
	"LESSER", "INSIGNIFICANT", "COMMON",
]

var base_enemies:= {}


func create_tooltip(creature: Characters.Character) -> String:
	var text: String = creature.name + "\n" + tr("LEVEL") + " " + str(creature.level) + " " + tr("TIER"+str(clamp(creature.tier + 2, 0, 5))) + " " + creature.base_name + "\n\n" + tr("STATS") + ":\n"
	for k in creature.stats.keys():
		text += "  " + tr(k.to_upper()) + ": " + str(creature.stats[k]) + "\n"
	text += "\n"
	for k in creature.attributes.keys():
		text += "  " + tr(k.to_upper()) + ": " + str(creature.attributes[k]) + "\n"
	text += "\n"
	if creature.damage.size()>0:
		text += tr("DAMAGE") + ":\n"
		for k in creature.damage.keys():
			text += "  " + tr(k.to_upper()) + ": " + str(int(100*creature.damage[k])) + "%\n"
		text += "\n"
	if creature.resistance.size()>0:
		text += tr("RESISTANCE") + ":\n"
		for k in creature.resistance.keys():
			text += "  " + tr(k.to_upper()) + ": " + str(int(100*creature.resistance[k])) + "%\n"
		text += "\n"
	text += tr("SKILLS") + ":\n"
	for skill in creature.skills:
		text += "  " + skill.name + "\n"
	return text


func create_enemy(type: String, level: int, tier:= 0) -> Characters.Enemy:
	if type not in base_enemies:
		type = base_enemies.keys().pick_random()
	var dict:= base_enemies[type] as Dictionary
	var enemy:= {
		"name": dict.base_name.pick_random(),
		"level": level,
		"tier": tier,
		"experience": 10,
		"stats": dict.base_stats.duplicate(),
		"abilities": [],
		"resistance": {},
		"damage": {},
		"skills": [],
		"status": [],
		"delay": randf_range(0.0, 1.0),
		"position": -1,
	}
	var tier_multiplier:= 1.0
	var level_multiplier: float = 1.0 + min(0.1 + 0.001 * level, 0.2) * (level - 1)
	var num_skills: int = max(1 + 2 * tier, -1)
	var max_range:= 0
	var ret: Characters.Enemy
	enemy.base_name = enemy.name
	enemy.name_prefix = enemy.name
	if dict.has("experience"):
		enemy.experience = dict.exp
	if dict.has("abilities"):
		enemy.abilities += dict.abilities
		num_skills += dict.abilities.size() / 2
	if dict.has("attributes"):
		enemy.attributes_add = dict.attributes.duplicate()
	if dict.has("resistance"):
		enemy.resistance = dict.resistance.duplicate()
	if dict.has("variants"):
		var variant: Dictionary = dict.variants.values().pick_random()
		if variant.has("base_name"):
			enemy.name = variant.base_name.pick_random()
			enemy.name_prefix = enemy.name
		if variant.has("name_prefix"):
			var prefix: String = variant.name_prefix.pick_random()
			enemy.name = prefix+" "+enemy.name
			enemy.name_prefix = prefix
		if variant.has("name_suffix"):
			enemy.name = enemy.name+" "+variant.name_suffix.pick_random()
		if variant.has("abilities"):
			enemy.abilities += variant.abilities
		if variant.has("base_stats"):
			for k in variant.base_stats.keys():
				enemy.stats[k] = variant.base_stats[k]
		if variant.has("resistance"):
			for k in variant.resistance.keys():
				enemy.resistance[k] = variant.resistance[k]
		if variant.has("soul_prefix"):
			if variant.soul_prefix is Array:
				enemy.soul_prefix = tr(variant.soul_prefix.pick_random())
			else:
				enemy.soul_prefix = tr(variant.soul_prefix)
	if !dict.has("soul_prefix"):
		enemy.soul_prefix = tr(BASE_SOUL_PREFIX.pick_random())
	if dict.has("soul_rarity"):
		enemy.soul_rarity = dict.soul_rarity
	else:
		enemy.soul_rarity = -2
	if dict.has("soul_add") && randf() > 1.0 / max(2.5 + tier, 1.0):
		enemy.soul_add = dict.soul_add
	if tier<0:
		enemy.name = dict.lesser_prefix.pick_random() + " " + enemy.name
		tier_multiplier = 1.0 / pow(1.5, -tier)
	elif tier>0:
		enemy.name = dict.greater_prefix.pick_random() + " " + enemy.name
		tier_multiplier = pow(1.5, tier)
	enemy.name = enemy.name.capitalize()
	enemy.experience *= tier_multiplier * (0.5 + 0.5 * level_multiplier)\
		* (0.3 + 0.025 * enemy.level)
	for k in enemy.stats.keys():
		enemy.stats[k] = int(enemy.stats[k] * (0.5 + 0.5 * tier_multiplier * level_multiplier))
	for k in enemy.attributes_add.keys():
		enemy.attributes_add[k] = int(enemy.attributes_add[k]\
			* (0.5 + 0.5 * tier_multiplier * level_multiplier))
	enemy.attributes_add.attack += int(enemy.level)
	enemy.attributes_add.magic += int(enemy.level)
	enemy.attributes_add.willpower += int(1.5 * enemy.level)
	enemy.attributes_add.armour += int(1.5 * enemy.level)
	if enemy.abilities.size() > 0:
		num_skills = max(num_skills, 1)
		for i in range(num_skills):
			var skill:= Skills.create_random_skill(enemy.abilities)
			@warning_ignore("integer_division")
			skill.level = int(max(level / 6 + 4 * tier, 1))
			if has_node("/root/Main"):
				get_node("/root/Main").upgrade_skill(skill)
			enemy.skills.push_back(skill)
	if dict.has("materials"):
		enemy.materials = dict.materials
	if dict.has("equipment_drop_chance"):
		enemy.equipment_drop_chance = dict.equipment_drop_chance
	if dict.has("equipment_quality"):
		enemy.equipment_quality = dict.equipment_quality
	if dict.has("equipment_enchantment_chance"):
		enemy.equipment_enchantment_chance = dict.equipment_enchantment_chance
	for skill in enemy.skills:
		if skill.range>max_range:
			max_range = skill.range
	if dict.has("race"):
		enemy.race = dict.race
	enemy.position = -max_range - 1
	
	var abilities: Dictionary[String, Dictionary] = {}
	for ability_id in enemy.abilities:
		abilities[ability_id] = {
			"name": ability_id,
			"level": int(5 * log(level)),
			"experience": 0.0,
		}
	enemy.abilities = abilities
	
	ret = Characters.Enemy.new(enemy)
	ret.recover()
	ret.description = create_tooltip(ret)
	return ret


func load_enemy_data(path: String):
	for file_name in Utils.get_file_paths(path):
		var file:= FileAccess.open(file_name, FileAccess.READ)
		var error:= FileAccess.get_open_error()
		if error != OK:
			print("Can't open file " + file_name + "!")
			continue
		else:
			print("Loading enemy " + file_name + '.')
		
		var raw:= file.get_as_text()
		var dict: Dictionary = JSON.parse_string(raw)
		if dict == null || dict.size() == 0:
			printt("Error parsing " + file_name + "!")
			continue
		for key in dict:
			base_enemies[key] = dict[key]
		file.close()

func _ready():
	load_enemy_data("res://data/enemies")
