extends Node

const STAT_POINTS_PER_LEVEL = 4
const DEFAULT_STATS = {
	"strength":10,
	"constitution":10,
	"dexterity":10,
	"intelligence":10,
	"wisdom":10,
	"cunning":10,
}
const STATS_ATTRIBUTES = {
	"strength":{
		"attack":1,
		"armour":0.5,
	},
	"constitution":{
		"armour":0.5,
	},
	"dexterity":{
		"accuracy":1,
		"evasion":1,
	},
	"intelligence":{
		"magic":1,
	},
	"wisdom":{
		"willpower":1,
	},
	"cunning":{
		"penetration":0.25,
		"critical":1,
	},
}
const STATS_METERS = {
	"strength":{
		"stamina_regen":1,
	},
	"constitution":{
		"max_health":10,
		"max_stamina":3,
		"stamina_regen":1,
	},
	"intelligence":{
		"mana_regen":1,
	},
	"wisdom":{
		"max_mana":3,
		"mana_regen":1,
	},
	"cunning":{
		"max_focus":0.5,
	},
}
const ATTRIBUTES = [
	"attack",
	"magic",
	"willpower",
	"accuracy",
	"armour",
	"evasion",
	"penetration",
	"speed",
	"critical",
]
const RESOURCES = [
	"health",
	"stamina",
	"mana",
	"focus",
]
const CRITICAL_DAMAGE = 0.5

