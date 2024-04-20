extends Node

const ATTRIBUTES = ["attack","magic","willpower","accuracy","armour","evasion","penetration","speed"]
const EQUIPMENT_COMPONENTS = {
	"knife":{
		"subtype":"melee",
		"attack":3,
		"penetration":4,
		"damage_type":"piercing",
		"material":["metal","bone"],
	},
	"blade":{
		"subtype":"melee",
		"attack":6,
		"damage_type":"cutting",
		"material":["metal","bone"],
	},
	"pole":{
		"subtype":"melee",
		"attack":4,
		"accuracy":2,
		"damage_type":"impact",
		"material":["wood","stone","metal"],
	},
	"whip":{
		"subtype":"melee",
		"attack":4,
		"accuracy":1,
		"penetration":2,
		"damage_type":"impact",
		"material":["leather"],
	},
	"chain_saw":{
		"subtype":"melee",
		"attack":4,
		"penetration":2,
		"damage_type":"cutting",
		"material":["metal"],
	},
	
	"hilt":{
		"attack":4,
		"accuracy":2,
		"material":["wood","stone","leather"],
	},
	"shaft":{
		"attack":2,
		"accuracy":2,
		"evasion":2,
		"material":["wood","stone","metal"],
	},
	
	"gem":{
		"subtype":"magic",
		"magic":6,
		"material":["gem","magical"],
	},
	"formula":{
		"subtype":"magic",
		"magic":4,
		"willpower":2,
		"material":["paper","leather"],
	},
	"orb":{
		"subtype":"magic",
		"magic":2,
		"willpower":4,
		"material":["gem","elemental"],
	},
	
	"string":{
		"subtype":"ranged",
		"attack":6,
		"damage_type":"piercing",
		"material":["leather"],
	},
	"bow":{
		"subtype":"ranged",
		"attack":5,
		"accuracy":1,
		"damage_type":"piercing",
		"material":["wood"],
	},
	"loader":{
		"subtype":"ranged",
		"attack":8,
		"accuracy":3,
		"speed":-1,
		"material":["wood","metal"],
	},
	"barrel":{
		"subtype":"ranged",
		"attack":4,
		"accuracy":2,
		"damage_type":"impact",
		"material":["metal","stone"],
	},
	
	"cloth_armour":{
		"subtype":"light",
		"armour":1,
		"evasion":3,
		"mana":10,
		"material":["cloth"],
	},
	"leather_armour":{
		"subtype":"medium",
		"armour":3,
		"accuracy":1,
		"stamina":10,
		"material":["leather"],
	},
	"light_armour":{
		"subtype":"medium",
		"armour":4,
		"accuracy":1,
		"evasion":1,
		"material":["wood","paper"],
	},
	"chain_armour":{
		"subtype":"heavy",
		"armour":6,
		"accuracy":-2,
		"evasion":-2,
		"health":10,
		"stamina":10,
		"material":["metal"],
	},
	"plate_armour":{
		"subtype":"heavy",
		"armour":9,
		"accuracy":-2,
		"evasion":-2,
		"speed":-1,
		"health":15,
		"material":["metal"],
	},
	
	"rope_joints":{
		"subtype":"light",
		"magic":1,
		"willpower":1,
		"accuracy":2,
		"evasion":2,
		"material":["cloth"],
	},
	"leather_joints":{
		"subtype":"medium",
		"accuracy":3,
		"evasion":3,
		"material":["leather"],
	},
	"metal_joints":{
		"subtype":"heavy",
		"attack":1,
		"armour":3,
		"accuracy":1,
		"evasion":1,
		"material":["metal"],
	},
	
	"magical_coating":{
		"magic":3,
		"willpower":3,
		"material":["magical"],
	},
	"paint_coating":{
		"armour":1,
		"evasion":3,
		"accuracy":2,
		"material":["alchemy"],
	},
	"metal_coating":{
		"armour":4,
		"attack":2,
		"damage_type":"impact",
		"material":["metal"],
	},
	"glass_coating":{
		"accuracy":3,
		"evasion":3,
		"material":["sand"],
	},
	
	"rope_chain":{
		"magic":2,
		"stamina":10,
		"mana":10,
		"material":["cloth"],
	},
	"metal_chain":{
		"armour":2,
		"stamina":10,
		"mana":10,
		"material":["metal"],
	},
	"leather_strip":{
		"accuracy":2,
		"evasion":2,
		"health":10,
		"material":["leather"],
	},
	"metal_strip":{
		"attack":2,
		"accuracy":2,
		"evasion":2,
		"material":["metal"],
	},
	
}
const MATERIALS = {
	"slime":{
		"name":["{name_prefix} slime"],
		"tags":["liquid"],
		"price":5,
	},
	"condensate":{
		"name":["{base_name} condensate", "{name_prefix} condensate"],
		"tags":["liquid","elemental"],
		"add":{
			"willpower":0.5,
		},
		"price":10,
	},
	"residue":{
		"name":["{base_name} residue", "{name_prefix} residue"],
		"tags":["liquid","magical"],
		"add":{
			"magic":0.5,
		},
		"price":10,
	},
	"resin":{
		"name":["{name_prefix} resin"],
		"quality":1.1,
		"tags":["crafting","magical"],
		"add":{
			"magic":0.5,
		},
		"price":15,
	},
	"plasma":{
		"name":["{base_name} plasma", "{name_prefix} plasma"],
		"quality":1.1,
		"tags":["liquid","elemental"],
		"add":{
			"willpower":0.5,
		},
		"price":15,
	},
	"magic_salt":{
		"name":["{base_name} salt", "{name_prefix} salt"],
		"quality":1.1,
		"tags":["magical","elemental","cooking"],
		"add":{
			"magic":0.5,
		},
		"price":15,
	},
	"dust":{
		"name":["{base_name} dust"],
		"tags":["magical"],
		"add":{
			"magic":0.5,
		},
		"price":10,
	},
	"oil":{
		"name":["{base_name} oil", "{name_prefix} oil"],
		"tags":["liquid","elemental"],
		"add":{
			"attack":0.25,
			"magic":0.25,
		},
		"price":10,
	},
	"herb":{
		"name":["{base_name} herb"],
		"tags":["alchemy","plant","healing"],
		"add":{
			"health":2.5,
		},
		"price":10,
	},
	"venom":{
		"name":["{base_name} venom"],
		"quality":1.1,
		"tags":["toxic","alchemy"],
		"add":{
			"stamina":1.5,
			"mana":1.5,
		},
		"price":15,
	},
	"mold":{
		"name":["{base_name} mold"],
		"tags":["toxic","alchemy"],
		"add":{
			"health":2.5,
		},
		"price":10,
	},
	"flower":{
		"name":["{base_name} flower"],
		"tags":["alchemy","healing"],
		"add":{
			"health":2.5,
		},
		"price":10,
	},
	"moss":{
		"name":["{base_name} moss"],
		"quality":1.1,
		"tags":["alchemy","healing","toxic"],
		"add":{
			"stamina":1.5,
			"mana":1.5,
		},
		"price":15,
	},
	"leaf":{
		"name":["{base_name} leaf"],
		"tags":["alchemy","plant","cooking"],
		"add":{
			"health":2.5,
		},
		"price":10,
	},
	"carrot":{
		"name":["{base_name} carrot"],
		"tags":["alchemy","plant","cooking"],
		"add":{
			"health":2.5,
		},
		"price":10,
	},
	"root":{
		"name":["{base_name} root"],
		"quality":1.1,
		"tags":["alchemy","plant","cooking"],
		"add":{
			"health":2.5,
		},
		"price":15,
	},
	"mushroom":{
		"name":["{base_name} mushroom"],
		"quality":1.1,
		"tags":["cooking","alchemy","poison"],
		"add":{
			"health":2.5,
		},
		"price":15,
	},
	"algae":{
		"name":["{base_name} algae"],
		"quality":1.1,
		"tags":["cooking","plant"],
		"price":15,
	},
	"plankton":{
		"name":["{base_name} plankton"],
		"quality":1.1,
		"tags":["cooking","alchemy"],
		"add":{
			"health":2.5,
		},
		"price":15,
	},
	"spice":{
		"name":["{base_name} spice"],
		"quality":1.1,
		"tags":["alchemy","cooking"],
		"add":{
			"health":2.5,
		},
		"price":15,
	},
	"fruit":{
		"name":["{base_name} fruit"],
		"quality":1.1,
		"tags":["cooking","plant"],
		"price":15,
	},
	"berry":{
		"name":["{base_name} berry"],
		"quality":1.1,
		"tags":["alchemy","cooking","plant"],
		"add":{
			"health":2.5,
		},
		"price":15,
	},
	"cabbage":{
		"name":["{base_name} cabbage"],
		"tags":["cooking","plant"],
		"price":10,
	},
	"bean":{
		"name":["{base_name} bean"],
		"quality":1.1,
		"tags":["cooking"],
		"price":15,
	},
	"pebble":{
		"name":["{base_name} pebble"],
		"tags":["stone"],
		"add":{
			"armour":0.5,
		},
		"price":10,
	},
	"stone":{
		"name":["{base_name} stone", "{base_name} rock"],
		"quality":1.1,
		"tags":["stone"],
		"add":{
			"armour":0.5,
		},
		"price":15,
	},
	"sand":{
		"name":["{base_name} sand"],
		"tags":["sand"],
		"price":10,
	},
	"glass":{
		"name":["{base_name} glass"],
		"tags":["glass"],
		"add":{
			"penetration":0.75,
		},
		"price":10,
	},
	"gem":{
		"name":["{base_name} gem", "{base_name} crystal"],
		"tags":["gem"],
		"add":{
			"magic":0.5,
		},
		"price":10,
	},
	"jewel":{
		"name":["{base_name} jewel", "{base_name} gem stone"],
		"quality":1.1,
		"tags":["gem"],
		"add":{
			"magic":0.5,
		},
		"price":10,
	},
	"wood":{
		"name":["{base_name} wood"],
		"tags":["wood"],
		"add":{
			"accuracy":0.5,
		},
		"price":10,
	},
	"plank":{
		"name":["{base_name} plank"],
		"quality":1.1,
		"tags":["wood"],
		"add":{
			"accuracy":0.5,
		},
		"price":15,
	},
	"ore":{
		"name":["{base_name} ore"],
		"tags":["metal"],
		"add":{
			"attack":0.5,
		},
		"price":10,
	},
	"ingot":{
		"name":["{base_name} ingot"],
		"quality":1.1,
		"tags":["metal"],
		"add":{
			"attack":0.5,
		},
		"price":15,
	},
	"bar":{
		"name":["{base_name} bar"],
		"quality":1.1,
		"tags":["metal"],
		"add":{
			"attack":0.5,
		},
		"price":15,
	},
	"cog":{
		"name":["{base_name} cog"],
		"quality":1.1,
		"tags":["metal"],
		"add":{
			"attack":0.5,
		},
		"price":15,
	},
	"scrap":{
		"name":["{base_name} scrap"],
		"quality":0.9,
		"tags":["metal","stone"],
		"price":5,
	},
	"coin":{
		"name":["{base_name} coin"],
		"tags":["metal"],
		"add":{
			"armour":0.5,
		},
		"price":10,
	},
	"paper":{
		"name":["{base_name} paper"],
		"tags":["paper"],
		"add":{
			"willpower":0.5,
		},
		"price":10,
	},
	"parchement":{
		"name":["{base_name} parchement"],
		"veggie_name":["{base_name} paper"],
		"tags":["paper"],
		"add":{
			"magic":0.5,
		},
		"price":10,
	},
	"skin":{
		"name":["{base_name} skin"],
		"veggie_name":["{base_name} polymere"],
		"tags":["leather"],
		"add":{
			"accuracy":0.5,
		},
		"price":10,
	},
	"leather":{
		"name":["{base_name} leather"],
		"veggie_name":["{base_name} synthetic leather"],
		"quality":1.1,
		"tags":["leather"],
		"add":{
			"accuracy":0.5,
		},
		"price":15,
	},
	"hide":{
		"name":["{base_name} hide"],
		"veggie_name":["{base_name} wool"],
		"quality":1.1,
		"tags":["leather","cloth"],
		"add":{
			"accuracy":0.5,
		},
		"price":15,
	},
	"synth_skin":{
		"name":["{base_name} synth skin"],
		"quality":1.1,
		"tags":["leather"],
		"add":{
			"accuracy":0.5,
		},
		"price":15,
	},
	"wing":{
		"name":["{base_name} wing"],
		"veggie_name":["{base_name} foil"],
		"tags":["leather","alchemy"],
		"add":{
			"accuracy":0.5,
		},
		"price":10,
	},
	"cotton":{
		"name":["{base_name} cotton"],
		"tags":["cloth"],
		"add":{
			"evasion":0.5,
		},
		"price":10,
	},
	"cloth":{
		"name":["{base_name} cloth"],
		"quality":1.1,
		"tags":["cloth"],
		"add":{
			"evasion":0.5,
		},
		"price":15,
	},
	"silk":{
		"name":["{base_name} silk"],
		"quality":1.1,
		"tags":["cloth"],
		"add":{
			"evasion":0.5,
		},
		"price":15,
	},
	"foil":{
		"name":["{base_name} foil"],
		"tags":["cloth"],
		"add":{
			"evasion":0.5,
		},
		"price":10,
	},
	"tissue":{
		"name":["{base_name} tissue"],
		"quality":1.1,
		"tags":["cloth"],
		"add":{
			"evasion":0.5,
		},
		"price":15,
	},
	"wrapping":{
		"name":["{base_name} wrapping"],
		"quality":1.1,
		"tags":["cloth"],
		"add":{
			"evasion":0.5,
		},
		"price":10,
	},
	"fur":{
		"name":["{base_name} fur"],
		"veggie_name":["{base_name} polyester"],
		"tags":["cloth"],
		"add":{
			"evasion":0.5,
		},
		"price":10,
	},
	"scale":{
		"name":["{base_name} scale"],
		"veggie_name":["{base_name} plate"],
		"quality":1.1,
		"tags":["cloth","leather"],
		"add":{
			"armour":0.5,
		},
		"price":15,
	},
	"feather":{
		"name":["{base_name} feather"],
		"tags":["cloth"],
		"add":{
			"evasion":0.5,
		},
		"price":10,
	},
	"hair":{
		"name":["{base_name} hair"],
		"tags":["cloth"],
		"add":{
			"evasion":0.5,
		},
		"price":10,
	},
	"tail":{
		"name":["{base_name} tail"],
		"veggie_name":["{base_name} cloth"],
		"quality":1.1,
		"tags":["cloth"],
		"add":{
			"evasion":0.5,
		},
		"price":15,
	},
	"tooth":{
		"name":["{base_name} tooth"],
		"veggie_name":["{base_name} ceramic"],
		"tags":["bone"],
		"add":{
			"penetration":0.75,
		},
		"price":10,
	},
	"nail":{
		"name":["{base_name} nail"],
		"veggie_name":["{base_name} iron nail"],
		"tags":["bone"],
		"add":{
			"penetration":0.75,
		},
		"price":10,
	},
	"claw":{
		"name":["{base_name} claw"],
		"veggie_name":["{base_name} ceramic"],
		"tags":["bone"],
		"add":{
			"penetration":0.75,
		},
		"price":10,
	},
	"shell":{
		"name":["{base_name} shell"],
		"veggie_name":["{base_name} lime"],
		"quality":1.1,
		"tags":["stone","bone"],
		"add":{
			"armour":0.5,
		},
		"price":15,
	},
	"fang":{
		"name":["{base_name} fang"],
		"veggie_name":["{base_name} ceramic"],
		"quality":1.1,
		"tags":["bone"],
		"add":{
			"penetration":0.75,
		},
		"price":15,
	},
	"horn":{
		"name":["{base_name} horn"],
		"veggie_name":["{base_name} ceramic"],
		"quality":1.1,
		"tags":["bone"],
		"add":{
			"penetration":0.75,
		},
		"price":15,
	},
	"bone":{
		"name":["{base_name} bone"],
		"veggie_name":["{base_name} ceramic"],
		"quality":1.1,
		"tags":["bone"],
		"add":{
			"penetration":0.75,
		},
		"price":15,
	},
	"skull":{
		"name":["{base_name} skull"],
		"veggie_name":["{base_name} casing"],
		"quality":1.1,
		"tags":["bone"],
		"add":{
			"armour":0.5,
		},
		"price":15,
	},
	"meat":{
		"name":["{base_name} meat"],
		"veggie_name":["{base_name} tofu"],
		"tags":["cooking","meat"],
		"price":10,
	},
	"tongue":{
		"name":["{base_name} tongue"],
		"veggie_name":["{base_name} B12 pill"],
		"tags":["alchemy","cooking","meat"],
		"add":{
			"health":2.5,
		},
		"price":10,
	},
	"pincer":{
		"name":["{base_name} pincer"],
		"veggie_name":["{base_name} pea"],
		"quality":1.1,
		"tags":["alchemy","cooking","meat"],
		"add":{
			"health":2.5,
		},
		"price":15,
	},
	"insistine":{
		"name":["{base_name} insistine"],
		"veggie_name":["{base_name} soy"],
		"tags":["cooking","alchemy","meat"],
		"add":{
			"stamina":1.5,
			"mana":1.5,
		},
		"price":10,
	},
	"testicle":{
		"name":["{base_name} testicle"],
		"veggie_name":["{base_name} nut"],
		"tags":["cooking","alchemy","meat"],
		"add":{
			"stamina":1.5,
			"mana":1.5,
		},
		"price":10,
	},
	"ear":{
		"name":["{base_name} ear"],
		"veggie_name":["{base_name} poison"],
		"tags":["alchemy","poison"],
		"add":{
			"stamina":1.5,
			"mana":1.5,
		},
		"price":10,
	},
	"eye_ball":{
		"name":["{base_name} eye ball"],
		"veggie_name":["{base_name} marble"],
		"quality":1.1,
		"tags":["alchemy","gem"],
		"add":{
			"willpower":0.5,
		},
		"price":15,
	},
	"kidney":{
		"name":["{base_name} kidney"],
		"veggie_name":["{base_name} kidney bean"],
		"quality":1.1,
		"tags":["cooking","meat"],
		"price":15,
	},
	"heart":{
		"name":["{base_name} heart"],
		"veggie_name":["{base_name} heartstone"],
		"quality":1.1,
		"tags":["alchemy","meat","gem"],
		"add":{
			"willpower":0.5,
		},
		"price":15,
	},
	"battery":{
		"name":["{base_name} battery"],
		"quality":1.1,
		"tags":["alchemy"],
		"add":{
			"stamina":1.5,
			"mana":1.5,
		},
		"price":15,
	},
	"processing_unit":{
		"name":["{base_name} processing unit"],
		"quality":1.1,
		"tags":["gem"],
		"add":{
			"magic":0.5,
		},
		"price":15,
	},
	"wires":{
		"name":["{base_name} wires"],
		"tags":["cloth"],
		"quality":1.1,
		"add":{
			"critical":0.6,
		},
		"price":15,
	},
	"ram_module":{
		"name":["{base_name} RAM module"],
		"quality":1.1,
		"tags":["gem"],
		"add":{
			"willpower":0.5,
		},
		"price":15,
	},
	
	"soul_splinter":{
		"name":["{soul_prefix} soul splinter", "soul splinter of {base_name}", "{soul_prefix} soul splinter of {base_name}"],
		"quality":0.6,
		"tags":["soul"],
		"price":2,
	},
	"soul_shard":{
		"name":["{soul_prefix} soul shard", "soul shard of {base_name}", "{soul_prefix} soul shard of {base_name}"],
		"quality":0.8,
		"tags":["soul"],
		"price":5,
	},
	"soul_stone":{
		"name":["{soul_prefix} soul stone", "soul stone of {base_name}", "{soul_prefix} soul stone of {base_name}"],
		"quality":1.0,
		"tags":["soul"],
		"price":10,
	},
	"soul_gem":{
		"name":["{soul_prefix} soul gem", "soul gem of {base_name}", "{soul_prefix} soul gem of {base_name}"],
		"quality":1.2,
		"tags":["soul"],
		"price":20,
	},
	"soul_jewel":{
		"name":["{soul_prefix} soul jewel", "soul jewel of {base_name}", "{soul_prefix} soul jewel of {base_name}"],
		"quality":1.4,
		"tags":["soul"],
		"price":30,
	},
	"soul_orb":{
		"name":["{soul_prefix} soul orb", "soul orb of {base_name}", "{soul_prefix} soul orb of {base_name}"],
		"quality":1.6,
		"tags":["soul"],
		"price":45,
	},
	
	"empty_soul_stone":{
		"name":["empty soul stone"],
		"quality":1.0,
		"tags":["cage"],
		"price":10,
	},
}
const EQUIPMENT_RECIPES = {
	"dagger":{
		"type":"weapon",
		"components":["knife","hilt"],
	},
	"sword":{
		"type":"weapon",
		"components":["blade","hilt"],
	},
	"axe":{
		"type":"weapon",
		"components":["blade","shaft"],
	},
	"mace":{
		"type":"weapon",
		"components":["metal_coating","hilt"],
	},
	"whip":{
		"type":"weapon",
		"components":["whip","shaft"],
	},
	"chain_saw":{
		"type":"weapon",
		"components":["chain_saw","hilt"],
	},
	"buckler":{
		"type":"weapon",
		"subtype":"shield",
		"components":["light_armour","shaft"],
	},
	"kite_shield":{
		"type":"weapon",
		"subtype":"shield",
		"components":["chain_armour","shaft"],
	},
	"tower_shield":{
		"type":"weapon",
		"subtype":"shield",
		"components":["plate_armour","shaft"],
	},
	
	"sling":{
		"type":"weapon",
		"components":["string","shaft"],
	},
	"pistol":{
		"type":"weapon",
		"components":["barrel","hilt"],
	},
	
	"tome":{
		"type":"weapon",
		"components":["formula","gem"],
	},
	"amplifier":{
		"type":"weapon",
		"components":["magical_coating","gem"],
	},
	"orb":{
		"type":"weapon",
		"components":["magical_coating","orb"],
	},
	"spellblade":{
		"type":"weapon",
		"components":["blade","gem"],
	},
	
	"greatsword":{
		"type":"weapon",
		"2h":true,
		"components":["blade","blade","knife","hilt"],
	},
	"greatmaul":{
		"type":"weapon",
		"2h":true,
		"components":["metal_coating","metal_coating","pole","hilt"],
	},
	"battleaxe":{
		"type":"weapon",
		"2h":true,
		"components":["blade","blade","pole","shaft"],
	},
	"spear":{
		"type":"weapon",
		"2h":true,
		"components":["knife","pole","pole","shaft"],
	},
	"scythe":{
		"type":"weapon",
		"2h":true,
		"components":["blade","pole","pole","hilt"],
	},
	"morningstar":{
		"type":"weapon",
		"2h":true,
		"components":["metal_coating","whip","whip","shaft"],
	},
	
	"bow":{
		"type":"weapon",
		"2h":true,
		"components":["string","bow","bow","shaft"],
	},
	"crossbow":{
		"type":"weapon",
		"2h":true,
		"components":["string","bow","loader","shaft"],
	},
	"blunderbuss":{
		"type":"weapon",
		"2h":true,
		"components":["barrel","barrel","loader","hilt"],
	},
	"gun_blade":{
		"type":"weapon",
		"2h":true,
		"components":["knife","barrel","loader","shaft"],
	},
	
	"quarterstaff":{
		"type":"weapon",
		"2h":true,
		"components":["gem","pole","pole","shaft"],
	},
	"magestaff":{
		"type":"weapon",
		"2h":true,
		"components":["gem","orb","shaft","shaft"],
	},
	
	"cloth_shirt":{
		"type":"torso",
		"name":"shirt",
		"components":["cloth_armour","cloth_armour","rope_joints","magical_coating"],
	},
	"leather_chest":{
		"type":"torso",
		"components":["leather_armour","leather_armour","leather_joints","paint_coating"],
	},
	"chain_cuirass":{
		"type":"torso",
		"components":["chain_armour","chain_armour","leather_joints","metal_coating"],
	},
	"plate_cuirass":{
		"type":"torso",
		"components":["plate_armour","plate_armour","metal_joints","metal_coating"],
	},
	
	"cloth_pants":{
		"type":"legs",
		"name":"pants",
		"components":["cloth_armour","cloth_armour","magical_coating"],
	},
	"leather_pants":{
		"type":"legs",
		"name":"pants",
		"components":["leather_armour","leather_joints","paint_coating"],
	},
	"chain_greaves":{
		"type":"legs",
		"components":["chain_armour","chain_armour","metal_coating"],
	},
	"plate_greaves":{
		"type":"legs",
		"components":["plate_armour","metal_joints","metal_coating"],
	},
	"panties":{
		"type":"legs",
		"components":["cloth_armour","rope_joints","magical_coating"],
	},
	
	"cloth_hat":{
		"type":"head",
		"name":"hat",
		"components":["cloth_armour","magical_coating"],
	},
	"leather_hat":{
		"type":"head",
		"name":"hat",
		"components":["leather_armour","paint_coating"],
	},
	"chain_coif":{
		"type":"head",
		"components":["chain_armour","metal_coating"],
	},
	"plate_helm":{
		"type":"head",
		"components":["metal_joints","metal_coating"],
	},
	"glasses":{
		"type":"head",
		"components":["metal_coating","glass_coating"],
	},
	
	"cloth_sandals":{
		"type":"feet",
		"name":"sandals",
		"components":["cloth_armour","rope_joints"],
	},
	"leather_boots":{
		"type":"feet",
		"name":"boots",
		"components":["leather_armour","leather_joints"],
	},
	"chain_boots":{
		"type":"feet",
		"components":["chain_armour","metal_joints"],
	},
	"plate_boots":{
		"type":"feet",
		"components":["metal_joints","metal_coating"],
	},
	
	"cloth_sleeves":{
		"type":"hands",
		"name":"sleeves",
		"components":["cloth_armour","rope_joints"],
	},
	"leather_gloves":{
		"type":"hands",
		"name":"gloves",
		"components":["leather_armour","leather_joints"],
	},
	"chain_gauntlets":{
		"type":"hands",
		"components":["chain_armour","metal_joints"],
	},
	"plate_gauntlets":{
		"type":"hands",
		"components":["metal_joints","metal_coating"],
	},
	
	"rope_belt":{
		"type":"belt",
		"components":["cloth_armour","rope_joints"],
	},
	"leather_belt":{
		"type":"belt",
		"components":["leather_armour","leather_joints"],
	},
	"chain_belt":{
		"type":"belt",
		"components":["chain_armour","metal_joints"],
	},
	
	"magical_cape":{
		"type":"cape",
		"name":"cape",
		"components":["cloth_armour","magical_coating"],
	},
	"cloth_cape":{
		"type":"cape",
		"name":"cloak",
		"components":["cloth_armour","paint_coating"],
	},
	"metal_cape":{
		"type":"cape",
		"name":"cape",
		"components":["chain_armour","paint_coating"],
	},
	
	"rope_amulet":{
		"type":"amulet",
		"name":"amulet",
		"components":["rope_chain","gem"],
	},
	"metal_amulet":{
		"type":"amulet",
		"name":"amulet",
		"components":["metal_chain","orb"],
	},
	"leather_ring":{
		"type":"ring",
		"name":"ring",
		"components":["leather_strip"],
	},
	"metal_ring":{
		"type":"ring",
		"name":"ring",
		"components":["metal_strip"],
	},
	"metal_earring":{
		"type":"earring",
		"name":"earring",
		"components":["metal_strip"],
	},
	"gem_earring":{
		"type":"earring",
		"name":"earring",
		"components":["gem"],
	},
	"orb_earring":{
		"type":"earring",
		"name":"earring",
		"components":["orb"],
	},
	"metal_bracelet":{
		"type":"bracelet",
		"name":"bracelet",
		"components":["metal_chain"],
	},
	"wood_bracelet":{
		"type":"bracelet",
		"name":"bracelet",
		"components":["light_armour"],
	},
	
}
const EQUIPMENT_ATTRIBUTE_MULTIPLIER = {
	"weapon":1.5,
	"belt":0.75,
	"amulet":0.5,
	"ring":0.5,
	"earring":0.5,
	"bracelet":0.5,
}
const EQUIPMENT_TYPE_NAME = {
	"weapon":["weapon","tool"],
	"torso":["armour","clothing","chest","harness"],
	"legs":["pants","greaves"],
	"head":["hat","helmet"],
	"hands":["gloves"],
	"feet":["boots"],
	"belt":["belt"],
	"cape":["cape","cloak"],
	"amulet":["amulet","pendant"],
	"ring":["ring"],
	"earring":["earring"],
	"bracelet":["bracelet"],
}
const EQUIPMENT_SUBTYPE_NAME = {
	"melee":["basher","smasher","cutter","piercer"],
	"ranged":["thrower","shooter","projector","launcher"],
	"magic":["catalyst","amplifier","infuser","artifact"],
}
const ENCHANTMENTS = {
	"attack":{
		"slot":"minor",
		"prefix":["SHARP"],
		"attack":2,
		"price":20,
		"material_types":[["soul"]],
	},
	"magic":{
		"slot":"minor",
		"prefix":["ARCANE"],
		"magic":2,
		"price":20,
		"material_types":[["soul"]],
	},
	"accuracy":{
		"slot":"minor",
		"prefix":["ACCURATE"],
		"accuracy":2,
		"price":20,
		"material_types":[["soul"]],
	},
	"armour":{
		"slot":"minor",
		"prefix":["PROTECTIVE","ARMOURED"],
		"armour":2,
		"price":20,
		"material_types":[["soul"]],
	},
	"willpower":{
		"slot":"minor",
		"prefix":["DETERMINED","WISE"],
		"willpower":2,
		"price":20,
		"material_types":[["soul"]],
	},
	"evasion":{
		"slot":"minor",
		"prefix":["AGILE","DODGING"],
		"evasion":2,
		"price":20,
		"material_types":[["soul"]],
	},
	"penetration":{
		"slot":"minor",
		"prefix":["PIERCING","PENETRATING"],
		"penetration":3,
		"price":20,
		"material_types":[["soul"]],
	},
	"speed":{
		"slot":"minor",
		"prefix":["QUICK","FAST"],
		"speed":1,
		"price":20,
		"material_types":[["soul"]],
	},
	"health":{
		"slot":"minor",
		"prefix":["VITAL"],
		"health":20,
		"price":20,
		"material_types":[["soul"]],
	},
	"health_regen":{
		"slot":"minor",
		"prefix":["HEALING"],
		"health_regen":2,
		"price":20,
		"material_types":[["soul"]],
	},
	"stamina":{
		"slot":"minor",
		"prefix":["TENACIOUS"],
		"stamina":10,
		"price":20,
		"material_types":[["soul"]],
	},
	"stamina_regen":{
		"slot":"minor",
		"prefix":["REJUVENATING"],
		"stamina_regen":3,
		"price":20,
		"material_types":[["soul"]],
	},
	"mana":{
		"slot":"minor",
		"prefix":["MANABOUND"],
		"mana":10,
		"price":20,
		"material_types":[["soul"]],
	},
	"mana_regen":{
		"slot":"minor",
		"prefix":["REJUVENATING"],
		"mana_regen":3,
		"price":20,
		"material_types":[["soul"]],
	},
	"focus":{
		"slot":"minor",
		"prefix":["FOCUSED"],
		"focus":1,
		"price":20,
		"material_types":[["soul"]],
	},
	"elemental_resistance":{
		"slot":"greater",
		"suffix":["OF_ELEMENTAL_RESISTANCE"],
		"resistance":{
			"fire":0.04,
			"ice":0.04,
			"lightning":0.04,
		},
		"price":20,
		"material_types":[["soul"]],
	},
	"nature_resistance":{
		"slot":"greater",
		"suffix":["OF_NATURE_RESISTANCE"],
		"resistance":{
			"wind":0.04,
			"water":0.04,
			"earth":0.04,
			"poison":0.035,
			"acid":0.035,
		},
		"price":20,
		"material_types":[["soul"]],
	},
	"celestial_resistance":{
		"slot":"greater",
		"suffix":["OF_CELESTIAL_RESISTANCE"],
		"resistance":{
			"light":0.05,
			"darkness":0.05,
		},
		"price":20,
		"material_types":[["soul"]],
	},
	"physical_resistance":{
		"slot":"greater",
		"suffix":["OF_PHYSICAL_RESISTANCE"],
		"resistance":{
			"impact":0.035,
			"cutting":0.035,
			"piercing":0.035,
		},
		"price":20,
		"material_types":[["soul"]],
	},
	"elemental_damage":{
		"slot":"greater",
		"suffix":["OF_ELEMENTAL_MIGHT"],
		"damage":{
			"fire":0.04,
			"ice":0.04,
			"lightning":0.04,
		},
		"price":20,
		"material_types":[["soul"]],
	},
	"nature_damage":{
		"slot":"greater",
		"suffix":["OF_NATURE"],
		"damage":{
			"wind":0.04,
			"water":0.04,
			"earth":0.04,
			"poison":0.04,
			"acid":0.04,
		},
		"price":20,
		"material_types":[["soul"]],
	},
	"celestial_damage":{
		"slot":"greater",
		"suffix":["OF_TWILIGHT"],
		"damage":{
			"light":0.05,
			"darkness":0.05,
		},
		"price":20,
		"material_types":[["soul"]],
	},
	"physical_damage":{
		"slot":"greater",
		"suffix":["OF_WARMASTER"],
		"damage":{
			"impact":0.035,
			"cutting":0.035,
			"piercing":0.035,
		},
		"price":20,
		"material_types":[["soul"]],
	},
	"strength":{
		"slot":"greater",
		"suffix":["OF_STRENGTH"],
		"strength":1,
		"price":20,
		"material_types":[["soul"]],
	},
	"constitution":{
		"slot":"greater",
		"suffix":["OF_CONSTITUTION"],
		"constitution":1,
		"price":20,
		"material_types":[["soul"]],
	},
	"dexterity":{
		"slot":"greater",
		"suffix":["OF_DEXTERITY"],
		"dexterity":1,
		"price":20,
		"material_types":[["soul"]],
	},
	"cunning":{
		"slot":"greater",
		"suffix":["OF_CUNNING"],
		"cunning":1,
		"price":20,
		"material_types":[["soul"]],
	},
	"intelligence":{
		"slot":"greater",
		"suffix":["OF_INTELLIGENCE"],
		"intelligence":1,
		"price":20,
		"material_types":[["soul"]],
	},
	"wisdom":{
		"slot":"greater",
		"suffix":["OF_WISDOM"],
		"wisdom":1,
		"price":20,
		"material_types":[["soul"]],
	},
}
const POTIONS = {
	"healing_salve":{
		"name":"healing salve",
		"type":"potion",
		"effect":"health",
		"status":{
			"type":"buff",
			"name":"healing",
			"health_regen":500,
			"duration":10.0,
		},
		"price":10,
		"material_types":[["healing"]],
	},
	"healing_potion":{
		"name":"healing potion",
		"type":"potion",
		"effect":"health",
		"healing":75,
		"price":20,
		"material_types":[["healing"],["liquid","healing"]],
	},
	"bandage":{
		"name":"bandage",
		"type":"potion",
		"effect":"health",
		"status":{
			"type":"buff",
			"name":"healing",
			"health_regen":200,
			"health":20.0,
			"duration":20.0,
		},
		"price":10,
		"material_types":[["healing","cloth","leather"]],
	},
	"healing_infusion":{
		"name":"healing infusion",
		"type":"potion",
		"effect":"health",
		"healing":75,
		"price":20,
		"material_types":[["healing"],["liquid","healing"]],
	},
	"mana_salve":{
		"name":"mana salve",
		"type":"potion",
		"effect":"mana",
		"status":{
			"type":"buff",
			"name":"healing",
			"mana_regen":200,
			"duration":10.0,
		},
		"price":10,
		"material_types":[["magical"]],
	},
	"mana_potion":{
		"name":"mana potion",
		"type":"potion",
		"effect":"mana",
		"healing":75,
		"price":20,
		"material_types":[["magical"],["liquid","magical"]],
	},
	"stamina_salve":{
		"name":"stamina salve",
		"type":"potion",
		"effect":"stamina",
		"status":{
			"type":"buff",
			"name":"healing",
			"stamina_regen":200,
			"duration":10.0,
		},
		"price":10,
		"material_types":[["elemental"]],
	},
	"stamina_potion":{
		"name":"stamina potion",
		"type":"potion",
		"effect":"stamina",
		"healing":75,
		"price":20,
		"material_types":[["elemental"],["liquid","elemental"]],
	},
}
const FOOD = {
	"soup":{
		"name":"soup",
		"type":"food",
		"stamina":20,
		"status":{
			"type":"buff",
			"name":"regeneration",
			"health_regen":10,
			"duration":20*60,
		},
		"price":10,
		"material_types":[["cooking","liquid"]],
	},
	"salad":{
		"name":"salad",
		"type":"food",
		"stamina":20,
		"status":{
			"type":"buff",
			"name":"agility",
			"effect":["accuracy","evasion"],
			"effect_scale":3.0,
			"duration":20*60,
		},
		"price":10,
		"material_types":[["plant"]],
	},
	"sandwich":{
		"name":"sandwich",
		"type":"food",
		"stamina":40,
		"status":{
			"type":"buff",
			"name":"resilience",
			"effect":["armour","willpower"],
			"effect_scale":6.0,
			"duration":20*60,
		},
		"price":20,
		"material_types":[["cooking"],["plant","cooking"]],
	},
	"pizza":{
		"name":"pizza",
		"type":"food",
		"stamina":40,
		"status":{
			"type":"buff",
			"name":"vigor",
			"effect":["attack","magic"],
			"effect_scale":5.5,
			"duration":20*60,
		},
		"price":20,
		"material_types":[["cooking"],["cooking"]],
	},
	"curry":{
		"name":"curry",
		"type":"food",
		"stamina":40,
		"status":{
			"type":"buff",
			"name":"vigor",
			"effect":["attack","magic"],
			"effect_scale":5.5,
			"duration":20*60,
		},
		"price":20,
		"material_types":[["cooking"],["liquid","cooking"]],
	},
	"tea":{
		"name":"tea",
		"type":"food",
		"stamina":40,
		"status":{
			"type":"buff",
			"name":"regeneration",
			"health_regen":10,
			"duration":20*60,
		},
		"price":20,
		"material_types":[["healing"],["plant","healing"]],
	},
	"dessert":{
		"name":"dessert",
		"type":"food",
		"stamina":40,
		"status":{
			"type":"buff",
			"name":"joy",
			"effect":["willpower","accuracy"],
			"effect_scale":6.0,
			"duration":20*60,
		},
		"price":20,
		"material_types":[["cooking"],["cooking"]],
	},
	"pudding":{
		"name":"pudding",
		"type":"food",
		"stamina":40,
		"status":{
			"type":"buff",
			"name":"joy",
			"effect":["speed"],
			"effect_scale":1.0,
			"duration":10*60,
		},
		"price":20,
		"material_types":[["cooking"],["liquid","cooking"]],
	},
	"pot":{
		"name":"pot",
		"type":"food",
		"stamina":40,
		"status":{
			"type":"buff",
			"name":"satisfaction",
			"effect":["armour","evasion"],
			"effect_scale":6.0,
			"duration":20*60,
		},
		"price":20,
		"material_types":[["cooking"],["cooking"]],
	},
	"mayonnaise":{
		"name":"mayonnaise",
		"type":"food",
		"stamina":30,
		"status":{
			"type":"buff",
			"name":"mayonnaise",
			"mana_regen":8,
			"stamina_regen":8,
			"duration":20*60,
		},
		"price":15,
		"material_types":[["cooking","liquid"]],
	},
}
const SPECIAL_ITEM_TYPE_NAME = {
	"dagger":{
		"knife":{
			"description":[
				"They won't see it coming.",
			],
			"adjective":[
				"small","curved"
			],
			"feature":[
				"knife","blade",
			],
		},
		"scalpel":{
			"description":[
				"Cuts like {adjective} razors through flesh and {theme} alike.",
			],
			"adjective":[
				"sharp"
			],
			"feature":[
				"knife","blade",
			],
		},
		"shard":{
			"material":[
				"diamond","titanium",
			],
			"feature":[
				"edges"
			],
		},
	},
	"rapier":{
		"needle":{
			"theme":[
				"penetration",
			],
			"adjective":[
				"tiny",
			],
			"feature":[
				"tip","blade",
			],
		},
		"piercer":{
			"adjective":[
				"piercing","breaching",
			],
			"feature":[
				"blade","hilt",
			],
		},
	},
	"short_sword":{
		"blade":{
			"feature":[
				"blade","hilt",
			],
		},
		"razor":{
			"adjective":[
				"sharp",
			],
			"feature":[
				"razor",
			],
		},
	},
	"long_sword":{
		"edge":{
			"feature":[
				"blade","hilt",
			],
		},
		"cutlass":{
			"feature":[
				"blade","hilt",
			],
		},
	},
	"hand_axe":{
		"cleaver":{
			"feature":[
				"blade","haft",
			],
		},
	},
	"mace":{
		"stick":{},
		"club":{
			"adjective":[
				"crude",
			],
			"feature":[
				"haft",
			],
		},
		"morning star":{
			"feature":[
				"haft","ball",
			],
		}
	},
	"greatsword":{
		"cutter":{
			"adjective":[
				"sharp",
			],
			"feature":[
				"blade","hilt",
			],
		},
		"obliterator":{
			"adjective":[
				"violent",
			],
			"feature":[
				"blade","hilt",
			],
		},
	},
	"greatmaul":{
		"maul":{
			"feature":[
				"haft",
			],
		},
		"basher":{
			"feature":[
				"haft",
			],
		},
		"obliterator":{
			"adjective":[
				"violent",
			],
			"feature":[
				"haft",
			],
		}
	},
	"battleaxe":{
		"feller":{
			"feature":[
				"haft","blade",
			],
		},
		"waraxe":{
			"feature":[
				"haft","blade",
			],
		}
	},
	"spear":{
		"pole":{
			"feature":[
				"haft","shaft","tip",
			],
		},
		"lance":{
			"feature":[
				"haft","shaft","tip",
			],
		},
	},
	"staff":{
		"rod":{},
		"sceptre":{},
	},
	"tome":{
		"grimoire":{
			"feature":[
				"gem stone","cover",
			],
		},
		"spell book":{
			"feature":[
				"pages","cover",
			],
		},
	},
	"orb":{
		"heartstone":{
			"feature":[
				"gem stone",
			],
		},
		"shard":{
			"feature":[
				"gem stone",
			],
		},
		"eye":{
			"feature":[
				"gem stone",
			],
		},
	},
	"amplifier":{
		"aether core":{
			"description":[
				"Thick layers of pure aether swirl around the {adjective} {base_name}.",
			],
			"feature":[
				"gem stone",
			],
		},
	},
	
	"blowgun":{
		"dart launcher":{}
	},
	"pistol":{
		"blaster":{
			"feature":[
				"gun powder","barrel","magazine",
			],
		},
		"gun":{
			"feature":[
				"gun powder","barrel","magazine",
			],
		},
	},
	"bow":{
		"long bow":{
			"feature":[
				"string",
			],
		},
		"war bow":{
			"feature":[
				"string",
			],
		},
	},
	"crossbow":{
		"ballista":{
			"description":[
				"A {adjective} miniature siege weapon.",
				"Almost too large to carry but makes short work of {theme}.",
			],
			"adjective":[
				"huge",
			],
			"feature":[
				"string","loader",
			],
		},
		"arbalest":{
			"feature":[
				"string","loader",
			],
		},
	},
	"blunderbuss":{
		"rifle":{
			"adjective":[
				"swift","accurate",
			],
			"feature":[
				"gun powder","barrel",
			],
		},
		"shotgun":{
			"adjective":[
				"brutal",
			],
			"feature":[
				"gun powder","barrel",
			],
		},
		"cannon":{
			"description":[
				"Unparalleled fire power.",
			],
			"feature":[
				"gun powder","barrel",
			],
		},
	},
	
	"buckler":{
		"shield":{},
	},
	"kite_shield":{
		"protector":{},
		"guard":{},
	},
	
	"cloth_shirt":{
		"robe":{}
	},
	"leather_chest":{
		"skin":{},
		"hide":{}
	},
	"chain_cuirass":{
		"harness":{},
		"scales":{},
		"scale male":{}
	},
	"plate_cuirass":{
		"harness":{},
		"cage":{},
	},
	
	"leather_gloves":{
		"fists":{},
		"wraps":{
			"feature":[
				"wrapping",
			],
		},
		"grip":{}
	},
	"chain_gauntlets":{
		"fists":{},
		"grip":{},
	},
	
	"cloth_hat":{
		"cap":{}
	},
	"leather_hat":{
		"cap":{},
		"crown":{},
	},
	"chain_coif":{
		"crown":{},
	},
	"plate_helm":{
		"helm":{},
		"visor":{}
	},
	
	"cloth_sandals":{
		"walker":{},
	},
	"leather_boots":{
		"walker":{},
	},
	
	"belt":{
		"girdle":{},
	},
	
	"cape":{
		"cloak":{},
		"wrap":{},
		"mantle":{},
	},
	
	"amulet":{
		"pendant":{},
	},
}
const SPECIAL_ITEM_NAME = {
	"bane":{
		"description":[
			"The bane of {adjective} {theme}.",
			"{theme}'s {adjective} bane."
		],
		"theme":[
			"darkness","life","death",
		],
	},
	"voice":{
		"description":[
			"The voice of the {adjective} {theme}.",
			"You can hear the {adjective} voices of {theme}.",
		],
		"theme":[
			"silence","aether","fate",
		],
		"adjective":[
			"echoing","aethereal",
		],
	},
	"echo":{
		"description":[
			"The {adjective} voices of {theme} echo through your mind.",
		],
		"adjective":[
			"echoing","silent","reverbing",
		],
	},
	"memory":{
		"description":[
			"Said to hold memories of {adjective} {theme}.",
			"Holds {adjective} memories of the {theme}."
		],
		"theme":[
			"loss","happiness","serenity","calamity",
		],
		"adjective":[
			"long gone","eternal",
		],
	},
	"blessing":{
		"description":[
			"The blessing of the {adjective} {theme} shall be with you.",
			"{adjective} {base_name} bearing the blessing of the {theme}."
		],
		"theme":[
			"life","youth",
		],
		"adjective":[
			"holy","blessed",
		],
	},
	"curse":{
		"description":[
			"The curse of the {adjective} {theme} shall be upon you.",
			"{adjective} {base_name} bearing the curse of the {theme}."
		],
		"theme":[
			"death","fear",
		],
		"adjective":[
			"cursed","haunted",
		],
	},
	"mercy":{
		"description":[
			"Grants the {adjective} mercy of {theme}.",
			"The {adjective} {theme} is mercyful."
		],
		"theme":[
			"redemption","ignorance",
		],
		"adjective":[
			"soothing",
		],
	},
	"redemption":{
		"description":[
			"The {adjective} path to redemption is {theme}.",
		],
		"adjective":[
			"hard","long","short",
		],
	},
	"fury":{
		"description":[
			"Unleash the fury of the {adjective} {theme}.",
		],
		"theme":[
			"wilds","tribe","god",
		],
		"adjective":[
			"vengeful","wild","outrageous",
		],
	},
	"guardian":{
		"description":[
			"The {adjective} {theme} will guard your steps.",
			"Stand against the {adjective} {theme}!",
		],
		"theme":[
			"demon","archon","destiny",
		],
		"adjective":[
			"firm","fierce",
		],
	},
	"star":{
		"description":[
			"The star shines {adjective}ly.",
			"The stars shine as bright as the {adjective} {theme}."
		],
		"theme":[
			"stars","sky","light",
		],
		"adjective":[
			"bright",
		],
		"material":[
			"star silver","stellar iron",
		],
	},
	"sun":{
		"description":[
			"The sun glows {adjective}ly.",
			"The sun stands firm on the {adjective} sky."
		],
		"theme":[
			"sun","sky","light",
		],
		"adjective":[
			"bright",
		],
		"material":[
			"sun quarz","white steel",
		],
	},
	"moon":{
		"description":[
			"The moon glows {adjective}ly.",
			"The moon's {theme} is {adjective}."
		],
		"theme":[
			"moon","sky","light",
		],
		"adjective":[
			"bright",
		],
		"material":[
			"moon glass","nocturnal steel",
		],
	},
	"heart":{
		"description":[
			"The beating heart of the {adjective} {theme}.",
			"{adjective} {base_name} making a rhythmic beating sound."
		],
		"theme":[
			"beast","dragon",
		],
		"adjective":[
			"living",
		],
		"feature":[
			"blood",
		],
	},
	"vengeance":{
		"description":[
			"Vengeance shall be mine!",
			"Vengeaful {base_name} filled with ideas of {theme}."
		],
		"theme":[
			"vengeance","revenge",
		],
		"adjective":[
			"vengeful",
		],
	},
	"end":{
		"description":[
			"The end comes {adjective}ly.",
			"This is the {adjective} end of the {theme}."
		],
		"adjective":[
			"swift",
		],
	},
	"eye":{
		"description":[
			"Strangely looking {base_name} resembling a {adjective} eye.",
			"The eye of the {theme}.",
		],
		"theme":[
			"storm","tempest","beast",
		],
		"adjective":[
			"living",
		],
	},
	"malice":{
		"description":[
			"This {base_name} looks evil and {adjective}.",
			"An evil {base_name} lodging for the {adjective} {theme}."
		],
		"adjective":[
			"creepy","fearsome",
		],
	},
	"remnants":{
		"description":[
			"Heavily worn down {base_name} related to the {adjective} {theme}.",
			"Ancient {base_name} forged by the {adjective} {theme}."
		],
		"theme":[
			"apocalypse","doom","civilization","elders",
		],
		"adjective":[
			"ancient","long gone",
		],
		"feature":[
			"scars","dents",
		],
	},
	"saint":{
		"description":[
			"The saint's {adjective} {base_name}.",
			"A {adjective} artifact made of sacred {material}."
		],
		"theme":[
			"cleansing","light","radiance",
		],
		"adjective":[
			"cleansing","radiant","holy","sacred",
		],
		"material":[
			"celestial iron",
		],
	},
	"stopper":{
		"description":[
			"Stand against the {adjective} {theme}!",
			"The {adjective} {theme} ends here and now!"
		],
		"theme":[
			"blight","darkness","malice","doom","demons","fiend",
		],
		"adjective":[
			"vile","blighted","dark",
		],
	},
	"charm":{
		"description":[
			"{adjective} {material} charm.",
		],
		"adjective":[
			"simple","elegant","decorated",
		],
	},
	"core":{
		"description":[
			"The {material} core of the {adjective} {theme}.",
			"Said to be the {theme}'s {adjective} core."
		],
		"theme":[
			"machine","world","sun",
		],
		"feature":[
			"crystals","huge gems",
		],
	},
	"bindings":{
		"description":[
			"You feel connected to the {adjective} {theme}.",
		],
		"theme":[
			"power","force",
		],
		"feature":[
			"wrapping",
		],
	},
	"legacy":{
		"description":[
			"Long lost {adjective} {base_name} of the {theme}.",
			"{adjective} {base_name} said to be the legacy of the {theme}."
		],
		"theme":[
			"elders","ancients",
		],
		"adjective":[
			"ancient","legendary",
		],
	},
	"artifact":{
		"description":[
			"Powerful, {adjective} artifact {base_name} tied to the {theme}.",
			"Prized artifact of the {adjective} {theme}."
		],
		"adjective":[
			"ancient","legendary",
		],
	},
	"will":{
		"description":[
			"The {adjective} will of the {theme}.",
			"The {adjective} will of the {theme} cannot be stopped."
		],
		"adjective":[
			"unbending","deviant",
		],
	},
	"radiance":{
		"description":[
			"Brightly shining {base_name} of the {adjective} {theme}.",
		],
		"theme":[
			"radiance","priest",
		],
		"adjective":[
			"holy","sacred","divine",
		],
		"material":[
			"star silver", "holy topaz",
		],
	},
	"shaper":{
		"description":[
			"The world bends upon the {adjective} {theme}.",
			"Said to hold the power to reshape the {theme}."
		],
		"theme":[
			"space","time","will","god",
		],
		"adjective":[
			"unstoppable","almighty",
		],
	},
	"absolution":{
		"description":[
			"The {adjective} {theme} means nothing.",
			"Overcome the {adjective} {theme}.",
		],
		"theme":[
			"guilt","fear","curse","loss",
		],
		"adjective":[
			"ultimate","heavy",
		],
	},
	"fall":{
		"description":[
			"The end of the {adjective} {theme}.",
			"Descend into {theme}.",
		],
	},
}
const SPECIAL_WEAPON_NAME = {
	"weapon":{
		"adjective":[
			"reliable","unremarkable","battle proven",
		],
	},
	"tool":{
	},
	"deathbringer":{
		"description":[
			"Brutal {base_name} of the {adjective} {theme}.",
			"Brings {theme} and death upon your foes.",
		],
		"theme":[
			"death","destruction","obliteration","doom"
		],
		"adjective":[
			"deadly","lethal",
		],
	},
	"destroyer":{
		"description":[
			"The {adjective} power of the {theme} lies in your hands.",
		],
		"theme":[
			"death","destruction","obliteration","doom"
		],
		"adjective":[
			"deadly","lethal",
		],
	},
	"instrument":{
		"description":[
			"{material} {base_name} that looks more like an instrument rather than a weapon.",
			"The {adjective} weapon of the {theme}.",
		],
		"theme":[
			"melody","destruction",
		],
		"adjective":[
			"melodic","rhythmic",
		],
		"feature":[
			"strings",
		],
	},
	"hunter":{
		"description":[
			"Relentless {base_name}, hunter of the {adjective} {theme}.",
			"The relentless pursuit of the {adjective} {theme} goes on."
		],
		"theme":[
			"fiend","traitor",
		],
	},
	"pain":{
		"description":[
			"The {base_name} conveys the pain of the {adjective} {theme}.",
		],
		"theme":[
			"death","agony",
		],
		"adjective":[
			"painful","terrible",
		],
	},
	"apocalypse":{
		"description":[
			"The {adjective} {theme} will bring destruction.",
			"Unleash the power of the {adjective} {theme} upon the world.",
		],
		"theme":[
			"doom","demons","dragons",
		],
		"adjective":[
			"ultimate","overpowered",
		],
	},
	"rose":{
		"description":[
			"Beautiful but sharp as {theme}.",
			"An elegant {adjective} weapon made of {material}.",
		],
		"theme":[
			"razors","roses",
		],
		"adjective":[
			"red","crimson","thorny","blooming","flowering",
		],
		"material":[
			"amber","ruby","rose quarz","crimson steel","bloodstained iron","corrundum",
		],
		"feature":[
			"thorns",
		],
	},
	"flower":{
		"description":[
			"Elegant {base_name} of the {adjective} {theme}.",
			"Beautiful {base_name} that brings {adjective} {theme}.",
		],
		"adjective":[
			"colorful","thorny","blooming","flowering",
		],
		"material":[
			"amber","emerald","ruby","saphire",
		],
	},
	"thorn":{
		"description":[
			"Sharp and {adjective}.",
			"Thorny {base_name} made of {adjective} {material}."
		],
		"material":[
			"wood","titanium",
		],
		"feature":[
			"thorns",
		],
	},
	"basher":{
		"description":[
			"Brutal {base_name} of the {adjective} {theme}.",
		],
		"theme":[
			"death","destruction","obliteration","doom"
		],
		"adjective":[
			"deadly","lethal",
		],
	},
	"smasher":{
		"description":[
			"Smash your foes with the {adjective} power of the {theme}.",
		],
		"theme":[
			"death","destruction","obliteration","doom"
		],
		"adjective":[
			"deadly","lethal",
		],
	},
	"crusher":{
		"description":[
			"Brutal {material} {base_name}, crusher of the {adjective} {theme}.",
		],
		"theme":[
			"death","destruction","obliteration","doom",
		],
		"adjective":[
			"deadly","lethal","crushing",
		],
	},
	"cutter":{
		"description":[
			"Sharp {base_name} said to be able to cut through the {adjective} {theme}.",
		],
		"theme":[
			"death","destruction","obliteration","doom"
		],
		"adjective":[
			"deadly","lethal",
		],
	},
	"projector":{
		"description":[
			"Project the {adjective} {theme} upon your foes.",
		],
		"theme":[
			"death","destruction","doom","disintegration","torment",
		],
		"adjective":[
			"virtual","mental",
		],
		"feature":[
			"crystals","gems",
		],
	},
	"inducer":{
		"description":[
			"{adjective} {theme} inducer.",
			"WARNING: may induces {theme}."
		],
		"theme":[
			"death","destruction","doom","disintegration",
		],
		"adjective":[
			"swift","quick",
		],
		"feature":[
			"crystals","gems",
		],
	},
	"piercer":{
		"description":[
			"Said to pierce through the {theme} itself.",
		],
		"theme":[
			"heaven","hell","soul","world",
		],
		"adjective":[
			"piercing","penetrating",
		],
		"material":[
			"titanium","solar steel",
		],
	},
	"fury":{
		"description":[
			"The {adjective} fury of the {theme}.",
		],
		"theme":[
			"death","doomed","lost","fallen",
		],
		"adjective":[
			"wild","outrageous",
		],
	},
	"driver":{
		"description":[
			"Drive the {adjective} {base_name} through your foe's ranks.",
		],
		"theme":[
			"death","destruction","doom",
		],
		"adjective":[
			"deadly","lethal",
		],
	},
}
const SPECIAL_ARMOUR_NAME = {
	"protector":{
		"description":[
			"You shall be unharmed by the {theme}.",
			"The {adjective} {theme} won't touch you."
		],
		"theme":[
			"blight","darkness","demons",
		],
		"adjective":[
			"calm","heavy"
		],
	},
	"protection":{
		"description":[
			"You shall be unharmed by the {theme}.",
			"Said to grant invulnerability to the {adjective} {theme}.",
			"Grants protection against the {adjective} {theme}.",
		],
		"theme":[
			"blight","darkness","demons",
		],
		"adjective":[
			"calm","heavy"
		],
	},
	"defender":{
		"description":[
			"The {adjective} defender of the {theme}.",
			"{material} {base_name} capable of defending it's wearer against the {adjective} {theme}.",
		],
		"theme":[
			"living","life","gods",
		],
		"adjective":[
			"heroic","armoured",
		],
	},
	"suit":{
		"description":[
			"Particularly {adjective} {base_name}.",
			"A {adjective} suit made of {material}.",
		],
		"adjective":[
			"handy","armoured","functional",
		],
		"material":[
			"iron silk","carbon nano tubes",
		]
	},
	"aegis":{
		"description":[
			"Said to negate {theme}.",
			"A well {adjective} piece of armour that protects it's wearer against {theme}."
		],
		"theme":[
			"harm","destruction",
		],
		"adjective":[
			"shielded","armoured",
		],
	},
	"cage":{
		"description":[
			"{base_name} made out of thick and heavy {material}.",
			"{adjective} {base_name} cumbersome to wear."
		],
		"adjective":[
			"heavy","armoured",
		],
		"material":[
			"lead","thorium","steel",
		],
		"feature":[
			"bars",
		],
	},
	"armour":{
		"description":[
			"Solid {base_name} made out of {adjective} {material}.",
		],
		"adjective":[
			"heavy","armoured",
		],
	},
	"bringer":{
		"description":[
			"Conveys the {adjective} {theme}.",
			"You feel embraced by the {adjective} {theme}.",
			"The {adjective} {theme} follows you on every step.",
		],
		"theme":[
			"force","will",
		],
	},
	"gear":{
		"adjective":[
			"handy","armoured","functional",
		],
	},
	"equipment":{
		"adjective":[
			"handy","armoured","functional",
		],
	},
	"clothing":{
		"adjective":[
			"functional","elegant",
		],
	},
	"wrappings":{
		"description":[
			"{adjective} bandage made of {material} functioning as {base_name}.",
		],
		"adjective":[
			"ancient","magical","enchanted",
		],
		"material":[
			"iron silk","aramid","carbon fibre",
		],
	},
	"embrace":{
		"description":[
			"You feel embraced by the {adjective} {theme}.",
			"This {material} {base_name} feel{s} very {adjective}."
		],
		"theme":[
			"waters","currents","warm",
		],
		"adjective":[
			"calm","firm",
		],
	},
}
const SPECIAL_JUWELERY_NAME = {
	"galaxy":{
		"description":[
			"A large jewel reflecting the {theme} sits on the {base_name}.",
			"A marvelous jewel projecting the {theme} sits on the {base_name}.",
		],
		"theme":[
			"galaxy","stars","planets",
		],
		"adjective":[
			"galactic","astral",
		],
		"material":[
			"star shard","celestial topaz","stellar amber",
		],
		"feature":[
			"jewel","marble",
		],
	},
	"marble":{
		"description":[
			"A {adjective} {base_name} decorated by the marble of theme {theme}.",
			"A large {material} marble resembling {theme} decorates this {adjective} {base_name}.",
		],
		"theme":[
			"life","death",
		],
		"adjective":[
			"polished","shiny",
		],
		"feature":[
			"marble",
		],
	},
	"jewel":{
		"description":[
			"Basically a large jewel.",
		],
		"adjective":[
			"large","polished",
		],
		"feature":[
			"jewel",
		],
	},
	"relic":{
		"description":[
			"An ancient artifact powered by {theme}.",
		],
		"theme":[
			"thorium","aether","life force","death",
		],
		"adjective":[
			"ancient","legendary",
		],
		"feature":[
			"gem",
		],
	},
	"crystal":{
		"description":[
			"A {base_name} with a large {adjective} crystal.",
		],
		"adjective":[
			"clear","glittering",
		],
		"feature":[
			"crystal",
		],
	},
}
const SPECIAL_ITEM_PREFIX = {
	"shining":{
		"willpower":2,
		"damage":{
			"light":0.06,
		},
		"resistance":{
			"light":0.06,
		},
		"description":[
			"{adjective} light will light your way.",
		],
		"theme":[
			"light","radiance",
		],
		"adjective":[
			"shining","radiant","glowing","polished","blessed",
		],
		"material":[
			"gold","silver","star silver","stellar steel",
		],
	},
	"blazing":{
		"accuracy":2,
		"damage":{
			"fire":0.05,
			"wind":0.05,
		},
		"resistance":{
			"fire":0.05,
			"wind":0.05,
		},
		"description":[
			"{adjective} {theme} is bursting out of this {base_name}.",
		],
		"theme":[
			"fire storm","fire",
		],
		"adjective":[
			"blazing","burning","fiery",
		],
		"material":[
			"amber","fire gem","flint stone",
		],
		"feature":[
			"flames",
		],
	},
	"burning":{
		"attack":2,
		"damage":{
			"fire":0.05,
			"water":0.05,
		},
		"resistance":{
			"fire":0.05,
			"water":0.05,
		},
		"description":[
			"This {base_name} burns with the power of the {adjective} {theme}.",
		],
		"theme":[
			"flames","fire",
		],
		"adjective":[
			"blazing","burning","flaming",
		],
		"material":[
			"amber","fire gem","flint stone",
		],
		"feature":[
			"flames",
		],
	},
	"dawn's":{
		"willpower":2,
		"resistance":{
			"light":0.05,
			"darkness":0.05,
		},
		"description":[
			"Said to be the {adjective} dawn of the {theme}.",
		],
		"theme":[
			"dawn",
		],
	},
	"blood":{
		"health":40,
		"description":[
			"{material} {base_name} covered with blood. You can feel the {theme} beneath.",
		],
		"theme":[
			"blood","life","death",
		],
		"adjective":[
			"bloodstained","red","crimson",
		],
		"material":[
			"crimson iron","hematite","troll hide",
		],
		"feature":[
			"blood",
		],
	},
	"bloodstained":{
		"attack":2,
		"magic":2,
		"theme":[
			"death","blood shed"
		],
		"adjective":[
			"bloodstained","red","crimson",
		],
		"feature":[
			"blood",
		],
	},
	"lost":{
		"quality":0.1,
		"adjective":[
			"lost","recently discovered",
		],
	},
	"ancient":{
		"quality":0.1,
		"adjective":[
			"ancient","legendary","archaic",
		],
		"feature":[
			"scars","scratches",
		],
	},
	"king's":{
		"quality":0.1,
		"theme":[
			"kingdom","king",
		],
		"adjective":[
			"king's","royal",
		],
		"material":[
			"gold","silver","finest steel",
		],
		"feature":[
			"velvet",
		],
	},
	"witch":{
		"magic":4,
		"theme":[
			"witch",
		],
		"adjective":[
			"cursed","magical","enchanted",
		],
	},
	"mage":{
		"magic":3,
		"mana":10,
		"theme":[
			"mage","wizard",
		],
		"adjective":[
			"magical","enchanted","elemental",
		],
		"feature":[
			"runes",
		],
	},
	"legendary":{
		"quality":0.1,
		"theme":[
			"legends",
		],
		"adjective":[
			"legendary","powerful",
		],
	},
	"epic":{
		"quality":0.1,
		"theme":[
			"legends",
		],
		"adjective":[
			"epic","poweful",
		],
	},
	"marvelous":{
		"quality":0.1,
		"adjective":[
			"marvelous",
		],
	},
	"arcane":{
		"magic":1.5,
		"willpower":1.5,
		"mana":10,
		"theme":[
			"arcana","might",
		],
		"adjective":[
			"arcane","magical",
		],
		"feature":[
			"aether",
		],
	},
	"magical":{
		"magic":2,
		"willpower":2,
		"theme":[
			"magic",
		],
		"adjective":[
			"magical","enchanted",
		],
		"feature":[
			"runes",
		],
	},
	"spell":{
		"magic":2,
		"mana":10,
		"mana_regen":5,
		"theme":[
			"spell craft",
		],
		"adjective":[
			"magical","enchanted","arcane",
		],
		"feature":[
			"spell formulas",
		],
	},
	"sacred":{
		"health":30,
		"damage":{
			"light":0.06,
		},
		"resistance":{
			"light":0.06,
		},
		"theme":[
			"god","divinity",
		],
		"adjective":[
			"sacred","divine","blessed",
		],
		"material":[
			"holy topaz","gold","silver","star silver","stellar iron",
		],
		"feature":[
			"gold plates",
		],
	},
	"divine":{
		"health":30,
		"quality":0.05,
		"theme":[
			"god","divinity",
		],
		"adjective":[
			"sacred","divine","blessed",
		],
		"material":[
			"holy topaz","gold","silver","star silver","stellar iron",
		],
		"feature":[
			"gold carvings",
		],
	},
	"mirror":{
		"evasion":4,
		"theme":[
			"mirror","reflection",
		],
		"adjective":[
			"reflecting",
		],
		"material":[
			"quarz glass","diamond","tempered glass",
		],
		"feature":[
			"mirrors",
		],
	},
	"windborne":{
		"evasion":3,
		"stamina":5,
		"damage":{
			"wind":0.06,
		},
		"resistance":{
			"wind":0.06,
		},
		"theme":[
			"wind","air",
		],
		"material":[
			"azurite","emerald","saphire",
		],
		"feature":[
			"emeralds",
		],
	},
	"summertide":{
		"damage":{
			"light":0.05,
			"water":0.05,
			"wind":0.05,
		},
		"resistance":{
			"light":0.05,
			"water":0.05,
			"wind":0.05,
		},
		"theme":[
			"summer","summer tide",
		],
		"adjective":[
			"warm","hot",
		],
	},
	"wintertide":{
		"damage":{
			"darkness":0.05,
			"water":0.05,
			"ice":0.05,
		},
		"resistance":{
			"darkness":0.05,
			"water":0.05,
			"ice":0.05,
		},
		"theme":[
			"winter","winter tide"
		],
		"adjective":[
			"cold","freezing",
		],
	},
	"primal":{
		"health":30,
		"health_regen":5,
		"adjective":[
			"primal","archaic",
		],
		"material":[
			"azurite","emerald","saphire",
		],
		"feature":[
			"moss",
		],
	},
	"life binding":{
		"health":20,
		"health_regen":10,
		"description":[
			"{base_name}s are healthy for you!",
			"The {material} {base_name} irradiates {adjective} vitality.",
		],
		"adjective":[
			"life binding","healthy","vitalizing",
		],
		"theme":[
			"life","vitality",
		],
		"feature":[
			"moss",
		],
	},
	"prismatic":{
		"damage":{
			"fire":0.04,
			"ice":0.04,
			"lightning":0.04,
			"wind":0.04,
			"water":0.04,
			"earth":0.04,
		},
		"resistance":{
			"fire":0.04,
			"ice":0.04,
			"lightning":0.04,
			"wind":0.04,
			"water":0.04,
			"earth":0.04,
		},
		"adjective":[
			"prismatic",
		],
		"feature":[
			"aether",
		],
	},
	"elemental":{
		"damage":{
			"fire":0.04,
			"ice":0.04,
			"lightning":0.04,
			"wind":0.04,
			"water":0.04,
			"earth":0.04,
		},
		"resistance":{
			"fire":0.04,
			"ice":0.04,
			"lightning":0.04,
			"wind":0.04,
			"water":0.04,
			"earth":0.04,
		},
		"theme":[
			"magic",
		],
		"adjective":[
			"elemental","magical",
		],
		"feature":[
			"aether",
		],
	},
	"celestial":{
		"damage":{
			"light":0.05,
			"darkness":0.05,
		},
		"resistance":{
			"light":0.05,
			"darkness":0.05,
		},
		"theme":[
			"twilight",
		],
		"adjective":[
			"celestial",
		],
		"material":[
			"holy topaz","gold","silver","star silver","stellar iron",
		],
		"feature":[
			"radiance",
		],
	},
	"galactic":{
		"quality":0.1,
		"theme":[
			"galaxy",
		],
		"adjective":[
			"galactic","astral",
		],
	},
	"stellar":{
		"quality":0.1,
		"theme":[
			"stars","space",
		],
		"adjective":[
			"of stellar origin","astral",
		],
		"material":[
			"star silver","stellar iron","sun bronze","moon steel",
		],
	},
	"frozen":{
		"armour":2,
		"damage":{
			"ice":0.06,
		},
		"resistance":{
			"ice":0.06,
		},
		"theme":[
			"ice","snow",
		],
		"adjective":[
			"frozen","cold","freezing",
		],
		"feature":[
			"ice",
		],
	},
	"vile":{
		"attack":2,
		"damage":{
			"poison":0.05,
			"acid":0.05,
		},
		"resistance":{
			"poison":0.05,
			"acid":0.05,
		},
		"description":[
			"You feel sick near the {adjective} {material} {base_name}.",
		],
		"theme":[
			"blight","diseases",
		],
		"adjective":[
			"vile",
		],
		"material":[
			"sludge","blight","infested bronze","shadow steel",
		],
		"feature":[
			"miasma",
		],
	},
	"silent":{
		"accuracy":2,
		"evasion":2,
		"description":[
			"The world around you turns silent.",
		],
		"theme":[
			"silence",
		],
		"adjective":[
			"silent",
		],
		"feature":[
			"aura of silence",
		],
	},
	"sentient":{
		"quality":0.1,
		"description":[
			"Something about this {material} {base_name} feels alive, almost sentient.",
			"A living {theme} seams to hide beneath the {material} {theme}.",
		],
		"theme":[
			"sapience","sentience",
		],
		"adjective":[
			"sentient","living",
		],
	},
	"unstoppable":{
		"armour":4,
		"description":[
			"Nothing can stop you when wearing the {adjective} {name}.",
		],
		"adjective":[
			"unstoppable",
		],
	},
	"mighty":{
		"attack":3,
		"stamina":10,
		"description":[
			"The {adjective} {base_name} makes you feel powerful.",
		],
		"theme":[
			"might",
		],
		"adjective":[
			"mighty",
		],
	},
	"serpentine":{
		"evasion":2,
		"damage":{
			"poison":0.05,
			"acid":0.05,
		},
		"resistance":{
			"poison":0.05,
			"acid":0.05,
		},
		"description":[
			"{adjective} poison runs down the {base_name}'s {feature}.",
		],
		"theme":[
			"serpent","poison","acid",
		],
		"adjective":[
			"serpentine","poisonous","acidic",
		],
		"feature":[
			"poison grooves",
		],
	},
	"lava":{
		"armour":2,
		"damage":{
			"fire":0.05,
			"impact":0.05,
		},
		"resistance":{
			"fire":0.05,
			"impact":0.05,
		},
		"description":[
			"{adjective} lava runs down the {base_name}'s {feature}.",
		],
		"theme":[
			"lava","magma",
		],
		"adjective":[
			"hot","melting",
		],
		"material":[
			"basalt","vulcanic ash",
		],
	},
	"hardened":{
		"armour":4,
		"description":[
			"{adjective} {material} hard as {theme}.",
		],
		"theme":[
			"diamond","the hardest steel","mitril",
		],
		"adjective":[
			"hardened","armoured",
		],
	},
	"crude":{
		"attack":2,
		"magic":2,
		"adjective":[
			"crude","archaic",
		],
	},
	"barbed":{
		"attack":4,
		"adjective":[
			"barbed",
		],
		"feature":[
			"barbs",
		],
	},
	"spiky":{
		"attack":4,
		"theme":[
			"spikes",
		],
		"adjective":[
			"spiky",
		],
		"feature":[
			"spikes",
		],
	},
	"behemoth":{
		"quality":0.1,
		"armour":4,
		"speed":-1,
		"description":[
			"Made out of the {material} of a vanquished, {adjective} creature.",
		],
		"theme":[
			"behemot",
		],
		"adjective":[
			"huge","heavy",
		],
		"material":[
			"behemoth hide","titan skin",
		],
	},
	"golden":{
		"quality":0.1,
		"theme":[
			"gold",
		],
		"adjective":[
			"golden","polished","shiny",
		],
		"material":[
			"gold",
		],
		"feature":[
			"gold plates",
		],
	},
	"molten":{
		"accuracy":1,
		"evasion":3,
		"description":[
			"This {adjective} {base_name} seams to be liquid but keeps flowing back into it's original shape.",
			"{adjective} {material} and {feature} is surely an uncommon choise for the {name} but it seams to be quite effective.",
		],
		"adjective":[
			"molten","liquid","sticky",
		],
		"feature":[
			"molt",
		],
	},
	"blighted":{
		"magic":2,
		"damage":{
			"poison":0.05,
			"acid":0.05,
		},
		"resistance":{
			"poison":0.05,
			"acid":0.05,
		},
		"description":[
			"You feel ill all of sudden. The {feature} of the {base_name} is not helping it.",
			"Spread the {adjective} {theme} upon your enemies!",
		],
		"theme":[
			"blight","diseases",
		],
		"adjective":[
			"blighted",
		],
		"material":[
			"sludge","blight","infested bronze","shadow steel",
		],
		"feature":[
			"blight","miasma",
		],
	},
	"withering":{
		"evasion":2,
		"willpower":2,
		"adjective":[
			"withering",
		],
	},
	"solid":{
		"armour":2,
		"willpower":2,
		"adjective":[
			"solid","armoured",
		],
		"feature":[
			"amour plates",
		],
	},
	"blooming":{
		"health":20,
		"health_regen":4,
		"willpower":1,
		"description":[
			"Tiny, {adjective} {feature} sprout from the {base_name}.",
		],
		"theme":[
			"life","nature",
		],
		"adjective":[
			"blooming","flowering",
		],
		"feature":[
			"sprouts","flowers",
		],
	},
	"lasting":{
		"willpower":4,
		"adjective":[
			"lasting","eternal",
		],
	},
	"gravitational":{
		"piercing":1,
		"damage":{
			"impact":0.04,
			"cutting":0.04,
			"piercing":0.04,
		},
		"resistance":{
			"impact":0.04,
			"cutting":0.04,
			"piercing":0.04,
		},
		"description":[
			"Blood drips from your fingers at a faster rate than usual as the {base_name}'s {theme} crushes your hand.",
		],
		"theme":[
			"gravity",
		],
		"adjective":[
			"gravitational","gravitating",
		],
	},
	"world's":{
		"quality":0.1,
		"description":[
			"You feel more connected to the world.",
		],
		"theme":[
			"world",
		],
		"adjective":[
			"worldly",
		],
	},
	"great":{
		"quality":0.1,
		"description":[
			"The {adjective} {name} is massive.",
		],
		"adjective":[
			"great",
		],
	},
	"greater":{
		"quality":0.1,
		"adjective":[
			"greater",
		],
	},
	"umbral":{
		"evasion":2,
		"damage":{
			"darkness":0.05,
			"acid":0.05,
			"poison":0.05,
		},
		"resistance":{
			"darkness":0.05,
			"acid":0.05,
			"poison":0.05,
		},
		"theme":[
			"night","shadows","darkness",
		],
		"adjective":[
			"umbral","dark",
		],
		"material":[
			"shadow steel","moon silver","umbral iron",
		],
		"feature":[
			"shadows",
		],
	},
	"eternal":{
		"quality":0.1,
		"mana_regen":2,
		"stamina_regen":2,
		"description":[
			"It feels like this {adjective} {base_name} has existed since the creation of the universe.",
		],
		"theme":[
			"eternity","infinity",
		],
		"adjective":[
			"eternal",
		],
	},
	"storm":{
		"accuracy":2,
		"damage":{
			"lightning":0.05,
			"wind":0.05,
		},
		"resistance":{
			"lightning":0.05,
			"wind":0.05,
		},
		"description":[
			"The sky darkens and the wind is rising as you lift the {adjective} {base_name}.",
		],
		"theme":[
			"storm","thunder storm"
		],
		"adjective":[
			"stormy","thundering",
		],
		"feature":[
			"sparks",
		],
	},
	"serpent's":{
		"accuracy":2,
		"damage":{
			"acid":0.05,
			"poison":0.05,
		},
		"resistance":{
			"acid":0.05,
			"poison":0.05,
		},
		"description":[
			"{adjective} poison runs down the {base_name}'s {feature}.",
		],
		"theme":[
			"serpent","poison","acid",
		],
		"adjective":[
			"serpentine","poisonous","acidic",
		],
		"feature":[
			"poison grooves",
		],
	},
	"second":{
		"quality":0.1,
	},
	"last":{
		"quality":0.1,
		"description":[
			"Said to be the ultimate {base_name} of {theme}.",
		],
	},
	"wanderer's":{
		"health":30,
		"stamina":10,
		"description":[
			"You feel rejuvinated when wearing this {base_name}. Something about this item feels {adjective}.",
			"Said to make it's wearer {adjective}.",
		],
		"theme":[
			"wanderer","wandering",
		],
		"adjective":[
			"wandering","restless",
		],
	},
	"mage's":{
		"magic":3,
		"mana":10,
		"theme":[
			"mage",
		],
		"adjective":[
			"magical","arcane","enchanted",
		],
	},
	"wizard's":{
		"magic":3,
		"mana_regen":3,
		"theme":[
			"wizard",
		],
		"adjective":[
			"magical","arcane","enchanted",
		],
	},
	"saint's":{
		"willpower":4,
		"theme":[
			"saint",
		],
		"adjective":[
			"holy","divine","blessed",
		],
		"material":[
			"gold","silver","star silver","stellar steel",
		],
	},
	"spectral":{
		"evasion":2,
		"resistance":{
			"fire":0.04,
			"ice":0.04,
			"lightning":0.04,
			"wind":0.04,
			"water":0.04,
			"earth":0.04,
		},
		"description":[
			"The {base_name} shifts out and back into existance at a quick pace.",
		],
		"theme":[
			"spectre",
		],
		"adjective":[
			"spectral",
		],
	},
	"aether":{
		"evasion":2,
		"resistance":{
			"light":0.05,
			"darkness":0.05,
			"poison":0.05,
			"acid":0.05,
		},
		"theme":[
			"aether",
		],
		"adjective":[
			"aethereal",
		],
		"material":[
			"aether",
		],
		"feature":[
			"aether",
		],
	},
	"void":{
		"evasion":2,
		"resistance":{
			"water":0.05,
			"wind":0.05,
			"poison":0.05,
			"acid":0.05,
		},
		"theme":[
			"void","vacuum",
		],
		"adjective":[
			"aethereal",
		],
		"material":[
			"aether",
		],
		"feature":[
			"aether",
		],
	},
	"guardian's":{
		"armour":4,
		"theme":[
			"guardian",
		],
		"adjective":[
			"guarding","armoured"
		],
	},
	"fighter's":{
		"attack":3,
		"stamina":10,
		"theme":[
			"fighter",
		],
		"adjective":[
			"fighting","brave","fearless",
		],
	},
	"brawler's":{
		"health":20,
		"attack":2,
		"theme":[
			"brawler",
		],
		"adjective":[
			"brave","fearless",
		],
	},
	"crushing":{
		"attack":4,
		"adjective":[
			"crushing",
		],
	},
	"telekinetic":{
		"willpower":2,
		"damage":{
			"impact":0.04,
			"cutting":0.04,
			"piercing":0.04,
		},
		"theme":[
			"telekinesis",
		],
		"adjective":[
			"telekinetic",
		],
	},
	"specter's":{
		"evasion":2,
		"damage":{
			"fire":0.04,
			"ice":0.04,
			"lightning":0.04,
			"wind":0.04,
			"water":0.04,
			"earth":0.04,
		},
		"theme":[
			"specter",
		],
		"adjective":[
			"spectral",
		],
	},
	"death's":{
		"health":25,
		"damage":{
			"darkness":0.06,
		},
		"resistance":{
			"darkness":0.06,
		},
		"theme":[
			"death",
		],
		"adjective":[
			"deadly","lethal","fatal",
		],
		"feature":[
			"skulls",
		],
	},
	"doombringer's":{
		"health":20,
		"attack":2,
		"theme":[
			"doom",
		],
		"adjective":[
			"doomed","evil",
		],
		"feature":[
			"bones",
		],
	},
	"eternity's":{
		"health":20,
		"quality":0.05,
		"theme":[
			"eternity",
		],
		"adjective":[
			"eternal","infinite",
		],
	},
	"radiant":{
		"accuracy":2,
		"evasion":2,
		"theme":[
			"radiance",
		],
		"adjective":[
			"radiant","shining","polished",
		],
		"material":[
			"gold","silver","star silver","stellar steel",
		],
		"feature":[
			"radiance",
		],
	},
	"unbreakable":{
		"armour":4,
		"adjective":[
			"unbreakable",
		],
	},
	"untouchable":{
		"willpower":4,
		"adjective":[
			"untouchable",
		],
	},
	"calm":{
		"health":20,
		"health_regen":2.5,
		"stamina_regen":5,
		"adjective":[
			"calm","relexing","soothing",
		],
	},
	"earth":{
		"health":40,
		"theme":[
			"earth","ground","nature",
		],
		"feature":[
			"earth",
		],
	},
	"sand":{
		"magic":2,
		"damage":{
			"impact":0.04,
			"cutting":0.04,
			"piercing":0.04,
		},
		"theme":[
			"sand","dunes","desert",
		],
		"feature":[
			"sand",
		],
	},
	"dust":{
		"willpower":2,
		"resistance":{
			"impact":0.04,
			"cutting":0.04,
			"piercing":0.04,
		},
		"theme":[
			"dust",
		],
		"adjective":[
			"dusty",
		],
		"feature":[
			"dust",
		],
	},
	"chill":{
		"willpower":2,
		"damage":{
			"ice":0.05,
			"water":0.05,
		},
		"resistance":{
			"ice":0.05,
			"water":0.05,
		},
		"adjective":[
			"cold","freezing",
		],
		"material":[
			"cold steel","frost diamond","saphire",
		],
		"feature":[
			"ice",
		],
	},
	"immemorial":{
		"quality":0.1,
		"adjective":[
			"immemorial",
		],
	},
	"murder":{
		"accuracy":2,
		"attack":2,
		"theme":[
			"murder","death",
		],
		"adjective":[
			"murderous","brutal","evil",
		],
		"feature":[
			"bones",
		],
	},
	"sludge":{
		"evasion":2,
		"magic":2,
		"theme":[
			"sludge",
		],
		"adjective":[
			"slimy",
		],
		"material":[
			"sludge",
		],
		"feature":[
			"sludge",
		],
	},
	"temporal":{
		"speed":2,
		"theme":[
			"time",
		],
		"adjective":[
			"temporal",
		],
	},
	"siege":{
		"armour":4,
		"theme":[
			"siege",
		],
		"adjective":[
			"heavy",
		],
	},
	"crimson":{
		"quality":0.1,
		"adjective":[
			"crimson",
		],
		"material":[
			"crimson steel","hematite",
		],
	},
	"black":{
		"quality":0.1,
		"adjective":[
			"black","dark",
		],
		"feature":[
			"shadows",
		],
	},
	"gazing":{
		"quality":0.1,
		"theme":[
			"gaze",
		],
		"adjective":[
			"gazing","observing",
		],
		"feature":[
			"eyes",
		],
	},
	"obliterating":{
		"attack":4,
		"theme":[
			"obliteration",
		],
		"adjective":[
			"obliterating",
		],
	},
	"champion's":{
		"attack":2,
		"magic":2,
		"theme":[
			"champion",
		],
		"adjective":[
			"mighty",
		],
	},
	"cinder":{
		"magic":4,
		"theme":[
			"fire",
		],
		"adjective":[
			"flaming","burning",
		],
		"feature":[
			"flames","sparks",
		],
	},
	"jolt":{
		"magic":2,
		"damage":{
			"lightning":0.05,
			"water":0.05,
		},
		"resistance":{
			"lightning":0.05,
			"water":0.05,
		},
		"theme":[
			"lightning","thunder",
		],
		"material":[
			"azurite","emerald","copper",
		],
	},
	"sparkling":{
		"magic":2,
		"damage":{
			"lightning":0.05,
			"fire":0.05,
		},
		"resistance":{
			"lightning":0.05,
			"fire":0.05,
		},
		"theme":[
			"lightning","sparks",
		],
		"adjective":[
			"sparkling",
		],
		"material":[
			"azurite","emerald","copper",
		],
		"feature":[
			"sparks",
		],
	},
	"thunder":{
		"willpower":2,
		"damage":{
			"lightning":0.05,
			"light":0.05,
		},
		"resistance":{
			"lightning":0.05,
			"light":0.05,
		},
		"theme":[
			"thunder",
		],
		"adjective":[
			"thundering",
		],
		"material":[
			"azurite","emerald","copper",
		],
	},
	"icy":{
		"willpower":2,
		"damage":{
			"ice":0.05,
			"wind":0.05,
		},
		"resistance":{
			"ice":0.05,
			"wind":0.05,
		},
		"theme":[
			"ice","frost",
		],
		"adjective":[
			"cold","icy","frozen",
		],
		"material":[
			"cold steel","frost diamond","saphire",
		],
		"feature":[
			"ice",
		],
	},
	"anchoring":{
		"health":30,
		"armour":3,
		"speed":-1,
		"theme":[
			"anchor","stasis",
		],
		"adjective":[
			"anchoring",
		],
	},
	"doom":{
		"attack":2,
		"magic":2,
		"theme":[
			"doom",
		],
		"feature":[
			"skulls",
		],
	},
	"kinetic":{
		"attack":2,
		"damage":{
			"impact":0.04,
			"cutting":0.04,
			"piercing":0.04,
		},
		"adjective":[
			"kinetic",
		],
	},
	"thermal":{
		"magic":2,
		"damage":{
			"fire":0.05,
			"ice":0.05,
		},
		"resistance":{
			"fire":0.05,
			"ice":0.05,
		},
		"adjective":[
			"thermal",
		],
	},
	"cryo":{
		"magic":2,
		"damage":{
			"fire":0.05,
			"ice":0.05,
		},
		"resistance":{
			"fire":0.05,
			"ice":0.05,
		},
		"adjective":[
			"cryo","thermal",
		],
	},
	"superconducting":{
		"magic":2,
		"damage":{
			"lightning":0.05,
			"ice":0.05,
		},
		"resistance":{
			"lightning":0.05,
			"ice":0.05,
		},
		"theme":[
			"superconductivity",
		],
		"adjective":[
			"superconducting",
		],
	},
	"electric":{
		"magic":2,
		"quality":0.05,
		"theme":[
			"electricity",
		],
		"adjective":[
			"electric",
		],
	},
	"geometric":{
		"quality":0.1,
		"theme":[
			"geometry",
		],
		"adjective":[
			"geometric",
		],
		"feature":[
			"symbols",
		],
	},
	"lightning":{
		"evasion":2,
		"speed":1,
		"theme":[
			"lightning","thunder",
		],
		"feature":[
			"sparks",
		],
	},
	"omni":{
		"quality":0.07,
		"health":10,
		"stamina":10,
		"mana":10,
		"adjective":[
			"omnipotent",
		],
		"feature":[
			"everything",
		],
	},
	"gigantic":{
		"health":40,
		"quality":0.1,
		"speed":-1,
		"adjective":[
			"gigantic","huge","heavy",
		],
	},
	"titanic":{
		"health":40,
		"quality":0.1,
		"speed":-1,
		"theme":[
			"titans",
		],
		"adjective":[
			"titanic","huge","heavy",
		],
	},
	"wicked":{
		"quality":0.15,
		"willpower":-2,
		"theme":[
			"curse",
		],
		"adjective":[
			"wicked",
		],
	},
	"cursed":{
		"quality":0.15,
		"willpower":-2,
		"theme":[
			"curse",
		],
		"adjective":[
			"cursed","wicked",
		],
	},
	"crescent":{
		"quality":0.1,
		"adjective":[
			"crescent",
		],
	},
	"flowering":{
		"health":30,
		"health_regen":2,
		"theme":[
			"flowers",
		],
		"adjective":[
			"flowering","blooming"
		],
		"material":[
			"flower seeds","ruby","emerald","sapphire","amber",
		],
		"feature":[
			"flowers","sprouts",
		],
	},
	"everpyre":{
		"magic":4,
		"theme":[
			"flames","pyre",
		],
		"adjective":[
			"flaming","burning",
		],
		"feature":[
			"flames",
		],
	},
	"breach":{
		"penetration":6,
		"theme":[
			"breach",
		],
		"adjective":[
			"breaching",
		],
	},
	"pixie dust":{
		"penetration":6,
		"theme":[
			"pixie",
		],
		"adjective":[
			"magical",
		],
		"feature":[
			"pixie dust",
		],
	},
	"grand":{
		"quality":0.1,
		"adjective":[
			"grand",
		],
	},
	"spatial":{
		"penetration":6,
		"theme":[
			"space",
		],
		"adjective":[
			"spatial",
		],
	},
	"apocalypse":{
		"quality":0.1,
		"theme":[
			"apocalypse",
		],
		"adjective":[
			"apocalyptic",
		],
	},
	"thorny":{
		"attack":4,
		"theme":[
			"thorns",
		],
		"adjective":[
			"thorny","sharp",
		],
		"feature":[
			"thorns","barbs",
		],
	},
	"revolving":{
		"evasion":4,
		"adjective":[
			"revolving",
		],
	},
	"bloody":{
		"health":40,
		"theme":[
			"blood","death",
		],
		"adjective":[
			"bloody","bloodstained"
		],
		"material":[
			"crimson steel","hematite",
		],
		"feature":[
			"blood",
		],
	},
	"summoner's":{
		"mana":10,
		"stamina":10,
		"focus":1,
		"theme":[
			"summoning",
		],
	},
	"necromancer's":{
		"health":10,
		"focus":1,
		"damage":{
			"darkness":0.06,
		},
		"theme":[
			"necromancy",
		],
		"adjective":[
			"necromantic",
		],
		"feature":[
			"bones",
		],
	},
	"binding":{
		"health":40,
		"feature":[
			"wrapping",
		],
	},
	"abyssal":{
		"attack":1,
		"magic":1,
		"damage":{
			"fire":0.05,
			"darkness":0.05,
		},
		"resistance":{
			"fire":0.05,
			"darkness":0.05,
		},
		"theme":[
			"abyss",
		],
		"adjective":[
			"abyssal","infernal",
		],
	},
	"heavenly":{
		"armour":1,
		"willpower":1,
		"damage":{
			"light":0.05,
			"wind":0.05,
		},
		"resistance":{
			"light":0.05,
			"wind":0.05,
		},
		"theme":[
			"heaven",
		],
		"adjective":[
			"heavenly",
		],
		"material":[
			"gold","silver",
		],
		"feature":[
			"gold plates","gems",
		],
	},
	"laser":{
		"magic":2,
		"damage":{
			"fire":0.05,
			"light":0.05,
		},
		"resistance":{
			"fire":0.05,
			"light":0.05,
		},
		"theme":[
			"laser",
		],
		"adjective":[
			"laser powered",
		],
		"feature":[
			"rubies",
		],
	},
	"kinky":{
		"speed":1,
		"quality":0.05,
		"theme":[
			"kink",
		],
		"adjective":[
			"kinky",
		],
	},
	"quicksilver":{
		"speed":2,
		"adjective":[
			"quick","swift",
		],
		"material":[
			"quicksilver","mercury",
		],
		"feature":[
			"mercury",
		],
	},
	"mercury":{
		"speed":2,
		"adjective":[
			"quick","swift",
		],
		"material":[
			"quicksilver","mercury",
		],
		"feature":[
			"mercury",
		],
	},
	"hexagon":{
		"quality":0.1,
		"description":[
			"Hexagons are arguably the best polygons.",
			"Infused with the {adjective} power of hexagons!",
			"The power of hexagons is the power of {theme}.",
		],
		"adjective":[
			"hexagonal",
		],
		"feature":[
			"hexagons",
		],
	},
	"concentration":{
		"focus":2,
		"theme":[
			"concentration",
		],
		"adjective":[
			"concentrating","conentration",
		],
	},
	"soothing":{
		"stamina":20,
		"mana":20,
		"theme":[
			"calm","tranqulity",
		],
		"adjective":[
			"soothing","calming",
		],
	},
	"refreshing":{
		"health_regen":2.5,
		"stamina_regen":7.5,
		"mana_regen":7.5,
		"theme":[
			"endurance",
		],
		"adjective":[
			"refreshing",
		],
	},
	"nightmare":{
		"quality":0.05,
		"willpower":-1,
		"damage":{
			"darkness":0.075,
		},
		"resistance":{
			"light":-0.1,
			"darkness":0.075,
			"cutting":0.04,
			"piercing":0.04,
			"impact":0.04,
		},
		"description":[
			"Your foes' bigest nightmare is you.",
			"You feel your {adjective} nightmares catching up to you.",
		],
		"theme":[
			"nightmare",
		],
		"adjective":[
			"nightmarish","pitch black",
		],
	},
}
const SPECIAL_ITEM_SUFFIX = {
	"of Last Resort":{
		"health":40,
		"theme":[
			"last resort","hope",
		],
	},
	"of Vitality":{
		"health":30,
		"health_regen":2.5,
		"theme":[
			"vitality","life","health",
		],
		"adjective":[
			"healthy","vitalizing",
		],
		"feature":[
			"water of life",
		],
	},
	"of Supremacy":{
		"attack":2,
		"magic":2,
		"description":[
			"Supreme {base_name} and a {adjective} {name} at that.",
		],
		"theme":[
			"supremacy",
		],
		"adjective":[
			"supreme",
		],
	},
	"of Superiority":{
		"attack":1,
		"magic":1,
		"armour":1,
		"willpower":1,
		"description":[
			"You shall not question the superiority of the {adjective} {theme}."
		],
		"theme":[
			"superiority",
		],
		"adjective":[
			"superior",
		],
	},
	"of Destruction":{
		"damage":{
			"fire":0.03,
			"ice":0.03,
			"lightning":0.03,
			"water":0.03,
			"wind":0.03,
			"earth":0.03,
			"light":0.03,
			"darkness":0.03,
			"poison":0.03,
			"acid":0.03,
			"impact":0.03,
			"cutting":0.03,
			"piercing":0.03,
		},
		"description":[
			"You shall bring {adjective} destruction upon your foes.",
			"The {adjective} {base_name} manaced with vile energy.",
		],
		"theme":[
			"destruction",
		],
		"adjective":[
			"destructive",
		],
	},
	"of Protection":{
		"armour":2,
		"resistance":{
			"impact":0.04,
			"cutting":0.04,
			"piercing":0.04,
		},
		"description":[
			"The blades of your foes will shatter against the {adjective} {base_name}."
		],
		"theme":[
			"protection",
		],
		"adjective":[
			"protective",
		],
	},
	"of the Dead":{
		"health":20,
		"damage":{
			"darkness":0.06,
		},
		"resistance":{
			"darkness":0.06,
		},
		"theme":[
			"death","the dead",
		],
		"adjective":[
			"necromantic","evil","vile",
		],
		"feature":[
			"skulls",
		],
	},
	"of the Galaxy":{
		"quality":0.1,
		"theme":[
			"galaxy",
		],
		"adjective":[
			"galactic",
		],
		"feature":[
			"gems","marbles",
		],
	},
	"of Life":{
		"health":30,
		"health_regen":2.5,
		"theme":[
			"life","healing",
		],
		"adjective":[
			"healing",
		],
		"feature":[
			"moss","sprouts",
		],
	},
	"of Blood":{
		"health":40,
		"theme":[
			"blood","life","death","blood shed"
		],
		"adjective":[
			"bloodstained","bloody",
		],
		"feature":[
			"blood",
		],
	},
	"of the Emperor":{
		"quality":0.1,
		"description":[
			"The {theme} emperor grants you this {adjective} {base_name}."
		],
		"theme":[
			"emperor","king",
		],
		"adjective":[
			"imperial","royal",
		],
		"feature":[
			"royal insignia",
		],
	},
	"of the War Master":{
		"attack":4,
		"description":[
			"The war master's {adjective} {base_name}. Countless fierce battles left their marks.",
		],
		"theme":[
			"war","war master"
		],
		"adjective":[
			"brutal",
		],
		"feature":[
			"scratches","dents",
		],
	},
	"of the Archmage":{
		"magic":3,
		"mana":10,
		"theme":[
			"archmage",
		],
		"adjective":[
			"magical","enchanted",
		],
		"feature":[
			"runes",
		],
	},
	"of Prophecies":{
		"resistance":{
			"fire":0.04,
			"ice":0.04,
			"lightning":0.04,
			"light":0.04,
			"darkness":0.04,
			"wind":0.04,
			"earth":0.04,
			"water":0.04,
		},
		"description":[
			"The {adjective} conclusion of the {theme}'s prophecy."
		],
		"theme":[
			"prophecy",
		],
	},
	"of Legends":{
		"quality":0.1,
		"theme":[
			"legend",
		],
		"adjective":[
			"legendary","ancient",
		],
	},
	"of Preservation":{
		"health":20,
		"health_regen":2.5,
		"resistance":{
			"poison":0.06,
			"acid":0.06,
		},
		"theme":[
			"preservation",
		],
		"adjective":[
			"preserving","protecting",
		],
	},
	"of the Calm Waters":{
		"resistance":{
			"fire":0.04,
			"ice":0.04,
			"lightning":0.04,
			"wind":0.04,
			"water":0.04,
			"earth":0.04,
			"poison":0.04,
			"acid":0.04,
		},
		"description":[
			"The wind and water around you seams to calm down in the presence of the {adjective} {base_name}.",
		],
		"adjective":[
			"calm","soothing","relaxing",
		],
		"feature":[
			"water",
		],
	},
	"of Domination":{
		"quality":0.1,
		"theme":[
			"domination",
		],
		"adjective":[
			"dominating",
		],
	},
	"of the Sun":{
		"willpower":2,
		"resistance":{
			"light":0.05,
			"darkness":0.05,
		},
		"description":[
			"The {name} shine{s} as {adjective} as the sun.",
		],
		"theme":[
			"sun",
		],
		"adjective":[
			"solar","bright",
		],
		"feature":[
			"gold plates",
		],
	},
	"of the Moon":{
		"armour":2,
		"resistance":{
			"light":0.05,
			"darkness":0.05,
		},
		"description":[
			"The {name} is surrounded by a dim glow as {adjective} as the moon.",
		],
		"theme":[
			"moon",
		],
		"adjective":[
			"bright",
		],
		"feature":[
			"silver plates",
		],
	},
	"of the Archlich":{
		"magic":2,
		"damage":{
			"darkness":0.05,
			"acid":0.05,
			"poison":0.05,
		},
		"theme":[
			"archlich",
		],
		"adjective":[
			"evil","ancient","vile",
		],
		"feature":[
			"bones",
		],
	},
	"of Might":{
		"attack":4,
		"theme":[
			"might",
		],
		"adjective":[
			"mighty",
		],
	},
	"of Magic":{
		"magic":4,
		"theme":[
			"magic",
		],
		"adjective":[
			"magical","enchanted","arcane",
		],
	},
	"of the Void":{
		"magic":2,
		"resistance":{
			"light":0.05,
			"darkness":0.05,
		},
		"theme":[
			"void","vacuum",
		],
		"adjective":[
			"aethereal",
		],
		"feature":[
			"aether",
		],
	},
	"of Dreams":{
		"magic":2,
		"willpower":2,
		"description":[
			"You get sleepy all of sudden.",
		],
		"theme":[
			"dreams","slumber",
		],
		"adjective":[
			"dreaming",
		],
	},
	"of Insanity":{
		"attack":3,
		"magic":3,
		"willpower":-2,
		"description":[
			"Thoughts of {theme} start to appear in your mind.",
		],
		"theme":[
			"insanity",
		],
	},
	"of Sanity":{
		"willpower":4,
		"theme":[
			"sanity",
		],
		"adjective":[
			"calm","clear","stable",
		],
	},
	"of Sanctuary":{
		"health":20,
		"resistance":{
			"light":0.04,
			"darkness":0.04,
			"fire":0.04,
			"ice":0.04,
			"lightning":0.04,
			"wind":0.04,
			"water":0.04,
			"earth":0.04,
			"poison":0.04,
			"acid":0.04,
		},
		"theme":[
			"sanctuary",
		],
	},
	"of Agility":{
		"speed":2,
		"theme":[
			"agility",
		],
		"adjective":[
			"agile","swift",
		],
	},
	"of Speed":{
		"speed":2,
		"theme":[
			"speed",
		],
		"adjective":[
			"agile","swift",
		],
	},
	"of Doom":{
		"attack":2,
		"magic":2,
		"theme":[
			"doom",
		],
		"feature":[
			"skulls",
		],
	},
	"of Fortune":{
		"accuracy":2,
		"evasion":2,
		"theme":[
			"fortune",
		],
		"adjective":[
			"fortunate",
		],
		"feature":[
			"gold lining",
		],
	},
	"of Eclipse":{
		"attack":1,
		"magic":1,
		"resistance":{
			"light":0.05,
			"darkness":0.05,
		},
		"theme":[
			"eclipse",
		],
	},
	"of Omniscience":{
		"accuracy":2,
		"evasion":2,
		"description":[
			"Said to grant omniscience in exchange for {theme}.",
		],
		"theme":[
			"omniscience",
		],
		"adjective":[
			"omniscient",
		],
	},
	"of Dawn":{
		"willpower":1,
		"damage":{
			"light":0.05,
			"darkness":0.05,
		},
		"theme":[
			"dawn",
		],
		"adjective":[
			"light","shadow",
		],
	},
	"of the Hunter":{
		"accuracy":4,
		"theme":[
			"hunter","pursuit",
		],
		"adjective":[
			"relentless",
		],
		"feature":[
			"spikes","barbs",
		],
	},
	"of Exile":{
		"evasion":4,
		"theme":[
			"exile",
		],
		"adjective":[
			"exiled","banned",
		],
	},
	"of Fear":{
		"willpower":4,
		"theme":[
			"fear","fright",
		],
		"adjective":[
			"fearful","frightening",
		],
		"feature":[
			"miasma",
		],
	},
	"of Illusions":{
		"evasion":4,
		"descriptions":[
			"You seam to become blurry and covered in {theme}.",
		],
		"theme":[
			"illusion",
		],
		"feature":[
			"mirrors",
		],
	},
	"of Vision":{
		"accuracy":2,
		"evasion":2,
		"description":[
			"While wielding the {name} you have visions of {theme}.",
		],
		"theme":[
			"vision",
		],
	},
	"of Darkness":{
		"damage":{
			"darkness":0.06,
		},
		"resistance":{
			"darkness":0.06,
		},
		"theme":[
			"darkness","shadows",
		],
		"adjective":[
			"dark","umbral","nocturnal",
		],
		"feature":[
			"shadows",
		],
	},
	"of Light":{
		"damage":{
			"light":0.06,
		},
		"resistance":{
			"light":0.06,
		},
		"theme":[
			"light",
		],
		"adjective":[
			"bright","shining","glowing",
		],
		"feature":[
			"radiance",
		],
	},
	"of the Random Number God":{
		"quality":0.1,
		"theme":[
			"randomness","procedural generation"
		],
		"adjective":[
			"random",
		],
		"feature":[
			"random patterns",
		],
	},
	"of Grandeur":{
		"quality":0.1,
		"theme":[
			"grandeur",
		],
		"adjective":[
			"grand","great",
		],
	},
	"of Summoner":{
		"focus":1,
		"stamina":10,
		"mana":10,
		"theme":[
			"summoning",
		],
	},
	"of Necromancer":{
		"focus":1,
		"health":10,
		"damage":{
			"darkness":0.06,
		},
		"theme":[
			"necromancy",
		],
		"feature":[
			"bones",
		],
	},
	"of Maelstrom":{
		"magic":1,
		"damage":{
			"darkness":0.045,
			"water":0.045,
			"wind":0.045,
			"earth":0.045,
		},
		"resistance":{
			"darkness":0.045,
			"water":0.045,
			"wind":0.045,
			"earth":0.045,
		},
		"theme":[
			"maelstrom",
		],
		"feature":[
			"miasma",
		],
	},
	"of Starfall":{
		"magic":1,
		"damage":{
			"light":0.045,
			"lightning":0.045,
			"wind":0.045,
			"earth":0.035,
			"impact":0.035,
		},
		"resistance":{
			"light":0.045,
			"lightning":0.045,
			"wind":0.045,
			"earth":0.035,
			"impact":0.035,
		},
		"theme":[
			"stars","space","galaxy",
		],
		"adjective":[
			"of stellar origin","aethereal",
		],
		"feature":[
			"tiny gems",
		],
	},
	"of Daemons":{
		"attack":1,
		"damage":{
			"darkness":0.045,
			"acid":0.045,
			"cutting":0.035,
			"piercing":0.035,
			"impact":0.035,
		},
		"resistance":{
			"darkness":0.045,
			"acid":0.045,
			"cutting":0.035,
			"piercing":0.035,
			"impact":0.035,
		},
		"description":[
			"Give in the temptation and claim your {adjective} reward of {theme}!",
		],
		"theme":[
			"might","power","delusion",
		],
		"adjective":[
			"demonic","cursed","powerful","vile",
		],
	},
	"of Whispers":{
		"accuracy":2,
		"evasion":2,
		"description":[
			"Do you hear the {adjective} whispers of {theme}?",
			"{adjective} whispers echo through your head leaving behind images of {theme}.",
		],
		"theme":[
			"the dead","the deceased",
		],
		"adjective":[
			"loud","silent","echoing","incorporal","unholy",
		],
	},
	"of Hidden Resources":{
		"stamina":25,
		"mana":25,
		"focus":1,
		"theme":[
			"endurance",
		],
		"adjective":[
			"resourceful","emergency","backup",
		],
	},
}
const MASTER_CRAFTER_ADJECTIVE = [
	"last","final","master","legacy","favorite","beloved","overpowered","optimized",
]
const DEFAULT_MATERIAL_PRICE = 10
const DEFAULT_MATERIAL_TYPES = [
	{
		"name":"common",
		"quality":0.75,
	},
	{
		"name":"good",
		"quality":1.0,
	},
	{
		"name":"rare",
		"quality":1.25,
	},
]
const DEFAULT_MATERIALS = {
	"wood":[
		{
			"name":"pine",
			"quality":0.75,
		},
		{
			"name":"cedar",
			"quality":0.75,
		},
		{
			"name":"maple",
			"quality":1.0,
		},
		{
			"name":"bamboo",
			"quality":1.0,
		},
		{
			"name":"birch",
			"quality":1.25,
		},
		{
			"name":"oak",
			"quality":1.25,
		},
	],
	"paper":[
		{
			"name":"rough",
			"quality":0.75,
		},
		{
			"name":"bleached",
			"quality":1.0,
		},
		{
			"name":"common",
			"quality":1.0,
		},
		{
			"name":"infused",
			"quality":1.25,
		},
	],
	"cloth":[
		{
			"name":"wool",
			"quality":0.75,
		},
		{
			"name":"polyester",
			"quality":0.75,
		},
		{
			"name":"linen",
			"quality":1.0,
		},
		{
			"name":"cotton",
			"quality":1.0,
		},
		{
			"name":"velvet",
			"quality":1.25,
		},
		{
			"name":"silk",
			"quality":1.25,
		},
	],
	"leather":[
		{
			"name":"rough",
			"quality":0.75,
		},
		{
			"name":"worn down",
			"quality":0.75,
		},
		{
			"name":"reinforced",
			"quality":1.0,
		},
		{
			"name":"wolf skin",
			"quality":1.0,
		},
		{
			"name":"bear skin",
			"quality":1.25,
		},
		{
			"name":"troll hide",
			"quality":1.25,
		},
	],
	"metal":[
		{
			"name":"tin",
			"quality":0.75,
		},
		{
			"name":"copper",
			"quality":0.75,
		},
		{
			"name":"bronze",
			"quality":1.0,
		},
		{
			"name":"iron",
			"quality":1.0,
		},
		{
			"name":"steel",
			"quality":1.25,
		},
		{
			"name":"silver",
			"quality":1.25,
		},
	],
	"stone":[
		{
			"name":"clay",
			"quality":0.75,
		},
		{
			"name":"graphite",
			"quality":0.75,
		},
		{
			"name":"quartz",
			"quality":1.0,
		},
		{
			"name":"sand stone",
			"quality":1.0,
		},
		{
			"name":"granite",
			"quality":1.25,
		},
		{
			"name":"basalt",
			"quality":1.25,
		},
	],
	"gem":[
		{
			"name":"quartz",
			"quality":0.75,
		},
		{
			"name":"peridot",
			"quality":0.75,
		},
		{
			"name":"turquoise",
			"quality":0.75,
		},
		{
			"name":"glass",
			"quality":0.75,
		},
		{
			"name":"agate",
			"quality":1.0,
		},
		{
			"name":"emerald",
			"quality":1.0,
		},
		{
			"name":"amber",
			"quality":1.0,
		},
		{
			"name":"lapis lazuli",
			"quality":1.0,
		},
		{
			"name":"garnet",
			"quality":1.25,
		},
		{
			"name":"hematite",
			"quality":1.25,
		},
		{
			"name":"ruby",
			"quality":1.25,
		},
		{
			"name":"sapphire",
			"quality":1.25,
		},
	],
	"bone":[
		{
			"name":"withered",
			"quality":0.75,
		},
		{
			"name":"beast",
			"quality":1.0,
		},
		{
			"name":"tiger",
			"quality":1.25,
		},
	],
	"soul":[
		{
			"name":"fleeting",
			"quality":0.75,
		},
		{
			"name":"unremarkable",
			"quality":1.0,
		},
		{
			"name":"greater",
			"quality":1.25,
		},
	],
}
const LEGENDARY_MATERIALS = {
	"wood":[
		{
			"name":"redwood",
			"quality":1.0,
			"add":{
				"attack":0.5,
				"penetration":0.75,
			},
		},
		{
			"name":"blackwood",
			"quality":1.0,
			"add":{
				"accuracy":0.5,
				"evasion":0.5,
			},
		},
		{
			"name":"whitewood",
			"quality":1.0,
			"add":{
				"health":5,
				"stamina":2.5,
				"mana":2.5,
			},
		},
		{
			"name":"steelwood",
			"quality":1.0,
			"add":{
				"armour":1,
			},
		},
	],
	"paper":[
		{
			"name":"forgotten beast",
			"quality":1.0,
			"add":{
				"willpower":1,
			},
		},
		{
			"name":"ancient beast",
			"quality":1.0,
			"add":{
				"magic":0.5,
				"accuracy":0.5,
			},
		},
		{
			"name":"aether infused",
			"quality":1.0,
			"add":{
				"mana":2.5,
				"mana_regen":1.5,
			},
		},
	],
	"cloth":[
		{
			"name":"aramid",
			"quality":1.0,
			"add":{
				"resistance":{
					"piercing":0.025,
					"fire":0.025,
					"light":0.025,
				},
			},
		},
		{
			"name":"ancient beast fur",
			"quality":1.0,
			"add":{
				"resistance":{
					"cutting":0.025,
					"ice":0.025,
					"water":0.025,
				},
			},
		},
		{
			"name":"exquisite velvet",
			"quality":1.0,
			"add":{
				"willpower":0.5,
				"evasion":0.5,
			},
		},
		{
			"name":"resilient silk",
			"quality":1.0,
			"add":{
				"willpower":0.5,
				"armour":0.5,
			},
		},
	],
	"leather":[
		{
			"name":"infused troll",
			"quality":1.0,
			"add":{
				"health_regen":2.5,
			},
		},
		{
			"name":"ancient beast",
			"quality":1.0,
			"add":{
				"armour":0.5,
				"accuracy":0.5,
			},
		},
		{
			"name":"forgotten beast",
			"quality":1.0,
			"add":{
				"armour":0.5,
				"evasion":0.5,
			},
		},
	],
	"metal":[
		{
			"name":"mithril",
			"quality":1.0,
			"add":{
				"accuracy":0.5,
				"evasion":0.5,
			},
		},
		{
			"name":"black steel",
			"quality":1.0,
			"add":{
				"attack":0.5,
				"penetration":0.75,
			},
		},
		{
			"name":"quicksilver",
			"quality":0.95,
			"add":{
				"speed":0.5,
			},
		},
	],
	"stone":[
		{
			"name":"granite",
			"quality":1.0,
			"add":{
				"resistance":{
					"cutting":0.02,
					"piercing":0.02,
					"impact":0.02,
				},
			},
		},
		{
			"name":"basalt",
			"quality":1.0,
			"add":{
				"attack":1,
			},
		},
		{
			"name":"marble",
			"quality":1.0,
			"add":{
				"magic":0.5,
				"mana_regen":1.5,
			},
		},
	],
	"gem":[
		{
			"name":"pure diamond",
			"quality":1.0,
			"add":{
				"magic":1,
			},
		},
		{
			"name":"star saphire",
			"quality":1.0,
			"add":{
				"magic":0.5,
				"willpower":0.5,
			},
		},
		{
			"name":"blood ruby",
			"quality":1.0,
			"add":{
				"health":2.5,
				"health_regen":1,
			},
		},
	],
	"bone":[
		{
			"name":"ancient beast",
			"quality":1.0,
			"add":{
				"resitance":{
					"impact":0.02,
					"cutting":0.02,
					"piercing":0.02,
				},
			},
		},
		{
			"name":"ancient beast",
			"quality":1.0,
			"add":{
				"damage":{
					"impact":0.015,
					"cutting":0.015,
					"piercing":0.015,
				},
			},
		},
	],
}
const SOUL_STONES = ["soul_splinter", "soul_shard", "soul_stone", "soul_gem", "soul_jewel", "soul_orb"]

