extends Node

const GUILDS = {
	"adventurer_guild":{
		"name":"adventurer_guild",
		"rank_names":{
			"type":"name",
			"tiers":[
				"copper","tin","bronze","iron","steel","chromium","silver","gold","titanium","platinum","admanite"
			],
		},
		"exp_gain":{
			"exploration":20,
			"kill":2,
			"quest":1,
		},
		"equipment_reward":["accessoiry"],
	},
	"fighter_guild":{
		"name":"fighter_guild",
		"rank_names":{
			"type":"list",
			"tiers":[
				"rookie","cannon_fodder","greenhorn","brawler","combatant","fighter","battler",
				"challenger","champion","legend",
			],
		},
		"required":{
			"abilities":["light_weapons","heavy_weapons","archery"]
		},
		"exp_gain":{
			"sell":1,
			"craft":2,
			"kill":3,
		},
		"equipment_reward":["heavy_weapon","chain_armour"],
	},
	"fight_club":{
		"name":"fight_club",
		"rank_names":{
			"type":"list",
			"tiers":[
				"rookie","cannon_fodder","greenhorn","brawler","combatant","fighter","battler",
				"challenger","champion","legend",
			],
		},
		"required":{
			"abilities":["light_weapons","heavy_weapons","brawling"]
		},
		"exp_gain":{
			"buy":2,
			"buff":1,
			"kill":3,
		},
		"equipment_reward":["heavy_weapon","chain_armour"],
	},
	"trapper_guild":{
		"name":"trapper_guild",
		"required":{
			"abilities":["archery","trapping"]
		},
		"exp_gain":{
			"trapping":5,
			"alchemy":5,
			"kill":2,
		},
		"equipment_reward":["ranged_weapon","leather_armour"],
	},
	"mage_guild":{
		"name":"mage_guild",
		"rank_names":{
			"type":"list",
			"tiers":[
				"amateur","apprentice","novice","student","PhD",
				"spell_caster","wizard","intructor","archmage",
			],
		},
		"required":{
			"abilities":["elemental_magic","nature_magic","defensive_magic","enchanting"]
		},
		"exp_gain":{
			"identify":30,
			"enchant":2,
			"kill":1,
			"buff":1,
		},
		"equipment_reward":["magic_weapon","cloth_armour"],
	},
	"summoner_guild":{
		"name":"summoner_guild",
		"required":{
			"abilities":["summoner","necromancy"]
		},
		"exp_gain":{
			"summon":2,
			"kill":1,
			"buff":1,
			"miss":1,
		},
		"equipment_reward":["magic_weapon","cloth_armour"],
	},
	"alchemist_guild":{
		"name":"alchemist_guild",
		"required":{
			"abilities":["alchemy","enchanting"]
		},
		"exp_gain":{
			"harvest":2,
			"enchant":5,
			"alchemy":5,
		},
		"equipment_reward":["magic_weapon","material"],
	},
	"war_caster_guild":{
		"name":"war_caster_guild",
		"required":{
			"abilities":["infuse_elemental","infuse_nature"]
		},
		"exp_gain":{
			"buy":1,
			"hit":1,
			"kill":3,
		},
		"equipment_reward":["light_weapon","heavy_weapon","magic_weapon"],
	},
	"celestial_church":{
		"name":"celestial_church",
		"rank_names":{
			"type":"list",
			"tiers":[
				"layman","apprentice","novice","preacher","cleric",
				"priest","temple_priest","saint","high_priest",
			],
		},
		"required":{
			"abilities":["celestial_magic","defensive_magic","healing"]
		},
		"exp_gain":{
			"identify":10,
			"enchant":2,
			"heal":5,
			"buff":1,
			"visit_church":60,
		},
		"equipment_reward":["magic_weapon","cloth_armour"],
	},
	"celestial_order":{
		"name":"celestial_order",
		"rank_names":{
			"type":"list",
			"tiers":[
				"amateur","apprentice","novice","preacher","cleric",
				"priest","inquisitor","saint","high_inquisitor",
			],
		},
		"required":{
			"abilities":["cleric"]
		},
		"exp_gain":{
			"heal":5,
			"kill":1,
			"buff":1,
			"visit_church":40,
		},
		"equipment_reward":["heavy_weapon","shield","chain_armour"],
	},
	"thief_guild":{
		"name":"thief_guild",
		"required":{
			"abilities":["light_weapons","dirty_fighting"]
		},
		"exp_gain":{
			"loot":2,
			"debuff":2,
			"attack":1,
		},
		"equipment_reward":["light_weapon","leather_armour"],
	},
	"assassin_guild":{
		"name":"assassin_guild",
		"required":{
			"abilities":["dirty_fighting"]
		},
		"exp_gain":{
			"debuff":2,
			"hit":1,
			"kill":2,
		},
		"equipment_reward":["light_weapon","leather_armour"],
	},
	"crafter_guild":{
		"name":"crafter_guild",
		"required":{
			"abilities":["weapon_smithing","armour_smithing","woodwork","tayloring","cooking"]
		},
		"exp_gain":{
			"loot":2,
			"cook":5,
			"craft":5,
		},
		"equipment_reward":["material","accessoiry"],
	},
}


func get_max_exp(lvl: int) -> int:
	return 400 + 200*lvl + 200*lvl*lvl

func get_rank(level: int, guild: String) -> String:
	if GUILDS[guild].has("rank_names"):
		var dict: Dictionary = GUILDS[guild].rank_names
		match dict.type:
			"name":
				var rank:= ""
				var digits: int = dict.tiers.size()
				for i in range(digits-1,-1,-1):
					var lvl: int = int(level/pow(dict.tiers.size()+1, i))%(dict.tiers.size()+1)
					if lvl<=0:
						continue
					rank += tr(dict.tiers[lvl-1].to_upper())
					if i>0:
						rank += "-"
				return rank + " " + tr("RANK")
			"list":
				var rank: String = tr(dict.tiers[min(level-1, dict.tiers.size()-1)].to_upper())
				if level>=dict.tiers.size():
					rank += " " + Skills.convert_to_roman_number(level+2-dict.tiers.size())
				return rank
	return "rank " + Skills.convert_to_roman_number(level)

func pick_guild(abilities: Array, excluded: Array) -> String:
	var valid:= []
	for guild in GUILDS.keys():
		if guild in excluded:
			continue
		if GUILDS[guild].required.has("abilities"):
			for k in GUILDS[guild].required.abilities:
				if k in abilities:
					valid.push_back(guild)
					break
		else:
			valid.push_back(guild)
	if valid.size()>0:
		return valid.pick_random()
	for guild in GUILDS.keys():
		if guild in excluded:
			continue
		valid.push_back(guild)
	if valid.size()>0:
		return valid.pick_random()
	return ""