class Character:
	var name: String
	var level: int
	var experience: int
	var health: float
	var max_health: int
	var health_regen: int
	var mana: float
	var max_mana: int
	var mana_regen: int
	var stamina: float
	var max_stamina: int
	var stamina_regen: int
	var focus: int
	var max_focus: int
	var stats: Dictionary
	var effective_stats: Dictionary
	var base_attributes: Dictionary
	var attributes: Dictionary
	var abilities: Dictionary[String, Ability]
	var skills: Array
	var damage: Dictionary
	var resistance: Dictionary
	var equipment: Dictionary
	var status: Array
	var delay: float
	var position:= 1
	var min_dist:= 0
	var action_duration: float
	var current_action: String
	var valid_weapon_subtypes: Array[String] = []
	var valid_armour_subtypes: Array[String] = []
	
	func _init(dict: Dictionary):
		# compatibility with old versions
		if dict.has("abilities"):
			if typeof(dict.abilities) == TYPE_ARRAY:
				var ab_dict:= {}
				dict = dict.duplicate(false)
				for k in dict.abilities:
					ab_dict[k] = 1
				dict.abilities = ab_dict
			elif typeof(dict.abilities) == TYPE_DICTIONARY and dict.abilities.size() > 0 and \
				typeof(dict.abilities.values()[0]) != TYPE_DICTIONARY:
				for ability_id in dict.abilities:
					dict.abilities[ability_id] = {
						"name": ability_id,
						"level": int(dict.abilities[ability_id]),
						"experience": 0,
					}
		
		for k in dict.keys():
			match k:
				"abilities":
					self.abilities = {}
					for ability_id in dict.abilities:
						self.abilities[ability_id] = Ability.new(dict.abilities[ability_id])
				_:
					if typeof(dict[k]) == TYPE_DICTIONARY || typeof(dict[k]) == TYPE_ARRAY:
						set(k, dict[k].duplicate(true))
					else:
						set(k, dict[k])
		recalc_attributes()
	
	func recalc_attributes():
		max_health = 0
		max_mana = 0
		max_stamina = 0
		max_focus = 0
		health_regen = 0
		stamina_regen = 0
		mana_regen = 0
		resistance.clear()
		damage.clear()
		attributes.clear()
		valid_weapon_subtypes.clear()
		valid_armour_subtypes.clear()
		effective_stats = stats.duplicate(true)
		
		for k in ATTRIBUTES:
			attributes[k] = 0
			base_attributes[k] = 0
		attributes.accuracy = 10
		
		for ability in abilities.keys():
			if !Skills.ABILITIES.has(ability):
				continue
			
			var dict: Dictionary = Skills.ABILITIES[ability]
			for k in attributes:
				if dict.has(k):
					attributes[k] = int(ceil(attributes[k] + dict[k] * abilities[ability].level))
					base_attributes[k] = attributes[k]
			for k in RESOURCES:
				if dict.has(k):
					set("max_" + k, get("max_" + k) + dict[k])
				if dict.has(k + "_regen"):
					set(k + "_regen", get(k + "_regen") + dict[k + "_regen"])
			if dict.has("resistance"):
				for k in dict.resistance:
					if resistance.has(k):
						resistance[k] += dict.resistance[k] * abilities[ability].level
					else:
						resistance[k] = dict.resistance[k] * abilities[ability].level
			if dict.has("damage"):
				for k in dict.damage:
					if damage.has(k):
						damage[k] += dict.damage[k] * abilities[ability].level
					else:
						damage[k] = dict.damage[k] * abilities[ability].level
			if dict.has("weapon_subtypes"):
				for t in dict.weapon_subtypes:
					if !valid_weapon_subtypes.has(t):
						valid_weapon_subtypes.push_back(t)
			if dict.has("armour_subtypes"):
				for t in dict.armour_subtypes:
					if !valid_armour_subtypes.has(t):
						valid_armour_subtypes.push_back(t)
			for k in stats:
				if dict.has(k):
					effective_stats[k] += int(dict[k])
		
		for item in equipment.values():
			for k in attributes:
				if item.has(k):
					attributes[k] = int(attributes[k] + item[k])
			for k in RESOURCES:
				if item.has(k):
					set("max_"+k, get("max_"+k) + item[k])
				if item.has(k+"_regen"):
					set(k+"_regen", get(k+"_regen") + item[k+"_regen"])
			if item.has("resistance"):
				for k in item.resistance:
					if resistance.has(k):
						resistance[k] += item.resistance[k]
					else:
						resistance[k] = item.resistance[k]
			if item.has("damage"):
				for k in item.damage:
					if damage.has(k):
						damage[k] += item.damage[k]
					else:
						damage[k] = item.damage[k]
			for k in stats:
				if item.has(k):
					effective_stats[k] += int(item[k])
		
		for dict in status:
			if dict.has("attributes"):
				for k in dict.attributes:
					if typeof(dict.attributes[k])==TYPE_DICTIONARY:
						attributes[k] = int(attributes[k] + dict.attributes[k].value)
					else:
						attributes[k] = int(attributes[k] + dict.attributes[k])
			for k in stats:
				if dict.has(k):
					effective_stats[k] += int(dict[k])
			for k in RESOURCES:
				if dict.has(k):
					set("max_"+k, get("max_"+k) + dict[k])
				if dict.has(k+"_regen"):
					set(k+"_regen", get(k+"_regen") + dict[k+"_regen"])
		
		for s in STATS_ATTRIBUTES.keys():
			for k in STATS_ATTRIBUTES[s].keys():
				attributes[k] += int(effective_stats[s]*STATS_ATTRIBUTES[s][k])
				base_attributes[k] += int(stats[s]*STATS_ATTRIBUTES[s][k])
		
		for s in STATS_METERS.keys():
			for k in STATS_METERS[s].keys():
				set(k, get(k) + effective_stats[s]*STATS_METERS[s][k])
		
		for k in attributes:
			attributes[k] = max(attributes[k], 1)
		
		if health>max_health:
			health = max_health
		if mana>max_mana:
			mana = max_mana
		if stamina>max_stamina:
			stamina = max_stamina
		if focus>max_focus:
			focus = max_focus
		if valid_armour_subtypes.size()==0:
			valid_armour_subtypes = ["medium"]
		reset_focus()
	
	func recover():
		recalc_attributes()
		health = max_health
		mana = max_mana
		stamina = max_stamina
		focus = max_focus
	
	func add_health(value: int):
		health = clamp(health + value, 0, max_health)
	
	func add_mana(value: int):
		mana = clamp(mana + value, 0, max_mana)
	
	func add_stamina(value: int):
		stamina = clamp(stamina + value, 0, max_stamina)
	
	func add_focus(value: int):
		focus = clamp(focus + value, 0, max_focus)
	
	func add_meter(type: String, value: int):
		set(type, clamp(get(type) + value, 0, get("max_"+type)))
	
	func reset_focus():
		focus = max_focus
		for s in status:
			if s.has("focus"):
				focus -= s.focus
		focus = max(focus, 0)
	
	func add_status(dict: Dictionary):
		if dict.has("attributes"):
			for k in dict.attributes.keys():
				if typeof(dict.attributes[k])==TYPE_DICTIONARY:
					attributes[k] += dict.attributes[k].value
				else:
					attributes[k] += dict.attributes[k]
		status.push_back(dict)
		recalc_attributes()
	
	func remove_status(dict: Dictionary):
		if dict.has("attributes"):
			for k in dict.attributes.keys():
				if typeof(dict.attributes[k])==TYPE_DICTIONARY:
					attributes[k] -= dict.attributes[k].value
				else:
					attributes[k] -= dict.attributes[k]
		status.erase(dict)
		recalc_attributes()
	
	func get_max_exp() -> int:
		return 50 + 25*level + 25*level*level
	
	func update(delta: float):
		var stun:= 0.0
		health = clamp(health + delta*float(health_regen)/100.0, 0, max_health)
		stamina = clamp(stamina + delta*float(stamina_regen)/100.0, 0, max_stamina)
		mana = clamp(mana + delta*float(mana_regen)/100.0, 0, max_mana)
		for st in status:
			st.duration -= delta
			if st.duration<=0.0:
				status.erase(st)
				continue
			if st.has("damage"):
				add_health(-st.damage*delta)
			if st.has("healing"):
				for k in st.healing.keys():
					add_meter(k, st.healing[k]*delta)
			if st.has("stun"):
				stun += st.stun
		stun = clamp(Characters.get_resistance(stun), 0.0, 1.0)
		delay -= delta*(1.0 - stun)
		for skill in skills:
			skill.current_cooldown -= delta*(1.0 - stun)
	
	func to_dict() -> Dictionary:
		var ability_dict:= {}
		for ability_id in self.abilities:
			ability_dict[ability_id] = self.abilities[ability_id].to_dict()
		return {
			"name": self.name,
			"level": self.level,
			"experience": self.experience,
			"health": self.health,
			"mana": self.mana,
			"stamina": self.stamina,
			"stats": self.stats,
			"attributes": self.attributes,
			"abilities": ability_dict,
			"skills": self.skills,
			"damage": self.damage,
			"resistance": self.resistance,
			"equipment": self.equipment,
			"status": self.status,
			"delay": self.delay,
			"action_duration": self.action_duration,
			"current_action": self.current_action,
		}