var enchantments_by_slot:= {}

var is_vegan:= false


func pick_random_equipment(type: String) -> String:
	var valid:= []
	for k in EQUIPMENT_RECIPES.keys():
		if EQUIPMENT_RECIPES[k].type==type:
			valid.push_back(k)
	if valid.size()>0:
		return valid.pick_random()
	return ""


func get_material_quality(materials: Array) -> int:
	var quality:= 0
	for mat in materials:
		quality += mat.quality
	quality /= materials.size()
	return quality

func get_creature_quality(creature: Dictionary) -> int:
	var quality: int
	var tier_multiplier:= 1.0
	var level_multiplier: float = 1.0 + 0.1*(creature.level-1)
	if creature.tier<0:
		tier_multiplier = 1.0/sqrt(-2.0*creature.tier)
	elif creature.tier>0:
		tier_multiplier = sqrt(2.0*creature.tier)
	quality = int(100*level_multiplier*tier_multiplier)
	return quality

func make_list(array: Array) -> String:
	var string:= ""
	if array.size()==1:
		string = Story.get_a_an(array[0].name)+array[0].name
	elif array.size()==2:
		string = Story.get_a_an(array[0].name)+array[0].name + " and " + Story.get_a_an(array[1].name)+array[1].name
	else:
		for i in range(array.size()):
			string += Story.get_a_an(array[i].name)+array[i].name
			if i<array.size()-2:
				string += ", "
			elif i==array.size()-2:
				string += ", and "
	return string

