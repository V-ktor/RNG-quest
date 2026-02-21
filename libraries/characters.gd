extends Node

const STAT_POINTS_PER_LEVEL := 4
const DEFAULT_STATS: Dictionary[String, int] = {
	"strength": 10,
	"constitution": 10,
	"dexterity": 10,
	"intelligence": 10,
	"wisdom": 10,
	"cunning": 10,
}
const STATS_ATTRIBUTES: Dictionary[String, Dictionary] = {
	"strength": {
		"attack": 1,
		"armour": 0.5,
	},
	"constitution": {
		"armour": 0.5,
	},
	"dexterity": {
		"accuracy": 1,
		"evasion": 1,
	},
	"intelligence": {
		"magic": 1,
	},
	"wisdom": {
		"willpower": 1,
	},
	"cunning": {
		"penetration": 0.25,
		"critical": 1,
	},
}
const STATS_METERS: Dictionary[String, Dictionary] = {
	"strength": {
		"stamina_regen": 1,
	},
	"constitution": {
		"max_health": 10,
		"max_stamina": 3,
		"stamina_regen": 1,
	},
	"intelligence": {
		"mana_regen": 1,
	},
	"wisdom": {
		"max_mana": 3,
		"mana_regen": 1,
	},
	"cunning": {
		"max_focus": 0.5,
	},
}
const ATTRIBUTES: Array[String] = [
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
const RESOURCES: Array[String] = [
	"health",
	"stamina",
	"mana",
	"focus",
]
const CRITICAL_DAMAGE := 0.5

class Character:
	var name: String
	var race: String
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
	var stats: Dictionary[String, int]
	var effective_stats: Dictionary[String, int]
	var base_attributes: Dictionary[String, int]
	var attributes: Dictionary[String, int]
	var abilities: Dictionary[String, Ability]
	var skills: Array[Dictionary]
	var damage: Dictionary[String, float]
	var resistance: Dictionary[String, float]
	var equipment: Dictionary[String, ItemEquipment]
	var status: Array[Dictionary]
	var delay: float
	var position := 1
	var min_dist := 0
	var action_duration: float
	var current_action: String
	var valid_weapon_subtypes: Array[String] = []
	var valid_armour_subtypes: Array[String] = []
	
	func _init(dict: Dictionary) -> void:
		for k: String in dict:
			match k:
				"stats":
					self.stats.clear()
					for stat: String in dict.stats:
						self.stats[stat] = dict.stats[stat] as int
				"abilities":
					self.abilities.clear()
					for ability_id: String in dict.abilities:
						self.abilities[ability_id] = Ability.new(dict.abilities[ability_id] as Dictionary)
				"skills":
					self.skills.clear()
					for skill: Dictionary in dict.skills:
						self.skills.push_back(skill as Dictionary)
				"equipment":
					self.equipment.clear()
					for equipment_id: String in dict.equipment:
						self.equipment[equipment_id] = ItemEquipment.new(dict.equipment[equipment_id] as Dictionary)
				"status":
					self.status.clear()
					for s: Dictionary in dict.status:
						self.status.push_back(s)
				_:
					if typeof(dict[k]) == TYPE_DICTIONARY || typeof(dict[k]) == TYPE_ARRAY:
						self.set(k, dict[k].duplicate(true))
					else:
						self.set(k, dict[k])
		self.recalc_attributes()
	
	func recalc_attributes() -> void:
		self.max_health = 0
		self.max_mana = 0
		self.max_stamina = 0
		self.max_focus = 0
		self.health_regen = 0
		self.stamina_regen = 0
		self.mana_regen = 0
		self.resistance.clear()
		self.damage.clear()
		self.attributes.clear()
		self.valid_weapon_subtypes.clear()
		self.valid_armour_subtypes.clear()
		self.effective_stats = stats.duplicate(true)
		
		for k in ATTRIBUTES:
			self.attributes[k] = 0
			self.base_attributes[k] = 0
		self.attributes.accuracy = 10
		
		for ability in self.abilities:
			if ability not in Skills.ABILITIES:
				continue
			
			var dict: Dictionary = Skills.ABILITIES[ability]
			for k in self.attributes:
				if k in dict:
					self.attributes[k] = ceili(self.attributes[k] + \
						(dict[k] as int) * self.abilities[ability].level)
					self.base_attributes[k] = self.attributes[k]
			for k in RESOURCES:
				if k in dict:
					self.set("max_" + k, self.get("max_" + k) + dict[k])
				if k + "_regen" in dict:
					self.set(k + "_regen", self.get(k + "_regen") + dict[k + "_regen"])
			if "resistance" in dict:
				for k: String in dict.resistance:
					if self.resistance.has(k):
						self.resistance[k] += dict.resistance[k] * self.abilities[ability].level
					else:
						self.resistance[k] = dict.resistance[k] * self.abilities[ability].level
			if "damage" in dict:
				for k: String in dict.damage:
					if self.damage.has(k):
						self.damage[k] += dict.damage[k] * self.abilities[ability].level
					else:
						self.damage[k] = dict.damage[k] * self.abilities[ability].level
			if "weapon_subtypes" in dict:
				for t: String in dict.weapon_subtypes:
					if t not in self.valid_weapon_subtypes:
						self.valid_weapon_subtypes.push_back(t)
			if "armour_subtypes" in dict:
				for t: String in dict.armour_subtypes:
					if t not in self.valid_armour_subtypes:
						self.valid_armour_subtypes.push_back(t)
			for k in stats:
				if k in dict:
					effective_stats[k] += dict[k] as int
		
		for equipment_id in self.equipment:
			var item := self.equipment[equipment_id]
			for k in attributes:
				if k in item.attributes:
					self.attributes[k] += item.attributes[k]
			for k in RESOURCES:
				if k in item.resources:
					self.set("max_" + k, self.get("max_" + k) + item[k])
				if k in item.resource_regen:
					self.set(k + "_regen", self.get(k + "_regen") + item.resource_regen[k])
			for k in item.resistance:
				if k in self.resistance:
					self.resistance[k] += item.resistance[k]
				else:
					self.resistance[k] = item.resistance[k]
			for k in item.damage:
				if k in self.damage:
					self.damage[k] += item.damage[k]
				else:
					self.damage[k] = item.damage[k]
			for k in item.stats:
				effective_stats[k] += item.stats[k]
		
		for dict in self.status:
			if "attributes" in dict:
				for k: String in dict.attributes:
					if typeof(dict.attributes[k]) == TYPE_DICTIONARY:
						self.attributes[k] = self.attributes[k] + (dict.attributes[k].value as int)
					else:
						self.attributes[k] = self.attributes[k] + (dict.attributes[k] as int)
			for k in self.stats:
				if k in dict:
					self.effective_stats[k] += dict[k] as int
			for k in RESOURCES:
				if k in dict:
					self.set("max_" + k, self.get("max_" + k) + dict[k])
				if k + "_regen" in dict:
					self.set(k + "_regen", self.get(k + "_regen") + dict[k + "_regen"])
		
		for s in STATS_ATTRIBUTES:
			for k: String in STATS_ATTRIBUTES[s]:
				self.attributes[k] += floori(self.effective_stats[s] * (STATS_ATTRIBUTES[s][k] as float))
				self.base_attributes[k] += floori(self.stats[s] * (STATS_ATTRIBUTES[s][k] as float))
		
		for s in STATS_METERS:
			for k: String in STATS_METERS[s]:
				self.set(k, self.get(k) + effective_stats[s]*STATS_METERS[s][k])
		
		for k in self.attributes:
			self.attributes[k] = maxi(self.attributes[k], 1)
		
		if self.health > self.max_health:
			self.health = self.max_health
		if self.mana > self.max_mana:
			self.mana = self.max_mana
		if self.stamina > self.max_stamina:
			self.stamina = self.max_stamina
		if self.focus > self.max_focus:
			self.focus = self.max_focus
		if self.valid_armour_subtypes.size() == 0:
			self.valid_armour_subtypes = ["medium"]
		self.reset_focus()
	
	func recover() -> void:
		self.recalc_attributes()
		self.health = self.max_health
		self.mana = self.max_mana
		self.stamina = self.max_stamina
		self.focus = self.max_focus
	
	func add_health(value: int) -> void:
		self.health = clampf(self.health + value, 0.0, self.max_health)
	
	func add_mana(value: int) -> void:
		self.mana = clampf(self.mana + value, 0.0, self.max_mana)
	
	func add_stamina(value: int) -> void:
		self.stamina = clampf(self.stamina + value, 0.0, self.max_stamina)
	
	func add_focus(value: int) -> void:
		self.focus = clampi(self.focus + value, 0, self.max_focus)
	
	func add_meter(type: String, value: int) -> void:
		self.set(type, clampf((self.get(type) as float) + value, 0, self.get("max_" + type) as int))
	
	func reset_focus() -> void:
		self.focus = self.max_focus
		for s in self.status:
			if "focus" in s:
				self.focus -= s.focus
		self.focus = maxi(self.focus, 0)
	
	func add_status(dict: Dictionary) -> void:
		if "attributes" in dict:
			for k: String in dict.attributes:
				if typeof(dict.attributes[k]) == TYPE_DICTIONARY:
					self.attributes[k] += dict.attributes[k].value
				else:
					self.attributes[k] += dict.attributes[k]
		self.status.push_back(dict)
		self.recalc_attributes()
	
	func remove_status(dict: Dictionary) -> void:
		if "attributes" in dict:
			for k: String in dict.attributes:
				if typeof(dict.attributes[k]) == TYPE_DICTIONARY:
					self.attributes[k] -= dict.attributes[k].value
				else:
					self.attributes[k] -= dict.attributes[k]
		self.status.erase(dict)
		self.recalc_attributes()
	
	func get_max_exp() -> int:
		return 50 + 25 * self.level + 25 * self.level * self.level
	
	func update(delta: float) -> void:
		var stun:= 0.0
		self.health = clampf(self.health + delta * float(self.health_regen) / 100.0, 0.0, self.max_health)
		self.stamina = clampf(self.stamina + delta * float(self.stamina_regen) / 100.0, 0.0, self.max_stamina)
		self.mana = clampf(self.mana + delta * float(self.mana_regen) / 100.0, 0.0, self.max_mana)
		for st in self.status:
			st.duration -= delta
			if st.duration<=0.0:
				status.erase(st)
				continue
			if "damage" in st:
				self.add_health(-st.damage * delta)
			if "healing" in st:
				for k: String in st.healing:
					self.add_meter(k, st.healing[k] * delta)
			if "stun" in st:
				stun += st.stun
		stun = clampf(Characters.get_resistance(stun), 0.0, 1.0)
		self.delay -= delta * (1.0 - stun)
		for skill in self.skills:
			skill.current_cooldown -= delta * (1.0 - stun)
	
	func to_dict() -> Dictionary:
		var ability_dict := {}
		var equipment_dict := {}
		for ability_id in self.abilities:
			ability_dict[ability_id] = self.abilities[ability_id].to_dict()
		for equipment_id in self.equipment:
			equipment_dict[equipment_id] = self.equipment[equipment_id].to_dict()
		return {
			"name": self.name,
			"race": self.race,
			"level": self.level,
			"experience": self.experience,
			"health": self.health,
			"mana": self.mana,
			"stamina": self.stamina,
			"stats": self.stats,
			#"attributes": self.attributes,
			"abilities": ability_dict,
			"skills": self.skills,
			"damage": self.damage,
			"resistance": self.resistance,
			"equipment": equipment_dict,
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
	var attributes_add: Dictionary[String, int]
	var tier: int
	var soul_rarity: int
	var soul_add: Dictionary
	var materials: Array
	var equipment_drop_chance: float
	var equipment_quality: float
	var equipment_enchantment_chance: float
	
	func recalc_attributes() -> void:
		self.max_health = 0
		self.max_mana = 0
		self.max_stamina = 0
		self.max_focus = 0
		self.health_regen = 0
		self.stamina_regen = 0
		self.mana_regen = 0
		self.resistance.clear()
		self.damage.clear()
		self.attributes.clear()
		self.valid_weapon_subtypes.clear()
		self.valid_armour_subtypes.clear()
		
		for k in ATTRIBUTES:
			attributes[k] = 0
		for k in self.attributes_add:
			attributes[k] += self.attributes_add[k]
		
		for s in STATS_ATTRIBUTES:
			for k: String in STATS_ATTRIBUTES[s]:
				self.attributes[k] += stats[s] * (STATS_ATTRIBUTES[s][k] as int)
		
		for s in STATS_METERS:
			for k: String in STATS_METERS[s]:
				self.set(k, self.get(k) + stats[s] * (STATS_METERS[s][k] as int))
		
		for dict in self.status:
			if "attributes" in dict:
				for k: String in dict.attributes:
					if typeof(dict.attributes[k])==TYPE_DICTIONARY:
						self.attributes[k] = self.attributes[k] + (dict.attributes[k].value as int)
					else:
						self.attributes[k] = self.attributes[k] + (dict.attributes[k] as int)
		
		for k in self.attributes:
			self.attributes[k] = max(self.attributes[k], 1)
			self.base_attributes[k] = self.attributes[k]
		
		if self.health > self.max_health:
			self.health = self.max_health
		if self.mana > self.max_mana:
			self.mana = self.max_mana
		if self.stamina > self.max_stamina:
			self.stamina = self.max_stamina
		if self.focus > self.max_focus:
			self.focus = self.max_focus
		if self.valid_armour_subtypes.size() == 0:
			self.valid_armour_subtypes = ["medium"]
		self.reset_focus()
	
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
			#"attributes": self.attributes,
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
	var attributes_add: Dictionary[String, int]
	var duration: float
	var tier:= 1
	var base_name:= tr("SUMMON")
	
	func recalc_attributes() -> void:
		self.max_health = 0
		self.max_mana = 0
		self.max_stamina = 0
		self.max_focus = 0
		self.health_regen = 0
		self.stamina_regen = 0
		self.mana_regen = 0
		self.resistance.clear()
		self.damage.clear()
		self.attributes.clear()
		self.valid_weapon_subtypes.clear()
		self.valid_armour_subtypes.clear()
		
		for k in ATTRIBUTES:
			self.attributes[k] = 0
		for k in attributes_add:
			self.attributes[k] += self.attributes_add[k]
		
		for s in STATS_ATTRIBUTES:
			for k: String in STATS_ATTRIBUTES[s]:
				self.attributes[k] += self.stats[s] * (STATS_ATTRIBUTES[s][k] as int)
		
		for s in STATS_METERS:
			for k: String in STATS_METERS[s]:
				self.set(k, self.get(k) + self.stats[s] * (STATS_METERS[s][k] as int))
		
		for dict in status:
			if "attributes" in dict:
				for k: String in dict.attributes:
					if typeof(dict.attributes[k]) == TYPE_DICTIONARY:
						self.attributes[k] = self.attributes[k] + (dict.attributes[k].value as int)
					else:
						self.attributes[k] = self.attributes[k] + (dict.attributes[k] as int)
		
		for k in self.attributes:
			self.attributes[k] = maxi(self.attributes[k], 1)
			self.base_attributes[k] = self.attributes[k]
		
		if self.health > self.max_health:
			self.health = self.max_health
		if self.mana > self.max_mana:
			self.mana = self.max_mana
		if self.stamina > self.max_stamina:
			self.stamina = self.max_stamina
		if self.focus > self.max_focus:
			self.focus = self.max_focus
		if self.valid_armour_subtypes.size() == 0:
			self.valid_armour_subtypes = ["medium"]
		self.reset_focus()
	
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
			#"attributes": self.attributes,
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
	
	func _init(dict: Dictionary = {}) -> void:
		for k: String in dict:
			self.set(k, dict[k])
	
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
	return (1.0 - exp(-absf(raw))) * signf(raw)


# battle related #

func check_hit(actor: Character, target: Character, skill:= {}) -> bool:
	var accuracy: int = actor.attributes.accuracy
	if "attributes" in skill and "accuracy" in skill.attributes:
		var add_acc: float = skill.attributes.accuracy
		accuracy += int(add_acc)
	return randi() % maxi(accuracy, 1) >= randi() % maxi(target.attributes.evasion, 1)

func check_crit(actor: Character, target: Character, skill:= {}) -> bool:
	var critical: int = actor.attributes.critical
	if "attributes" in skill and "critical" in skill.attributes:
		var add_crit: float = skill.attributes.critical
		critical += int(add_crit)
	return randi() % maxi(critical, 1) >= randi() % maxi(target.attributes.evasion + target.attributes.critical, 1)

func calc_combat_damage(data: Dictionary, actor: Character, mod:={}, damage_multiplier:= 1.0) -> Dictionary:
	var value:= 0
	if "scaling" in data:
		if actor.attributes.has(data.scaling):
			value = actor.attributes[data.scaling]
			if "attributes" in mod and data.scaling in mod.attributes:
				value += mod.attributes[data.scaling]
		elif actor.stats.has(data.scaling):
			value = actor.stats[data.scaling]
			if "stats" in mod && data.scaling in mod.stats:
				value += mod.stats[data.scaling]
	else:
		value = 1
	return {
		"value": floori((data.value as float) * float(value) * damage_multiplier),
		"type": data.type,
	}

func calc_damage(skill: Dictionary, actor: Character, target: Character, dam_multiplier:= 1.0) -> Dictionary:
	var result:= {
		"attack": 0,
		"damage": 0,
		"critical": 0,
		"absorbed": 0,
		"blocked_armour": 0,
		"blocked_willpower": 0,
		"resisted": 0,
		"enhanced": 0,
		"penetrated": 0,
		"reflected": 0,
	}
	var penetration: int = actor.attributes.penetration
	var armour_penetration:= 0.0
	var total_damage_instances:= 0
	if "attributes" in skill and "penetration" in skill.attributes:
		penetration = max(penetration + skill.attributes.penetration, 0)
	if "armour_penetration" in skill:
		armour_penetration = get_resistance(skill.armour_penetration as float)
	for combat_array: Array in skill.combat.damage:
		var dam_instances:= []
		var total_attack:= 0
		var attack: int
		for c: Dictionary in combat_array:
			var attack_multiplier:= 1.0
			if check_crit(actor, target, skill):
				attack_multiplier += max(CRITICAL_DAMAGE + (actor.attributes.critical - target.attributes.critical) / 100.0, 0.0)
				result.critical += 1
			var dict:= calc_combat_damage(c, actor, skill, attack_multiplier)
			dam_instances.push_back(dict)
			total_attack += dict.value
		attack = int(dam_multiplier * total_attack)
		total_damage_instances += combat_array.size()
		result.attack += total_attack
		
		for status in target.status:
			if !status.has("shielding"):
				continue
			for c: Dictionary in dam_instances:
				for shield: Dictionary in status.shielding:
					var fraction := 0.5 + 0.5 * float(c.type == shield.type)
					var absorbed: int = fraction*min(c.value, shield.value)
					c.value -= absorbed
					attack -= absorbed
					shield.value -= absorbed
					result.absorbed += absorbed
					if status.has("reflect_damage"):
						result.reflected += status.reflect_damage*absorbed
		
		for c: Dictionary in dam_instances:
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
		for c: Dictionary in dam_instances:
			if c.value<=0:
				dam_instances.erase(c)
		if dam_instances.size()==0:
			return result
		
		for c: Dictionary in dam_instances:
			var resistance:= 0.0
			if target.resistance.has(c.type):
				resistance = target.resistance[c.type]
			if actor.damage.has(c.type):
				resistance -= actor.damage[c.type]
			resistance = get_resistance(resistance)
			c.value = int(c.value*(1.0-resistance))
			if resistance>=0.0:
				result.resisted += ceili(c.value * resistance)
			else:
				result.enhanced += floori(-c.value * resistance)
			
			result.damage += c.value
	result.critical /= maxf(total_damage_instances, 1.0)
	return result

func _calc_damage(skill: Dictionary, actor: Character, target: Character) -> Dictionary:
	var result := {
		"type":skill.damage_type,
		"damage": 0,
		"critical": 0,
		"absorbed": 0,
		"blocked_armour": 0,
		"blocked_willpower": 0,
		"resisted": 0,
		"penetrated": 0,
	}
	var base_attack := 0
	var resistance := 0.0
	var damage := 0
	if skill.damage_type in target.resistance:
		resistance += target.resistance[skill.damage_type]
	if skill.damage_type in actor.damage:
		resistance -= actor.damage[skill.damage_type]
	resistance = get_resistance(resistance)
	if typeof(skill.damage_stat) == TYPE_ARRAY:
		for k: String in skill.damage_stat:
			base_attack += actor.stats[k]
	else:
		base_attack += actor.stats[skill.damage_stat]
	if check_crit(actor, target, skill):
		base_attack = int(base_attack*CRITICAL_DAMAGE)
		result.critical = true
	for status in target.status:
		if !status.has("absorb_damage") || status.absorb_damage<=0.0:
			continue
		var absorbed := mini(base_attack, floori((status.absorb_damage as float) / maxf(1.0 - maxf(resistance, 0.0), 1e-3)))
		base_attack -= absorbed
		status.absorb_damage -= absorbed * (1.0 - maxf(resistance, 0.0))
		if status.absorb_damage<=0:
			status.duration = 0.0
			status.absorb_damage = 0
		result.absorbed += absorbed
	result.attack = base_attack
	if base_attack <= 0:
		return result
	if typeof(skill.attack_type)==TYPE_ARRAY:
		for k: String in skill.attack_type:
			if k=="magic" || k=="willpower":
				var blocked: int = max(target.attributes.willpower - actor.attributes.penetration, 0)
				damage += maxi(maxi(base_attack + actor.attributes[k] - blocked, 0) - base_attack, 0)
				result.blocked_willpower += blocked
			else:
				var blocked := maxi(target.attributes.armour - actor.attributes.penetration, 0)
				damage += maxi(maxi(base_attack + actor.attributes[k] - blocked, 0) - base_attack, 0)
				result.blocked_armour += blocked
		damage /= maxf(skill.attack_type.size(), 1.0)
		result.blocked_willpower /= maxf(skill.attack_type.size(), 1.0)
		result.blocked_armour /= maxf(skill.attack_type.size(), 1.0)
	else:
		if skill.attack_type == "magic" or skill.attack_type == "willpower":
			var blocked: int = maxi(target.attributes.willpower - actor.attributes.penetration, 0)
			damage = maxi(base_attack + actor.attributes[skill.attack_type] - maxi(target.attributes.willpower - actor.attributes.penetration, 0), 0)
			result.blocked_willpower = blocked
		else:
			var blocked := maxi(target.attributes.armour - actor.attributes.penetration, 0)
			damage = maxi(base_attack + actor.attributes[skill.attack_type] - maxi(target.attributes.armour - actor.attributes.penetration, 0), 0)
			result.blocked_armour = blocked
	if skill.has("armour_penetration"):
		damage = damage*(1.0-skill.armour_penetration) + base_attack*skill.armour_penetration
		result.penetrated = base_attack*skill.armour_penetration
	if skill.has("damage_scale"):
		damage *= skill.damage_scale
	damage = maxi(floori(damage * (1.0 - resistance)), 0)
	result.damage = damage
	result.resisted = ceili(damage * resistance)
	return result

func calc_heal(skill: Dictionary, actor: Character, heal_multiplier:= 1.0) -> Dictionary:
	var total_heal:= {}
	for combat_array: Array in skill.combat.healing:
		for c: Dictionary in combat_array:
			var dict := calc_combat_damage(c, actor, skill)
			if total_heal.has(dict.type):
				total_heal[dict.type] += heal_multiplier*dict.value
			else:
				total_heal[dict.type] = heal_multiplier*dict.value
	return total_heal

func _calc_heal(skill: Dictionary, actor: Character) -> int:
	var heal: int = actor.attributes[skill.healing_type] + actor.stats[skill.healing_stat]
	if "healing_scale" in skill:
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