class Enemy:
	extends Character
	
	var base_name: String
	var name_prefix: String
	var name_suffix: String
	var soul_prefix: String
	var description: String
	var attributes_add: Dictionary
	var tier: int
	var soul_rarity: int
	var soul_add: Dictionary
	var materials: Array
	var equipment_drop_chance: float
	var equipment_quality: float
	var equipment_enchantment_chance: float
	
	func recalc_attributes():
		max_health = 0
		max_mana = 0
		max_stamina = 0
		max_focus = 0
		health_regen = 0
		stamina_regen = 0
		mana_regen = 0
		resistance.clear()
		damage.clear()
		attributes.clear()
		valid_weapon_subtypes.clear()
		valid_armour_subtypes.clear()
		
		for k in ATTRIBUTES:
			attributes[k] = 0
		for k in attributes_add.keys():
			attributes[k] += attributes_add[k]
		
		for s in STATS_ATTRIBUTES.keys():
			for k in STATS_ATTRIBUTES[s].keys():
				attributes[k] += int(stats[s]*STATS_ATTRIBUTES[s][k])
		
		for s in STATS_METERS.keys():
			for k in STATS_METERS[s].keys():
				set(k, get(k) + stats[s]*STATS_METERS[s][k])
		
		for dict in status:
			if dict.has("attributes"):
				for k in dict.attributes:
					if typeof(dict.attributes[k])==TYPE_DICTIONARY:
						attributes[k] = int(attributes[k] + dict.attributes[k].value)
					else:
						attributes[k] = int(attributes[k] + dict.attributes[k])
		
		for k in attributes:
			attributes[k] = max(attributes[k], 1)
			base_attributes[k] = attributes[k]
		
		if health>max_health:
			health = max_health
		if mana>max_mana:
			mana = max_mana
		if stamina>max_stamina:
			stamina = max_stamina
		if focus>max_focus:
			focus = max_focus
		if valid_armour_subtypes.size()==0:
			valid_armour_subtypes = ["medium"]
		reset_focus()
	
	func to_dict() -> Dictionary:
		var ability_dict:= {}
		for ability_id in self.abilities:
			ability_dict[ability_id] = self.abilities[ability_id].to_dict()
		return {
			"name": self.name,
			"base_name": self.base_name,
			"name_prefix": self.name_prefix,
			"name_suffix": self.name_suffix,
			"soul_prefix": self.soul_prefix,
			"description": self.description,
			"tier": self.tier,
			"soul_rarity": self.soul_rarity,
			"soul_add": self.soul_add,
			"level": self.level,
			"experience": self.experience,
			"health": self.health,
			"mana": self.mana,
			"stamina": self.stamina,
			"stats": self.stats,
			"attributes": self.attributes,
			"attributes_add": self.attributes_add,
			"abilities": ability_dict,
			"skills": self.skills,
			"damage": self.damage,
			"resistance": self.resistance,
			"equipment": self.equipment,
			"status": self.status,
			"delay": self.delay,
			"materials": self.materials,
			"equipment_drop_chance": self.equipment_drop_chance,
			"equipment_quality": self.equipment_quality,
			"equipment_enchantment_chance": self.equipment_enchantment_chance,
		}