func create_tooltip(item: Dictionary) -> String:
	if !item.has("source"):
		item.source = tr("UNKNOWN_ORIGIN")
	var text: String = item.name + "\n" + item.type + "\n"
	if item.has("components"):
		text += item.components + "\n"
	text += item.source + "\n\n" + "quality: " + str(int(item.quality)) + "%\n"
	for k in ATTRIBUTES:
		if !item.has(k) || int(item[k])==0:
			continue
		if item[k]>0:
			text += k + ": +" + str(int(item[k])) + "\n"
		else:
			text += k + ": -" + str(-int(item[k])) + "\n"
	for k in Characters.DEFAULT_STATS.keys():
		if !item.has(k) || int(item[k])==0:
			continue
		if item[k]>0:
			text += k + ": +" + str(int(item[k])) + "\n"
		else:
			text += k + ": -" + str(-int(item[k])) + "\n"
	if item.has("healing"):
		text += "healing: " + str(int(item.healing)) + " " + tr(item.effect.to_upper()) + "\n"
	if item.has("damage"):
		text += "damage:\n"
		for k in item.damage.keys():
			var value:= int(100*item.damage[k])
			if value==0:
				continue
			if item.damage[k]>=0.0:
				text += "  " + k + ": +" + str(value) + "%\n"
			else:
				text += "  " + k + ": -" + str(-value) + "%\n"
	for k in Characters.RESOURCES:
		if item.has(k):
			if item[k]>=0:
				text += tr(k.to_upper()) + ": +" + str(int(item[k])) + "\n"
			else:
				text += tr(k.to_upper()) + ": -" + str(-int(item[k])) + "\n"
		if item.has(k+"_regen") && item[k+"_regen"]!=0:
			var value:= int(item[k+"_regen"])
			if value==0:
				continue
			if item[k+"_regen"]>0:
				text += tr(k.to_upper()+"_REGEN") + ": +" + str(value) + "\n"
			else:
				text += tr(k.to_upper()+"_REGEN") + ": -" + str(-value) + "\n"
	if item.has("resistance"):
		text += "resistance:\n"
		for k in item.resistance.keys():
			var value:= int(100*item.resistance[k])
			if value==0:
				continue
			if item.resistance[k]>=0.0:
				text += "  " + k + ": +" + str(value) + "%\n"
			else:
				text += "  " + k + ": -" + str(-value) + "%\n"
	if item.has("status"):
		text += tr("APPLIES_STATUS").format({"status":item.status.name}) + "\n  " + item.status.type + "\n"
		for k in item.status.keys():
			if k=="name" || k=="type":
				continue
			if k=="effect":
				if typeof(item.status.effect)==TYPE_ARRAY:
					text += "  " + tr("INCREASES") + " " + Names.make_list(item.status.effect) + "\n"
				else:
					text += "  " + tr("INCREASES") + " " + item.status.effect + "\n"
				continue
			if typeof(item.status[k])==TYPE_ARRAY:
				text += "  " + tr(k.to_upper()) + ": " + Names.make_list(item.status[k]) + "\n"
			else:
				text += "  " + tr(k.to_upper()) + ": " + str(int(item.status[k])) + "\n"
	if item.has("mod"):
		for k in item.mod.keys():
			if item.mod[k]>=0.0:
				text += tr(k.to_upper()) + ": +" + str(int(100*item.mod[k])) + "%\n"
			else:
				text += tr(k.to_upper()) + ": -" + str(-int(100*item.mod[k])) + "%\n"
	if item.has("add"):
		for k in item.add.keys():
			match typeof(item.add[k]):
				TYPE_INT, TYPE_FLOAT:
					var value:= int(item.add[k])
					if value!=0:
						if item.add[k]>=0.0:
							text += tr(k.to_upper()) + ": +" + str(value) + "\n"
						else:
							text += tr(k.to_upper()) + ": -" + str(-value) + "\n"
				TYPE_DICTIONARY:
					text += tr(k.to_upper()) + ":\n"
					for s in item.add[k].keys():
						var value: int
						var unit:= ""
						if k in ["damage", "resistance"]:
							value = int(100*item.add[k][s])
							unit = "%"
						else:
							value = int(item.add[k][s])
						if value==0:
							continue
						if item.add[k][s]>=0.0:
							text += "    " + tr(s.to_upper()) + ": +" + str(value) + unit + "\n"
						else:
							text += "    " + tr(s.to_upper()) + ": -" + str(-value) + unit + "\n"
	text += "price: " + str(int(item.price))
	return text


func merge_dicts(dict: Dictionary, add: Dictionary, multiplier:= 1.0) -> Dictionary:
	for k in add.keys():
		if k!="speed" && (typeof(add)==TYPE_INT || typeof(add)==TYPE_FLOAT):
			add[k] *= multiplier
		if dict.has(k):
			if typeof(dict[k])==TYPE_STRING:
				dict[k] = [dict[k],add[k]]
			elif typeof(add[k])==TYPE_DICTIONARY:
				merge_dicts(dict[k], add[k], multiplier)
			else:
				if typeof(dict[k])==TYPE_ARRAY && typeof(add[k])!=TYPE_ARRAY:
					dict[k].push_back(add[k])
				else:
					dict[k] += add[k]
		else:
			dict[k] = add[k]
	return dict

func pick_random_material(type: String) -> String:
	var valid:= []
	for k in MATERIALS.keys():
		if type in MATERIALS[k].tags:
			valid.push_back(k)
	if valid.size()>0:
		return valid.pick_random()
	return MATERIALS.keys().pick_random()

func create_material_list(components: Array) -> Array:
	var array:= []
	for type in components:
		array.push_back(EQUIPMENT_COMPONENTS[type].material)
	return array

func create_random_materials(list: Array, region: Dictionary, quality_mod:= 1.0) -> Array:
	var materials:= []
	for array in list:
		var type: String = array.pick_random()
		materials.push_back(create_regional_material(pick_random_material(type), region, quality_mod))
	return materials