class Summon:
	extends Character
	
	var description: String
	var attributes_add: Dictionary
	var duration: float
	var tier:= 1
	var base_name:= tr("SUMMON")
	
	func recalc_attributes():
		max_health = 0
		max_mana = 0
		max_stamina = 0
		max_focus = 0
		health_regen = 0
		stamina_regen = 0
		mana_regen = 0
		resistance.clear()
		damage.clear()
		attributes.clear()
		valid_weapon_subtypes.clear()
		valid_armour_subtypes.clear()
		
		for k in ATTRIBUTES:
			attributes[k] = 0
		for k in attributes_add.keys():
			attributes[k] += attributes_add[k]
		
		for s in STATS_ATTRIBUTES.keys():
			for k in STATS_ATTRIBUTES[s].keys():
				attributes[k] += int(stats[s]*STATS_ATTRIBUTES[s][k])
		
		for s in STATS_METERS.keys():
			for k in STATS_METERS[s].keys():
				set(k, get(k) + stats[s]*STATS_METERS[s][k])
		
		for dict in status:
			if dict.has("attributes"):
				for k in dict.attributes:
					if typeof(dict.attributes[k])==TYPE_DICTIONARY:
						attributes[k] = int(attributes[k] + dict.attributes[k].value)
					else:
						attributes[k] = int(attributes[k] + dict.attributes[k])
		
		for k in attributes:
			attributes[k] = max(attributes[k], 1)
			base_attributes[k] = attributes[k]
		
		if health>max_health:
			health = max_health
		if mana>max_mana:
			mana = max_mana
		if stamina>max_stamina:
			stamina = max_stamina
		if focus>max_focus:
			focus = max_focus
		if valid_armour_subtypes.size()==0:
			valid_armour_subtypes = ["medium"]
		reset_focus()
	
	func to_dict() -> Dictionary:
		var ability_dict:= {}
		for ability_id in self.abilities:
			ability_dict[ability_id] = self.abilities[ability_id].to_dict()
		return {
			"name": self.name,
			"level": self.level,
			"experience": self.experience,
			"health": self.health,
			"mana": self.mana,
			"stamina": self.stamina,
			"stats": self.stats,
			"attributes": self.attributes,
			"abilities": ability_dict,
			"skills": self.skills,
			"damage": self.damage,
			"resistance": self.resistance,
			"equipment": self.equipment,
			"status": self.status,
			"delay": self.delay,
			"duration": self.duration,
		}