func create_random_equipment(type: String, components: Array, region: Dictionary, info:= {}, tier:= 0, quality_mod:= 1.0, quality_bonus:= 0) -> Dictionary:
	var item: Dictionary
	var quality_scale:= 0.5 + 0.5*components.size()/(components.size() + tier)
	quality_mod *= quality_scale
	components = components.duplicate(true)
	for i in range(tier):
		components.push_back(EQUIPMENT_COMPONENTS.keys().pick_random())
	item = create_equipment(type, components, create_random_materials(create_material_list(components), region, quality_mod), info, quality_bonus)
	item.quality = int(item.quality/quality_scale)
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

func create_random_standard_equipment(type: String, region: Dictionary, tier:= 0, quality_mod:= 1.0, quality_bonus:= 0) -> Dictionary:
	var dict: Dictionary = EQUIPMENT_RECIPES[type].duplicate(true)
	dict.base_type = type
	return create_random_equipment(dict.type, dict.components, region, dict, tier, quality_mod, quality_bonus)

func create_randomized_equipment(type: String, slot: String, subtype: String, num_components: int, region: Dictionary, tier:= 0, quality_mod:= 1.0, quality_bonus:= 0) -> Dictionary:
	var item: Dictionary
	var valid:= []
	var components:= []
	var nm: String
	components.resize(num_components)
	for k in EQUIPMENT_COMPONENTS.keys():
		if EQUIPMENT_COMPONENTS[k].has("subtype") && EQUIPMENT_COMPONENTS[k].subtype==subtype:
			valid.push_back(k)
	if valid.size()>0:
		components[0] = valid.pick_random()
	for i in range(1, num_components):
		components[i] = EQUIPMENT_COMPONENTS.keys().pick_random()
	if randf()<0.5 && EQUIPMENT_SUBTYPE_NAME.has(subtype):
		nm = tr(EQUIPMENT_SUBTYPE_NAME[subtype].pick_random().to_upper()).capitalize()
	elif EQUIPMENT_TYPE_NAME.has(slot):
		nm = tr(EQUIPMENT_TYPE_NAME[slot].pick_random().to_upper()).capitalize()
	item = create_random_equipment(type, components, region, {"type":slot,"name":nm}, tier, quality_mod, quality_bonus)
	if slot=="weapon" && num_components>=4:
		item["2h"] = true
	return item