class CharacterSettings:
	var weapon_1h_alowed:= true
	var weapon_2h_alowed:= true
	var valid_weapon_types: Array[String] = []
	var valid_armour_types: Array[String] = []
	var valid_potion_types: Array[String] = ["health"]
	var disabled_skill_modules: Array[String] = []
	var disabled_recipes: Array[String] = []
	var auto_update_options:= true
	
	func _init(dict: Dictionary = {}):
		for k in dict.keys():
			set(k, dict[k])
	
	func to_dict() -> Dictionary:
		return {
			"weapon_1h_alowed": weapon_1h_alowed,
			"weapon_2h_alowed": weapon_2h_alowed,
			"valid_weapon_types": valid_weapon_types,
			"valid_armour_types": valid_armour_types,
			"valid_potion_types": valid_potion_types,
			"disabled_skill_modules": disabled_skill_modules,
			"disabled_recipes": disabled_recipes,
			"auto_update_options": true,
		}




func get_resistance(raw: float) -> float:
	return (1.0 - exp(-abs(raw)))*sign(raw)


# battle related #

func check_hit(actor: Character, target: Character, skill:= {}) -> bool:
	var accuracy: int = actor.attributes.accuracy
	if skill.has("attributes") && skill.attributes.has("accuracy"):
		var add_acc: float = skill.attributes.accuracy
		accuracy += int(add_acc)
	return randi()%max(accuracy, 1) >= randi()%int(max(target.attributes.evasion, 1))

func check_crit(actor: Character, target: Character, skill:= {}) -> bool:
	var critical: int = actor.attributes.critical
	if skill.has("attributes") && skill.attributes.has("critical"):
		var add_crit: float = skill.attributes.critical
		critical += int(add_crit)
	return randi()%max(critical, 1) >= randi()%int(max(target.attributes.evasion + target.attributes.critical, 1))

func calc_combat_damage(data: Dictionary, actor: Character, mod:={}, damage_multiplier:= 1.0) -> Dictionary:
	var value:= 0
	if data.has("scaling"):
		if actor.attributes.has(data.scaling):
			value = actor.attributes[data.scaling]
			if mod.has("attributes") && mod.attributes.has(data.scaling):
				value += mod.attributes[data.scaling]
		elif actor.stats.has(data.scaling):
			value = actor.stats[data.scaling]
			if mod.has("stats") && mod.stats.has(data.scaling):
				value += mod.stats[data.scaling]
	else:
		value = 1
	return {"value":int(data.value*float(value)*damage_multiplier), "type":data.type}