func create_equipment(type: String, components: Array, materials: Array, info:= {}, quality_bonus:= 0) -> Dictionary:
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
		var dict: Dictionary = EQUIPMENT_COMPONENTS[components[i]]
		var mat: Dictionary = materials[i]
		var quality: int = mat.quality + quality_bonus
		merge_dicts(item, dict, quality)
		if mat.has("add"):
			merge_dicts(item, mat.add)
		component_list.push_back(mat.name + " " + tr(components[i].to_upper()))
		item.quality += quality
		item.price += DEFAULT_MATERIAL_PRICE
	item.quality /= components.size()
	item.price *= (0.5 + 0.5*float(item.quality)/100.0*float(item.quality)/100.0)
	for i in range(materials.size()):
		var mat: Dictionary = materials[i]
		if !mat.has("mod"):
			continue
		for k in mat.mod.keys():
			if item.has(k):
				item[k] *= 1.0 + mat.mod[k]
	if EQUIPMENT_ATTRIBUTE_MULTIPLIER.has(type):
		var multiplier: float = EQUIPMENT_ATTRIBUTE_MULTIPLIER[type]
		for k in item.keys():
			if typeof(item[k])==TYPE_FLOAT:
				item[k] = int(round(multiplier*item[k]))
	else:
		for k in item.keys():
			if typeof(item[k])==TYPE_FLOAT:
				item[k] = int(round(item[k]))
	item.components = Names.make_list(component_list)
	item.erase("material")
	if materials.size()>0:
		var prefix: String = materials.pick_random().name
		if ' ' in prefix:
			if randf()<0.667:
				prefix = prefix.left(prefix.find(' '))
			else:
				var l:= prefix.find(' ', prefix.find(' ')+1)
				if l>0:
					prefix = prefix.left(l)
		item.name = prefix + " " + item.name
	item.name = sanitize_name(item.name)
	item.description = create_tooltip(item)
	return item

func craft_equipment(type: String, materials: Array, quality_bonus:= 0) -> Dictionary:
	var item: Dictionary
	var dict: Dictionary = EQUIPMENT_RECIPES[type].duplicate(true)
	dict.base_type = type
	item = create_equipment(dict.type, dict.components, materials, dict, quality_bonus)
	item.source = tr("CRAFTED_ITEM")
	item.description = create_tooltip(item)
	return item

func create_equipment_drop(creature: Dictionary) -> Dictionary:
	var item: Dictionary
	var quality:= 100
	var num_enchantments:= 0
	if creature.has("equipment_quality"):
		quality *= creature.equipment_quality
	item = create_random_standard_equipment(EQUIPMENT_RECIPES.keys().pick_random(), {"level":creature.level,"tier":creature.tier,"local_materials":DEFAULT_MATERIALS}, int(creature.tier*randf_range(0.25,0.75) + randf_range(0.0,0.5)), float(quality)/100.0)
	num_enchantments -= int(item.has("enchanted") && item.enchanted)
	if creature.has("equipment_enchantment_chance"):
		for i in range(3):
			if randf()<creature.equipment_enchantment_chance:
				num_enchantments += 1
	if num_enchantments > 0:
		for i in range(num_enchantments):
			item = enchant_equipment(item, ENCHANTMENTS.keys().pick_random(), int(quality*randf_range(0.75,1.25)))
	item.source = Story.sanitize_string(tr("DROPPED_BY").format({"creature":creature.name}))
	item.description = create_tooltip(item)
	return item