func calc_damage(skill: Dictionary, actor: Character, target: Character, dam_multiplier:= 1.0) -> Dictionary:
	var result:= {
		"attack":0,
		"damage":0,
		"critical":0,
		"absorbed":0,
		"blocked_armour":0,
		"blocked_willpower":0,
		"resisted":0,
		"enhanced":0,
		"penetrated":0,
		"reflected":0,
	}
	var penetration: int = actor.attributes.penetration
	var armour_penetration:= 0.0
	var total_damage_instances:= 0
	if skill.has("attributes") && skill.attributes.has("penetration"):
		penetration = max(penetration + skill.attributes.penetration, 0)
	if skill.has("armour_penetration"):
		armour_penetration = get_resistance(skill.armour_penetration)
	for combat_array in skill.combat.damage:
		var dam_instances:= []
		var total_attack:= 0
		var attack: int
		for c in combat_array:
			var attack_multiplier:= 1.0
			if check_crit(actor, target, skill):
				attack_multiplier += max(CRITICAL_DAMAGE + (actor.attributes.critical - target.attributes.critical)/100.0, 0.0)
				result.critical += 1
			var dict:= calc_combat_damage(c, actor, skill, attack_multiplier)
			dam_instances.push_back(dict)
			total_attack += dict.value
		attack = int(dam_multiplier*total_attack)
		total_damage_instances += combat_array.size()
		result.attack += total_attack
		
		for status in target.status:
			if !status.has("shielding"):
				continue
			for c in dam_instances:
				for shield in status.shielding:
					var fraction:= 0.5 + 0.5*float(c.type==shield.type)
					var absorbed: int = fraction*min(c.value, shield.value)
					c.value -= absorbed
					attack -= absorbed
					shield.value -= absorbed
					result.absorbed += absorbed
					if status.has("reflect_damage"):
						result.reflected += status.reflect_damage*absorbed
		
		for c in dam_instances:
			var armour_type: String
			var blocked: int
			var blocked_individual: int
			if c.type in Skills.PHYSICAL_DAMAGE_TYPES:
				armour_type = "armour"
			else:
				armour_type = "willpower"
			
			blocked = max(target.attributes[armour_type] - actor.attributes.penetration, 0)
			blocked_individual = (attack - max(attack - blocked, 0))*c.value/max(float(attack), 1.0)
			c.value = int(c.value - (1.0-armour_penetration)*blocked_individual)
			result["blocked_"+armour_type] += int((1.0-armour_penetration)*blocked_individual)
			result.penetrated += int(armour_penetration*blocked_individual)
		for c in dam_instances:
			if c.value<=0:
				dam_instances.erase(c)
		if dam_instances.size()==0:
			return result
		
		for c in dam_instances:
			var resistance:= 0.0
			if target.resistance.has(c.type):
				resistance = target.resistance[c.type]
			if actor.damage.has(c.type):
				resistance -= actor.damage[c.type]
			resistance = get_resistance(resistance)
			c.value = int(c.value*(1.0-resistance))
			if resistance>=0.0:
				result.resisted += int(ceil(c.value*resistance))
			else:
				result.enhanced += int(floor(-c.value*resistance))
			
			result.damage += c.value
	result.critical /= max(float(total_damage_instances), 1.0)
	return result

func _calc_damage(skill: Dictionary, actor: Character, target: Character) -> Dictionary:
	var result:= {
		"type":skill.damage_type,
		"damage":0,
		"critical":0,
		"absorbed":0,
		"blocked_armour":0,
		"blocked_willpower":0,
		"resisted":0,
		"penetrated":0,
	}
	var base_attack:= 0
	var resistance:= 0.0
	var damage:= 0
	if target.resistance.has(skill.damage_type):
		resistance += target.resistance[skill.damage_type]
	if actor.damage.has(skill.damage_type):
		resistance -= actor.damage[skill.damage_type]
	resistance = get_resistance(resistance)
	if typeof(skill.damage_stat)==TYPE_ARRAY:
		for k in skill.damage_stat:
			base_attack += actor.stats[k]
	else:
		base_attack += actor.stats[skill.damage_stat]
	if check_crit(actor, target, skill):
		base_attack = int(base_attack*CRITICAL_DAMAGE)
		result.critical = true
	for status in target.status:
		if !status.has("absorb_damage") || status.absorb_damage<=0.0:
			continue
		var absorbed: int = min(base_attack, status.absorb_damage/max(1.0 - max(resistance, 0.0), 1e-3))
		base_attack -= absorbed
		status.absorb_damage -= absorbed*(1.0 - max(resistance, 0.0))
		if status.absorb_damage<=0:
			status.duration = 0.0
			status.absorb_damage = 0
		result.absorbed += absorbed
	result.attack = base_attack
	if base_attack<=0:
		return result
	if typeof(skill.attack_type)==TYPE_ARRAY:
		for k in skill.attack_type:
			if k=="magic" || k=="willpower":
				var blocked: int = max(target.attributes.willpower - actor.attributes.penetration, 0)
				damage += int(max(max(base_attack + actor.attributes[k] - blocked, 0) - base_attack, 0))
				result.blocked_willpower += blocked
			else:
				var blocked: int = max(target.attributes.armour - actor.attributes.penetration, 0.0)
				damage += int(max(max(base_attack + actor.attributes[k] - blocked, 0.0) - base_attack, 0.0))
				result.blocked_armour += blocked
		damage /= max(skill.attack_type.size(), 1.0)
		result.blocked_willpower /= max(skill.attack_type.size(), 1.0)
		result.blocked_armour /= max(skill.attack_type.size(), 1.0)
	else:
		if skill.attack_type=="magic" || skill.attack_type=="willpower":
			var blocked: int = max(target.attributes.willpower - actor.attributes.penetration, 0)
			damage = max(base_attack + actor.attributes[skill.attack_type] - max(target.attributes.willpower - actor.attributes.penetration, 0.0), 0.0)
			result.blocked_willpower = blocked
		else:
			var blocked: int = max(target.attributes.armour - actor.attributes.penetration, 0.0)
			damage = max(base_attack + actor.attributes[skill.attack_type] - max(target.attributes.armour - actor.attributes.penetration, 0.0), 0.0)
			result.blocked_armour = blocked
	if skill.has("armour_penetration"):
		damage = damage*(1.0-skill.armour_penetration) + base_attack*skill.armour_penetration
		result.penetrated = base_attack*skill.armour_penetration
	if skill.has("damage_scale"):
		damage *= skill.damage_scale
	damage = int(max(damage*(1.0-resistance), 0))
	result.damage = damage
	result.resisted = int(ceil(damage*resistance))
	return result