func create_legendary_equipment(type: String, level: int, quality:= 150) -> Dictionary:
	var item: Dictionary
	var add_quality:= 0
	var dict: Dictionary
	var scale:= (1.0 + 0.1*(level-1))*quality/100.0
	if !(EQUIPMENT_RECIPES.has("type")):
		type = EQUIPMENT_RECIPES.keys().pick_random()
	dict = get_artifact_name(type)
	if dict.has("quality"):
		add_quality = 100*dict.quality*(1.0 + 0.1*(level-1))
	item = create_random_standard_equipment(type, {"level":10+int(1.2*level),"tier":0,"local_materials":LEGENDARY_MATERIALS}, 2, 1.5, add_quality)
	for i in range(3):
		item = enchant_equipment(item, ENCHANTMENTS.keys().pick_random(), quality + add_quality + 10*level, str(i+1))
	item = merge_dicts(item, dict, scale)
	item.enchantment_potential = 0
	item.name = dict.name
	item.description = dict.description
	if dict.has("creator"):
		item.source = tr("ARTIFACT_BY_CREATOR").format({"creator":dict.creator}) + "\n"
		item.source += dict.description
	else:
		item.source = dict.description
	item.description = create_tooltip(item)
	return item

func create_material_drop(type: String, creature: Dictionary, add_data:= {}) -> Dictionary:
	var material: Dictionary = MATERIALS[type].duplicate(true)
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
				material.add[k] *= float(quality)/100.0
			TYPE_INT:
				material.add[k] = int(material.add[k]*quality/100)
			TYPE_DICTIONARY:
				for c in material.add[k].keys():
					material.add[k][c] *= float(quality)/100.0
	material.price = int(ceil(material.price*(0.5 + float(quality)/100.0*float(quality)/100.0)))
	material.source = Story.sanitize_string(tr("DROPPED_BY").format({"creature":creature.name}))
	material.description = create_tooltip(material)
	return material

func create_regional_material(type: String, region: Dictionary, quality_mod:= 1.0) -> Dictionary:
	var material: Dictionary = MATERIALS[type].duplicate(true)
	var quality: int
	var named:= false
	var base_mat:= {}
	quality = int(get_creature_quality({"level":region.level, "tier":region.tier + randi_range(-1,1)})*quality_mod)
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
		material.name = sanitize_name(material.name.pick_random().format({"base_name":base_mat.name,"name_prefix":base_mat.name})).capitalize()
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
			if typeof(material.add[s])==TYPE_INT:
				material.add[s] = int(material.add[s]*quality/100)
			elif typeof(material.add[s])==TYPE_FLOAT:
				material.add[s] *= float(quality)/100.0
	
	if !named:
		var dict: Dictionary = DEFAULT_MATERIAL_TYPES.pick_random()
		material.name = sanitize_name(material.name.pick_random().format({"base_name":dict.name,"name_prefix":dict.name})).capitalize()
	material.price = int(material.price*(0.5 + 0.5*float(quality)/100.0*float(quality)/100.0))
	material.quality = quality
	material.description = create_tooltip(material)
	return material

func create_soul_stone_drop(creature: Dictionary) -> Dictionary:
	var tier: int = min(creature.soul_rarity + randi_range(-1, 1) + 2, SOUL_STONES.size())
	var type: String = SOUL_STONES[tier]
	return create_material_drop(type, creature, creature.soul_add)


func enchant_equipment_material(item: Dictionary, enchantment_type: String, materials: Array, quality_bonus:= 0, enchantment_slot:= "") -> Dictionary:
	var add_data:= {}
	for material in materials:
		if material.has("add"):
			merge_dicts(add_data, material.add)
	return enchant_equipment(item, enchantment_type, get_material_quality(materials) + quality_bonus, enchantment_slot, add_data)

func enchant_equipment(item: Dictionary, enchantment_type: String, quality: int, enchantment_slot:= "", add_data:= {}) -> Dictionary:
	var dict: Dictionary = ENCHANTMENTS[enchantment_type].duplicate(true)
	var scale:= float(quality)/100.0
	var total_quality:= quality
	var slot: String = dict.slot + enchantment_slot
	merge_dicts(dict, add_data)
	if item.has("enchantments") && item.enchantments.has(slot):
		if item.enchantments[slot].quality > quality:
			return item
		quality -= item.enchantments[slot].quality
		scale -= float(item.enchantments[slot].quality)/100.0
	for k in ATTRIBUTES:
		if dict.has(k):
			var value: int
			if k=="speed":
				value = ceil(dict[k])
			else:
				value = ceil(dict[k]*scale)
			if item.has(k):
				item[k] += value
			else:
				item[k] = value
	for k in Characters.DEFAULT_STATS.keys():
		if dict.has(k):
			var value: int = ceil(dict[k]*scale)
			if item.has(k):
				item[k] += value
			else:
				item[k] = value
	for k in Characters.RESOURCES:
		if dict.has(k):
			if item.has(k):
				item[k] += int(ceil(dict[k]*scale))
			else:
				item[k] = int(ceil(dict[k]*scale))
		if dict.has(k+"_regen"):
			if item.has(k+"_regen"):
				item[k+"_regen"] += int(ceil(dict[k+"_regen"]*scale))
			else:
				item[k+"_regen"] = int(ceil(dict[k+"_regen"]*scale))
	if dict.has("damage"):
		if item.has("damage"):
			for k in dict.damage.keys():
				if item.damage.has(k):
					item.damage[k] += dict.damage[k]*scale
				else:
					item.damage[k] = dict.damage[k]*scale
		else:
			item.damage = {}
			for k in dict.damage.keys():
				item.damage[k] = dict.damage[k]*scale
	if dict.has("resistance"):
		if item.has("resistance"):
			for k in dict.resistance.keys():
				if item.resistance.has(k):
					item.resistance[k] += dict.resistance[k]*scale
				else:
					item.resistance[k] = dict.resistance[k]*scale
		else:
			item.resistance = {}
			for k in dict.resistance.keys():
				item.resistance[k] = dict.resistance[k]*scale
	if item.name.length() < 25:
		if dict.has("prefix"):
			item.name = tr(dict.prefix.pick_random()) + " " + item.name
		elif dict.has("suffix"):
			item.name = item.name + " " + tr(dict.suffix.pick_random())
	item.price += int(ceil(dict.price*(0.75 + 0.25*float(quality)/100.0*float(quality)/100.0)))
	item.quality = (item.quality + total_quality)/2
	item.enchanted = true
	if !item.has("enchantments"):
		item.enchantments = {}
	item.enchantments[slot] = {
		"type":enchantment_type,
		"quality":total_quality,
	}
	if item.has("enchantment_potential"):
		item.enchantment_potential -= 1
	else:
		item.enchantment_potential = 0
	item.description = create_tooltip(item)
	return item


func craft_potion(type: String, materials: Array, quality_bonus:= 0) -> Dictionary:
	var item:= create_potion(type, materials.pick_random().name, get_material_quality(materials) + quality_bonus)
	item.source = tr("MADE_OUT_OF").format({"items":make_list(materials)})
	item.description = create_tooltip(item)
	return item

func create_potion(type: String, name_prefix: String, quality: int) -> Dictionary:
	var dict: Dictionary = POTIONS[type]
	var item:= {
		"name":sanitize_name(name_prefix+" "+dict.name).capitalize(),
		"type":dict.type,
		"effect":dict.effect,
		"quality":quality,
		"source":tr("UNKNOWN_ORIGIN"),
	}
	var scale:= float(quality)/100.0
	for k in dict.keys():
		if typeof(dict[k])==TYPE_INT:
			item[k] = int(ceil(scale*dict[k]))
		elif typeof(dict[k])==TYPE_FLOAT:
			item[k] = scale*dict[k]
	if dict.has("status"):
		item.status = dict.status.duplicate(true)
		for k in item.status.keys():
			if typeof(item.status[k])==TYPE_INT:
				item.status[k] = int(ceil(scale*item.status[k]))
			elif typeof(item.status[k])==TYPE_FLOAT:
				item.status[k] = scale*item.status[k]
	item.price = int(POTIONS[type].price*(0.5 + 0.5*float(quality)/100.0*float(quality)/100.0))
	return item


func cook(type: String, materials: Array, quality_bonus:= 0) -> Dictionary:
	var item:= create_food(type, materials.pick_random().name, get_material_quality(materials) + quality_bonus)
	item.description = create_tooltip(item)
	return item

func create_food(type: String, name_prefix: String, quality: int) -> Dictionary:
	var dict: Dictionary = FOOD[type]
	var item:= {
		"name":sanitize_name(name_prefix+" "+dict.name).capitalize(),
		"type":dict.type,
		"quality":quality,
	}
	var scale:= float(quality)/100.0
	for k in dict.keys():
		if typeof(dict[k])==TYPE_INT:
			item[k] = int(ceil(scale*dict[k]))
		elif typeof(dict[k])==TYPE_FLOAT:
			item[k] = scale*dict[k]
	if dict.has("status"):
		item.status = dict.status.duplicate(true)
		for k in item.status.keys():
			if k=="duration":
				continue
			if typeof(item.status[k])==TYPE_INT:
				item.status[k] = int(ceil(scale*item.status[k]))
			elif typeof(item.status[k])==TYPE_FLOAT:
				item.status[k] = scale*item.status[k]
	item.price = int(FOOD[type].price*(0.5 + 0.5*float(quality)/100.0*float(quality)/100.0))
	item.description = create_tooltip(item)
	return item


func sanitize_name(string: String) -> String:
	for s in string.split(" ", false):
		while string.find(s)!=string.rfind(s):
			var pos:= string.find(s)
			var pos2:= string.find(s, pos+s.length())
			string = string.substr(0, pos) + s + string.substr(pos2+s.length())
	return string


func get_artifact_name(type: String) -> Dictionary:
	var dict: Dictionary = EQUIPMENT_RECIPES[type]
	var stats:= {}
	@warning_ignore("shadowed_variable_base_class")
	var name: String = tr(type.to_upper()).capitalize()
	var base_name: String
	var rnd:= randf()
	var desc_dict:= {
		"description":[],
		"theme":[],
		"adjective":[],
		"material":[],
		"feature":[],
	}
	var format_dict:= {
		"base_name":name.to_lower(),
	}
	
	if rnd<0.3 && SPECIAL_ITEM_TYPE_NAME.has(type):
		base_name = SPECIAL_ITEM_TYPE_NAME[type].keys().pick_random()
		for k in desc_dict.keys():
			if SPECIAL_ITEM_TYPE_NAME[type][base_name].has(k):
				desc_dict[k] += SPECIAL_ITEM_TYPE_NAME[type][base_name][k]
	elif rnd<0.5:
		if dict.type=="weapon" || dict.type=="shield":
			base_name = SPECIAL_WEAPON_NAME.keys().pick_random()
			for k in desc_dict.keys():
				if SPECIAL_WEAPON_NAME[base_name].has(k):
					desc_dict[k] += SPECIAL_WEAPON_NAME[base_name][k]
		elif dict.type=="ring" || dict.type=="amulet" || dict.type=="earring" || dict.type=="bracelet":
			base_name = SPECIAL_JUWELERY_NAME.keys().pick_random()
			for k in desc_dict.keys():
				if SPECIAL_JUWELERY_NAME[base_name].has(k):
					desc_dict[k] += SPECIAL_JUWELERY_NAME[base_name][k]
		else:
			base_name = SPECIAL_ARMOUR_NAME.keys().pick_random()
			for k in desc_dict.keys():
				if SPECIAL_ARMOUR_NAME[base_name].has(k):
					desc_dict[k] += SPECIAL_ARMOUR_NAME[base_name][k]
	elif rnd<0.7:
		base_name = SPECIAL_ITEM_NAME.keys().pick_random()
		for k in desc_dict.keys():
			if SPECIAL_ITEM_NAME[base_name].has(k):
				desc_dict[k] += SPECIAL_ITEM_NAME[base_name][k]
	else:
		base_name = name
	format_dict.name = base_name.to_lower()
	rnd = randf()
	if rnd<0.125:
		stats.quality = 0.1
		var creator:= Names.get_archmage_name()
		if randf()<0.6:
			var prefix: String = creator+"'s " + MASTER_CRAFTER_ADJECTIVE.pick_random()
			name = name.capitalize() + ' "' + prefix.capitalize() + " " + base_name.capitalize() + '"'
		else:
			var prefix: String = creator+"'s "
			var suffix: String = SPECIAL_ITEM_SUFFIX.keys().pick_random()
			name = name.capitalize() + ' "' + prefix.capitalize() + " " + base_name.capitalize() + " " + suffix + '"'
			for k in desc_dict.keys():
				if SPECIAL_ITEM_SUFFIX[suffix].has(k):
					desc_dict[k] += SPECIAL_ITEM_SUFFIX[suffix][k]
		stats.creator = creator
	elif rnd<0.2:
		var prefix: String = Story.TITLE_PREFIX.pick_random()
		var theme: String = Story.THEME.pick_random().replace("the ","")
		stats.quality = 0.1
		name = name.capitalize() + " " + tr("OF") + " " + tr("THE") + " " + Story.format_string(prefix + " " + theme)
		desc_dict.adjective.push_back(prefix.to_lower())
		desc_dict.theme.push_back(theme.to_lower())
	elif rnd<0.65:
		var prefix: String = SPECIAL_ITEM_PREFIX.keys().pick_random()
		var iter:= 0
		while base_name.similarity(prefix)>0.5:
			prefix = SPECIAL_ITEM_PREFIX.keys().pick_random()
			iter += 1
			if iter>10:
				break
		stats = SPECIAL_ITEM_PREFIX[prefix].duplicate()
		for k in desc_dict.keys():
				if SPECIAL_ITEM_PREFIX[prefix].has(k):
					desc_dict[k] += SPECIAL_ITEM_PREFIX[prefix][k]
		name = name.capitalize() + ' "The ' + prefix.capitalize() + " " + base_name.capitalize() + '"'
	else:
		var suffix: String = SPECIAL_ITEM_SUFFIX.keys().pick_random()
		var iter:= 0
		while base_name.similarity(suffix.to_lower())>0.5:
			suffix = SPECIAL_ITEM_SUFFIX.keys().pick_random()
			iter += 1
			if iter>10:
				break
		stats = SPECIAL_ITEM_SUFFIX[suffix].duplicate()
		for k in desc_dict.keys():
				if SPECIAL_ITEM_SUFFIX[suffix].has(k):
					desc_dict[k] += SPECIAL_ITEM_SUFFIX[suffix][k]
		name = name.capitalize() + ' "The ' + base_name.capitalize() + " " + suffix + '"'
	stats.name = name
	
	if desc_dict.description.size()==0 || randf()<0.1:
		desc_dict.description.push_back(Names.ARTIFACT_DESCRIPTIONS.pick_random())
	desc_dict.description = desc_dict.description.pick_random()
	if desc_dict.theme.size()==0:
		var counter:= 0
		var theme: String = Story.THEME.pick_random().to_lower()
		while theme.similarity(desc_dict.description.to_lower())*desc_dict.description.length()/theme.length()>0.75:
			theme = Story.THEME.pick_random().to_lower()
			counter += 1
			if counter>10:
				break
		format_dict.theme = theme
	else:
		var counter:= 0
		var theme: String = desc_dict.theme.pick_random()
		while theme.similarity(desc_dict.description.to_lower())*desc_dict.description.length()/theme.length()>0.75:
			theme = desc_dict.theme.pick_random()
			counter += 1
			if counter>10:
				theme = Story.THEME.pick_random().to_lower()
				break
		format_dict.theme = theme
	if desc_dict.adjective.size()==0:
		var counter:= 0
		var adjective: String = Story.TITLE_PREFIX.pick_random().to_lower()
		while adjective.similarity(desc_dict.description.to_lower())*desc_dict.description.length()/adjective.length()>0.75 || adjective.similarity(format_dict.theme)>0.5:
			adjective = Story.TITLE_PREFIX.pick_random().to_lower()
			counter += 1
			if counter>10:
				break
		format_dict.adjective = adjective
	else:
		var counter:= 0
		var adjective: String = desc_dict.adjective.pick_random()
		while adjective.similarity(desc_dict.description.to_lower())*desc_dict.description.length()/adjective.length()>0.75 || adjective.similarity(format_dict.theme)>0.5:
			adjective = desc_dict.adjective.pick_random()
			counter += 1
			if counter>10:
				adjective = Story.TITLE_PREFIX.pick_random().to_lower()
				break
		format_dict.adjective = adjective
	if desc_dict.feature.size()==0:
		format_dict.feature = format_dict.base_name
	else:
		var counter:= 0
		var feature: String = desc_dict.feature.pick_random()
		while feature.similarity(desc_dict.description.to_lower())*desc_dict.description.length()/feature.length()>0.75 || feature.similarity(format_dict.theme)>0.5 || feature.similarity(format_dict.adjective)>0.5:
			feature = desc_dict.feature.pick_random()
			counter += 1
			if counter>10:
				feature = format_dict.base_name
				break
		format_dict.feature = feature
	if desc_dict.material.size()==0:
		format_dict.material = Names.MATERIALS.pick_random()
	else:
		format_dict.material = desc_dict.material.pick_random()
	stats.description = Story.sanitize_string(Story.format_string(Story.sanitize_string(desc_dict.description.format(format_dict))))
	stats.description[0] = stats.description[0].to_upper()
	return stats


func _set_enchantment_by_slot():
	enchantments_by_slot.minor = []
	enchantments_by_slot.greater = []
	for type in ENCHANTMENTS.keys():
		if ENCHANTMENTS[type].has("slot"):
			enchantments_by_slot[ENCHANTMENTS[type].slot].push_back(type)

func _ready():
	_set_enchantment_by_slot()