func calc_heal(skill: Dictionary, actor: Character, heal_multiplier:= 1.0) -> Dictionary:
	var total_heal:= {}
	for combat_array in skill.combat.healing:
		for c in combat_array:
			var dict:= calc_combat_damage(c, actor, skill)
			if total_heal.has(dict.type):
				total_heal[dict.type] += heal_multiplier*dict.value
			else:
				total_heal[dict.type] = heal_multiplier*dict.value
	return total_heal

func _calc_heal(skill: Dictionary, actor: Character) -> int:
	var heal: int = actor.attributes[skill.healing_type] + actor.stats[skill.healing_stat]
	if skill.has("healing_scale"):
		heal *= skill.healing_scale
	return heal

func create_status(dict: Dictionary, actor: Character, target: Character, duration_multiplier:=1.0) -> Dictionary:
	var status:= {
		"type":dict.type,
		"name":dict.name,
		"duration":dict.duration,
		"max_duration":dict.duration*duration_multiplier,
	}
	if dict.has("focus"):
		status.focus = dict.focus
	if dict.has("attributes"):
		status.attributes = dict.attributes.duplicate(true)
		if dict.has("scaling"):
			for k in status.attributes.keys():
				if typeof(status.attributes[k])==TYPE_DICTIONARY:
					status.attributes[k].value = status.attributes[k].value + dict.scaling*actor.base_attributes[status.attributes[k].attribute]
				else:
					var value:= 0.0
					if dict.has("scaling_attribute"):
						value += status.attributes[k] + dict.scaling*actor.base_attributes[dict.scaling_attribute]
					if dict.has("scaling_stat"):
						value += status.attributes[k] + dict.scaling*actor.stats[dict.scaling_stat]
					status.attributes[k] = value
		else:
			for k in status.attributes.keys():
				if typeof(status.attributes[k])==TYPE_DICTIONARY:
					status.attributes[k].value = status.attributes[k].value + dict.scaling*actor.base_attributes[status.attributes[k].attribute]
	if dict.has("damage"):
		var total_damage:= 0
		var attack_multiplier:= 1.0
		if check_crit(actor, target):
			attack_multiplier += max(CRITICAL_DAMAGE + (actor.attributes.critical - target.attributes.critical)/100.0, 0.0)
		for c in dict.damage:
			var dam_dict:= calc_combat_damage(c, actor, {}, attack_multiplier)
			var resistance:= 0.0
			if target.resistance.has(dam_dict.type):
				resistance = target.resistance[dam_dict.type]
			if actor.damage.has(dam_dict.type):
				resistance -= actor.damage[dam_dict.type]
			resistance = get_resistance(resistance)
			dam_dict.value *= 1.0-resistance
			total_damage += dam_dict.value
		status.damage = total_damage/max(dict.duration, 0.1)
	if dict.has("healing"):
		var total_heal:= {}
		var healing_multiplier:= 1.0
		if check_crit(actor, target):
			healing_multiplier += CRITICAL_DAMAGE + actor.attributes.critical/100.0
		for c in dict.healing:
			var heal_dict:= calc_combat_damage(c, actor, {}, healing_multiplier)
			if total_heal.has(heal_dict.type):
				total_heal[heal_dict.type] += heal_dict.value
			else:
				total_heal[heal_dict.type] = heal_dict.value
		for c in dict.healing:
			c.value /= max(dict.duration, 0.1)
		status.healing = total_heal
	if dict.has("shielding"):
		var dam_instances:= []
		for c in dict.shielding:
			var shield_multiplier:= 1.0
			if check_crit(actor, target):
				shield_multiplier += CRITICAL_DAMAGE + actor.attributes.critical/100.0
			var dam_dict:= calc_combat_damage(c, actor, {}, shield_multiplier)
			dam_instances.push_back(dam_dict)
		status.shielding = dam_instances
	
	return status

func _create_status(dict: Dictionary, actor: Character, value_scale:=1.0) -> Dictionary:
	var status:= {
		"type":dict.type,
		"name":dict.name,
		"duration":dict.duration,
		"max_duration":dict.duration,
	}
	var value: float = value_scale
	if dict.has("effect_stat"):
		value *= actor.stats[dict.effect_stat]
	if dict.type=="debuff":
		value *= -1.0
	if dict.has("effect_scale"):
		value *= dict.effect_scale
	if dict.has("health_regen"):
		status.health_regen = int(ceil(float(dict.health_regen)/100.0*value))
	if dict.has("effect"):
		if typeof(dict.effect)==TYPE_ARRAY:
			status.attributes = {}
			for k in dict.effect:
				status.attributes[k] = int(ceil(value))
		else:
			status.attributes = {dict.effect:int(ceil(value))}
	if dict.has("absorb_damage"):
		status.absorb_damage = int(ceil(dict.absorb_damage*value))
	return status

func create_summon(dict: Dictionary, actor: Character, value_scale:=1.0) -> Summon:
	var creature_dict:= {
		"name":dict.summon_name.base.pick_random().capitalize(),
		"level":actor.level,
		"tier":-1,
		"base_name":"summon",
		"stats":dict.summon_stats.duplicate(true),
		"attributes_add":dict.summon_attributes.duplicate(true),
		"abilities":dict.summon_abilities.duplicate(true),
		"duration":dict.duration,
		"position":actor.position + (2*int(actor is Enemy) - 1)*dict.range,
	}
	var value:= 0.0
	var creature: Summon
	if dict.has("summon_damage"):
		creature_dict.damage = dict.summon_damage.duplicate()
	if dict.has("summon_resistance"):
		creature_dict.resistance = dict.summon_resistance.duplicate()
	if dict.summon_name.has("prefix"):
		creature_dict.name = dict.summon_name.prefix.pick_random().capitalize() + " " + creature_dict.name
	for k in dict.summoning.keys():
		if k in actor.attributes:
			value += value_scale*actor.attributes[k]/10.0*dict.summoning[k]
		if k in actor.stats:
			value += value_scale*actor.stats[k]*3.0/100.0*dict.summoning[k]
	for k in creature_dict.attributes_add.keys():
		creature_dict.attributes_add[k] = int(1.5*value*creature_dict.attributes_add[k])
	for k in creature_dict.stats.keys():
		creature_dict.stats[k] = int((0.5 + 0.5*value)*creature_dict.stats[k])
	creature_dict.duration *= 0.5 + 0.5*value
	
	var abilities: Dictionary[String, Dictionary] = {}
	for ability_id in creature_dict.abilities:
		abilities[ability_id] = {
			"name": ability_id,
			"level": int(5 * log(actor.level)),
			"experience": 0.0,
		}
	creature_dict.abilities = abilities
	
	creature = Summon.new(creature_dict)
	creature.recover()
	for i in range(3):
		creature.skills.push_back(Skills.create_random_skill(creature_dict.abilities.keys()))
	creature_dict.skills = creature.skills
	creature_dict.attributes = creature.attributes
	creature.description = Enemies.create_tooltip(creature)
	return creature
