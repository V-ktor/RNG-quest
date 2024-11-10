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
const EQUIPMENT_COMPONENTS = {
	"knife": {
		"subtype": "melee",
		"attack":3,
		"penetration":4,
		"damage_type": "piercing",
		"material":["metal", "bone"],
	},
	"blade": {
		"subtype": "melee",
		"attack":6,
		"damage_type": "cutting",
		"material":["metal", "bone"],
	},
	"pole": {
		"subtype": "melee",
		"attack":4,
		"accuracy":2,
		"damage_type": "impact",
		"material":["wood", "stone", "metal"],
	},
	"whip": {
		"subtype": "melee",
		"attack":4,
		"accuracy":1,
		"penetration":2,
		"damage_type": "impact",
		"material":["leather"],
	},
	"chain_saw": {
		"subtype": "melee",
		"attack":4,
		"penetration":2,
		"damage_type": "cutting",
		"material":["metal"],
	},
	
	"hilt": {
		"attack":4,
		"accuracy":2,
		"material":["wood", "stone", "leather"],
	},
	"shaft": {
		"attack":2,
		"accuracy":2,
		"evasion":2,
		"material":["wood", "stone", "metal"],
	},
	
	"gem": {
		"subtype": "magic",
		"magic":6,
		"material":["gem", "magical"],
	},
	"formula": {
		"subtype": "magic",
		"magic":4,
		"willpower":2,
		"material":["paper", "leather"],
	},
	"orb": {
		"subtype": "magic",
		"magic":2,
		"willpower":4,
		"material":["gem", "elemental"],
	},
	
	"string": {
		"subtype": "ranged",
		"attack":6,
		"damage_type": "piercing",
		"material":["leather"],
	},
	"bow": {
		"subtype": "ranged",
		"attack":5,
		"accuracy":1,
		"damage_type": "piercing",
		"material":["wood"],
	},
	"loader": {
		"subtype": "ranged",
		"attack":8,
		"accuracy":3,
		"speed":-1,
		"material":["wood", "metal"],
	},
	"barrel": {
		"subtype": "ranged",
		"attack":4,
		"accuracy":2,
		"damage_type": "impact",
		"material":["metal", "stone"],
	},
	
	"cloth_armour": {
		"subtype": "light",
		"armour":1,
		"evasion":3,
		"mana":10,
		"material":["cloth"],
	},
	"leather_armour": {
		"subtype": "medium",
		"armour":3,
		"accuracy":1,
		"stamina":10,
		"material":["leather"],
	},
	"light_armour": {
		"subtype": "medium",
		"armour":4,
		"accuracy":1,
		"evasion":1,
		"material":["wood", "paper"],
	},
	"chain_armour": {
		"subtype": "heavy",
		"armour":6,
		"accuracy":-2,
		"evasion":-2,
		"health":10,
		"stamina":10,
		"material":["metal"],
	},
	"plate_armour": {
		"subtype": "heavy",
		"armour":9,
		"accuracy":-2,
		"evasion":-2,
		"speed":-1,
		"health":15,
		"material":["metal"],
	},
	
	"rope_joints": {
		"subtype": "light",
		"magic":1,
		"willpower":1,
		"accuracy":2,
		"evasion":2,
		"material":["cloth"],
	},
	"leather_joints": {
		"subtype": "medium",
		"accuracy":3,
		"evasion":3,
		"material":["leather"],
	},
	"metal_joints": {
		"subtype": "heavy",
		"attack":1,
		"armour":3,
		"accuracy":1,
		"evasion":1,
		"material":["metal"],
	},
	
	"magical_coating": {
		"magic":3,
		"willpower":3,
		"material":["magical"],
	},
	"paint_coating": {
		"armour":1,
		"evasion":3,
		"accuracy":2,
		"material":["alchemy"],
	},
	"metal_coating": {
		"armour":4,
		"attack":2,
		"damage_type": "impact",
		"material":["metal"],
	},
	"glass_coating": {
		"accuracy":3,
		"evasion":3,
		"material":["sand"],
	},
	
	"rope_chain": {
		"magic":2,
		"stamina":10,
		"mana":10,
		"material":["cloth"],
	},
	"metal_chain": {
		"armour":2,
		"stamina":10,
		"mana":10,
		"material":["metal"],
	},
	"leather_strip": {
		"accuracy":2,
		"evasion":2,
		"health":10,
		"material":["leather"],
	},
	"metal_strip": {
		"attack":2,
		"accuracy":2,
		"evasion":2,
		"material":["metal"],
	},
	
}
const MATERIALS = {
	"slime": {
		"name":["{name_prefix} slime"],
		"tags":["liquid"],
		"attributes": {
			"adjective":["slimy"],
		},
		"price":5,
	},
	"condensate": {
		"name":["{base_name} condensate", "{name_prefix} condensate"],
		"tags":["liquid", "elemental"],
		"attributes": {
			"adjective":["slimy"],
		},
		"add": {
			"willpower":0.5,
		},
		"price":10,
	},
	"residue": {
		"name":["{base_name} residue", "{name_prefix} residue"],
		"tags":["liquid", "magical"],
		"attributes": {
			"adjective":["slimy"],
		},
		"add": {
			"magic":0.5,
		},
		"price":10,
	},
	"resin": {
		"name":["{name_prefix} resin"],
		"quality":1.1,
		"tags":["crafting", "magical"],
		"attributes": {
			"adjective":["slimy"],
		},
		"add": {
			"magic":0.5,
		},
		"price":15,
	},
	"plasma": {
		"name":["{base_name} plasma", "{name_prefix} plasma"],
		"quality":1.1,
		"tags":["liquid", "elemental"],
		"attributes": {
			"adjective":["slimy"],
		},
		"add": {
			"willpower":0.5,
		},
		"price":15,
	},
	"magic_salt": {
		"name":["{base_name} salt", "{name_prefix} salt"],
		"quality":1.1,
		"tags":["magical", "elemental", "cooking"],
		"attributes": {
			"adjective":["salty", "magical"],
		},
		"add": {
			"magic":0.5,
		},
		"price":15,
	},
	"dust": {
		"name":["{base_name} dust"],
		"tags":["magical"],
		"attributes": {
			"adjective":["dusty"],
		},
		"add": {
			"magic":0.5,
		},
		"price":10,
	},
	"oil": {
		"name":["{base_name} oil", "{name_prefix} oil"],
		"tags":["liquid", "elemental"],
		"attributes": {
			"adjective":["oily", "well-oiled"],
		},
		"add": {
			"attack":0.25,
			"magic":0.25,
		},
		"price":10,
	},
	"herb": {
		"name":["{base_name} herb"],
		"tags":["alchemy", "plant", "healing"],
		"attributes": {
			"adjective":["fresh", "herbal"],
		},
		"add": {
			"health":2.5,
		},
		"price":10,
	},
	"venom": {
		"name":["{base_name} venom"],
		"quality":1.1,
		"tags":["toxic", "alchemy"],
		"attributes": {
			"adjective":["toxic", "poisonous"],
		},
		"add": {
			"stamina":1.5,
			"mana":1.5,
		},
		"price":15,
	},
	"mold": {
		"name":["{base_name} mold"],
		"tags":["toxic", "alchemy"],
		"attributes": {
			"adjective":["moldy"],
		},
		"add": {
			"health":2.5,
		},
		"price":10,
	},
	"flower": {
		"name":["{base_name} flower"],
		"tags":["alchemy", "healing"],
		"attributes": {
			"adjective":["flowering", "floral"],
		},
		"add": {
			"health":2.5,
		},
		"price":10,
	},
	"moss": {
		"name":["{base_name} moss"],
		"quality":1.1,
		"tags":["alchemy", "healing", "toxic"],
		"attributes": {
			"adjective":["green", "mossy", "overgrown"],
		},
		"add": {
			"stamina":1.5,
			"mana":1.5,
		},
		"price":15,
	},
	"leaf": {
		"name":["{base_name} leaf"],
		"tags":["alchemy", "plant", "cooking"],
		"attributes": {
			"adjective":["fresh", "refreshing"],
		},
		"add": {
			"health":2.5,
		},
		"price":10,
	},
	"carrot": {
		"name":["{base_name} carrot"],
		"tags":["alchemy", "plant", "cooking"],
		"attributes": {
			"adjective":["fresh", "healthy", "orange"],
		},
		"add": {
			"health":2.5,
		},
		"price":10,
	},
	"root": {
		"name":["{base_name} root"],
		"quality":1.1,
		"tags":["alchemy", "plant", "cooking"],
		"attributes": {
			"adjective":["gnarly", "brown"],
		},
		"add": {
			"health":2.5,
		},
		"price":15,
	},
	"mushroom": {
		"name":["{base_name} mushroom"],
		"quality":1.1,
		"tags":["cooking", "alchemy", "poison"],
		"attributes": {
			"adjective":["poisonous", "healthy"],
		},
		"add": {
			"health":2.5,
		},
		"price":15,
	},
	"algae": {
		"name":["{base_name} algae"],
		"quality":1.1,
		"tags":["cooking", "plant"],
		"attributes": {
			"adjective":["salty", "sea green"],
		},
		"price":15,
	},
	"plankton": {
		"name":["{base_name} plankton"],
		"quality":1.1,
		"tags":["cooking", "alchemy"],
		"attributes": {
			"adjective":["salty", "sea green"],
		},
		"add": {
			"health":2.5,
		},
		"price":15,
	},
	"spice": {
		"name":["{base_name} spice"],
		"quality":1.1,
		"tags":["alchemy", "cooking"],
		"attributes": {
			"adjective":["spicy", "hot"],
		},
		"add": {
			"health":2.5,
		},
		"price":15,
	},
	"fruit": {
		"name":["{base_name} fruit"],
		"quality":1.1,
		"tags":["cooking", "plant"],
		"attributes": {
			"adjective":["fruity", "juicy"],
		},
		"price":15,
	},
	"berry": {
		"name":["{base_name} berry"],
		"quality":1.1,
		"tags":["alchemy", "cooking", "plant"],
		"attributes": {
			"adjective":["fruity", "juicy"],
		},
		"add": {
			"health":2.5,
		},
		"price":15,
	},
	"cabbage": {
		"name":["{base_name} cabbage"],
		"tags":["cooking", "plant"],
		"attributes": {
			"adjective":["fresh", "green"],
		},
		"price":10,
	},
	"bean": {
		"name":["{base_name} bean"],
		"quality":1.1,
		"tags":["cooking"],
		"attributes": {
			"adjective":["healthy", "brown", "white", "red"],
		},
		"price":15,
	},
	"pebble": {
		"name":["{base_name} pebble"],
		"tags":["stone"],
		"attributes": {
			"adjective":["rocky", "lithic", "stone"],
		},
		"add": {
			"armour":0.5,
		},
		"price":10,
	},
	"stone": {
		"name":["{base_name} stone", "{base_name} rock"],
		"quality":1.1,
		"tags":["stone"],
		"attributes": {
			"adjective":["rocky", "lithic", "stone"],
		},
		"add": {
			"armour":0.5,
		},
		"price":15,
	},
	"sand": {
		"name":["{base_name} sand"],
		"tags":["sand"],
		"attributes": {
			"adjective":["sandy", "yellow", "grey"],
		},
		"price":10,
	},
	"glass": {
		"name":["{base_name} glass"],
		"tags":["glass"],
		"attributes": {
			"adjective":["translucent", "glass"],
		},
		"add": {
			"penetration":0.75,
		},
		"price":10,
	},
	"gem": {
		"name":["{base_name} gem", "{base_name} crystal"],
		"tags":["gem"],
		"attributes": {
			"adjective":["expensive", "crystaline"],
		},
		"add": {
			"magic":0.5,
		},
		"price":10,
	},
	"jewel": {
		"name":["{base_name} jewel", "{base_name} gem stone"],
		"quality":1.1,
		"tags":["gem"],
		"attributes": {
			"adjective":["expensive", "crystaline"],
		},
		"add": {
			"magic":0.5,
		},
		"price":10,
	},
	"wood": {
		"name":["{base_name} wood"],
		"tags":["wood"],
		"attributes": {
			"adjective":["wooden"],
		},
		"add": {
			"accuracy":0.5,
		},
		"price":10,
	},
	"plank": {
		"name":["{base_name} plank"],
		"quality":1.1,
		"tags":["wood"],
		"attributes": {
			"adjective":["wooden"],
		},
		"add": {
			"accuracy":0.5,
		},
		"price":15,
	},
	"ore": {
		"name":["{base_name} ore"],
		"tags":["metal"],
		"attributes": {
			"adjective":["metallic"],
		},
		"add": {
			"attack":0.5,
		},
		"price":10,
	},
	"ingot": {
		"name":["{base_name} ingot"],
		"quality":1.1,
		"tags":["metal"],
		"attributes": {
			"adjective":["metallic"],
		},
		"add": {
			"attack":0.5,
		},
		"price":15,
	},
	"bar": {
		"name":["{base_name} bar"],
		"quality":1.1,
		"tags":["metal"],
		"attributes": {
			"adjective":["metallic"],
		},
		"add": {
			"attack":0.5,
		},
		"price":15,
	},
	"cog": {
		"name":["{base_name} cog"],
		"quality":1.1,
		"tags":["metal"],
		"attributes": {
			"adjective":["metallic"],
		},
		"add": {
			"attack":0.5,
		},
		"price":15,
	},
	"scrap": {
		"name":["{base_name} scrap"],
		"quality":0.9,
		"tags":["metal", "stone"],
		"attributes": {
			"adjective":["metallic", "rusty"],
		},
		"price":5,
	},
	"coin": {
		"name":["{base_name} coin"],
		"tags":["metal"],
		"attributes": {
			"adjective":["metallic"],
		},
		"add": {
			"armour":0.5,
		},
		"price":10,
	},
	"paper": {
		"name":["{base_name} paper"],
		"tags":["paper"],
		"attributes": {
			"adjective":["thin"],
		},
		"add": {
			"willpower":0.5,
		},
		"price":10,
	},
	"parchement": {
		"name":["{base_name} parchement"],
		"veggie_name":["{base_name} paper"],
		"tags":["paper"],
		"attributes": {
			"adjective":["thin", "parched"],
		},
		"add": {
			"magic":0.5,
		},
		"price":10,
	},
	"skin": {
		"name":["{base_name} skin"],
		"veggie_name":["{base_name} polymere"],
		"tags":["leather"],
		"attributes": {
			"adjective":["leather", "smooth"],
		},
		"add": {
			"accuracy":0.5,
		},
		"price":10,
	},
	"leather": {
		"name":["{base_name} leather"],
		"veggie_name":["{base_name} synthetic leather"],
		"quality":1.1,
		"tags":["leather"],
		"attributes": {
			"adjective":["leather", "robust"],
		},
		"add": {
			"accuracy":0.5,
		},
		"price":15,
	},
	"hide": {
		"name":["{base_name} hide"],
		"veggie_name":["{base_name} wool"],
		"quality":1.1,
		"tags":["leather", "cloth"],
		"attributes": {
			"adjective":["leather"],
		},
		"add": {
			"accuracy":0.5,
		},
		"price":15,
	},
	"synth_skin": {
		"name":["{base_name} synth skin"],
		"quality":1.1,
		"tags":["leather"],
		"attributes": {
			"adjective":["synthetic", "fake", "smooth"],
		},
		"add": {
			"accuracy":0.5,
		},
		"price":15,
	},
	"wing": {
		"name":["{base_name} wing"],
		"veggie_name":["{base_name} foil"],
		"tags":["leather", "alchemy"],
		"attributes": {
			"adjective":["smooth", "thin"],
		},
		"add": {
			"accuracy":0.5,
		},
		"price":10,
	},
	"fin": {
		"name":["{base_name} fin"],
		"veggie_name":["{base_name} synthetic leather"],
		"quality":1.1,
		"tags":["leather"],
		"attributes": {
			"adjective":["leather", "robust"],
		},
		"add": {
			"evasion":0.5,
		},
		"price":15,
	},
	"cotton": {
		"name":["{base_name} cotton"],
		"tags":["cloth"],
		"attributes": {
			"adjective":["cloth"],
		},
		"add": {
			"evasion":0.5,
		},
		"price":10,
	},
	"cloth": {
		"name":["{base_name} cloth"],
		"quality":1.1,
		"tags":["cloth"],
		"attributes": {
			"adjective":["woven"],
		},
		"add": {
			"evasion":0.5,
		},
		"price":15,
	},
	"silk": {
		"name":["{base_name} silk"],
		"quality":1.1,
		"tags":["cloth"],
		"attributes": {
			"adjective":["elegant"],
		},
		"add": {
			"evasion":0.5,
		},
		"price":15,
	},
	"foil": {
		"name":["{base_name} foil"],
		"tags":["cloth"],
		"attributes": {
			"adjective":["foil", "thin"],
		},
		"add": {
			"evasion":0.5,
		},
		"price":10,
	},
	"tissue": {
		"name":["{base_name} tissue"],
		"quality":1.1,
		"tags":["cloth"],
		"attributes": {
			"adjective":["cloth"],
		},
		"add": {
			"evasion":0.5,
		},
		"price":15,
	},
	"wrapping": {
		"name":["{base_name} wrapping"],
		"quality":1.1,
		"tags":["cloth"],
		"attributes": {
			"adjective":["wrapped"],
		},
		"add": {
			"evasion":0.5,
		},
		"price":10,
	},
	"fur": {
		"name":["{base_name} fur"],
		"veggie_name":["{base_name} polyester"],
		"tags":["cloth"],
		"attributes": {
			"adjective":["hairy", "furry"],
		},
		"add": {
			"evasion":0.5,
		},
		"price":10,
	},
	"scale": {
		"name":["{base_name} scale"],
		"veggie_name":["{base_name} plate"],
		"quality":1.1,
		"tags":["cloth", "leather"],
		"attributes": {
			"adjective":["shimmering", "smooth"],
		},
		"add": {
			"armour":0.5,
		},
		"price":15,
	},
	"feather": {
		"name":["{base_name} feather"],
		"tags":["cloth"],
		"attributes": {
			"adjective":["feathered"],
		},
		"add": {
			"evasion":0.5,
		},
		"price":10,
	},
	"hair": {
		"name":["{base_name} hair"],
		"tags":["cloth"],
		"attributes": {
			"adjective":["hairy"],
		},
		"add": {
			"evasion":0.5,
		},
		"price":10,
	},
	"tail": {
		"name":["{base_name} tail"],
		"veggie_name":["{base_name} cloth"],
		"quality":1.1,
		"tags":["cloth"],
		"attributes": {
			"adjective":["cloth"],
		},
		"add": {
			"evasion":0.5,
		},
		"price":15,
	},
	"tooth": {
		"name":["{base_name} tooth"],
		"veggie_name":["{base_name} ceramic"],
		"tags":["bone"],
		"attributes": {
			"adjective":["bony"],
		},
		"add": {
			"penetration":0.75,
		},
		"price":10,
	},
	"nail": {
		"name":["{base_name} nail"],
		"veggie_name":["{base_name} iron nail"],
		"tags":["bone"],
		"attributes": {
			"adjective":["hard"],
		},
		"add": {
			"penetration":0.75,
		},
		"price":10,
	},
	"claw": {
		"name":["{base_name} claw"],
		"veggie_name":["{base_name} ceramic"],
		"tags":["bone"],
		"attributes": {
			"adjective":["clawed"],
		},
		"add": {
			"penetration":0.75,
		},
		"price":10,
	},
	"shell": {
		"name":["{base_name} shell"],
		"veggie_name":["{base_name} lime"],
		"quality":1.1,
		"tags":["stone", "bone"],
		"attributes": {
			"adjective":["hard", "armoured"],
		},
		"add": {
			"armour":0.5,
		},
		"price":15,
	},
	"fang": {
		"name":["{base_name} fang"],
		"veggie_name":["{base_name} ceramic"],
		"quality":1.1,
		"tags":["bone"],
		"attributes": {
			"adjective":["fanged"],
		},
		"add": {
			"penetration":0.75,
		},
		"price":15,
	},
	"horn": {
		"name":["{base_name} horn"],
		"veggie_name":["{base_name} ceramic"],
		"quality":1.1,
		"tags":["bone"],
		"attributes": {
			"adjective":["hard", "thick"],
		},
		"add": {
			"penetration":0.75,
		},
		"price":15,
	},
	"bone": {
		"name":["{base_name} bone"],
		"veggie_name":["{base_name} ceramic"],
		"quality":1.1,
		"tags":["bone"],
		"attributes": {
			"adjective":["bone", "skeletal"],
		},
		"add": {
			"penetration":0.75,
		},
		"price":15,
	},
	"skull": {
		"name":["{base_name} skull"],
		"veggie_name":["{base_name} casing"],
		"quality":1.1,
		"tags":["bone"],
		"attributes": {
			"adjective":["bone", "hard"],
		},
		"add": {
			"armour":0.5,
		},
		"price":15,
	},
	"meat": {
		"name":["{base_name} meat"],
		"veggie_name":["{base_name} tofu"],
		"tags":["cooking", "meat"],
		"attributes": {
			"adjective":["meaty"],
		},
		"price":10,
	},
	"tongue": {
		"name":["{base_name} tongue"],
		"veggie_name":["{base_name} B12 pill"],
		"tags":["alchemy", "cooking", "meat"],
		"attributes": {
			"adjective":["meaty"],
		},
		"add": {
			"health":2.5,
		},
		"price":10,
	},
	"pincer": {
		"name":["{base_name} pincer"],
		"veggie_name":["{base_name} pea"],
		"quality":1.1,
		"tags":["alchemy", "cooking", "meat"],
		"attributes": {
			"adjective":["meaty"],
		},
		"add": {
			"health":2.5,
		},
		"price":15,
	},
	"insistine": {
		"name":["{base_name} insistine"],
		"veggie_name":["{base_name} soy"],
		"tags":["cooking", "alchemy", "meat"],
		"attributes": {
			"adjective":["meaty"],
		},
		"add": {
			"stamina":1.5,
			"mana":1.5,
		},
		"price":10,
	},
	"testicle": {
		"name":["{base_name} testicle"],
		"veggie_name":["{base_name} nut"],
		"tags":["cooking", "alchemy", "meat"],
		"attributes": {
			"adjective":["meaty"],
		},
		"add": {
			"stamina":1.5,
			"mana":1.5,
		},
		"price":10,
	},
	"ear": {
		"name":["{base_name} ear"],
		"veggie_name":["{base_name} poison"],
		"tags":["alchemy", "poison"],
		"attributes": {
			"adjective":["meaty", "poisonous"],
		},
		"add": {
			"stamina":1.5,
			"mana":1.5,
		},
		"price":10,
	},
	"eye_ball": {
		"name":["{base_name} eye ball"],
		"veggie_name":["{base_name} marble"],
		"quality":1.1,
		"tags":["alchemy", "gem"],
		"attributes": {
			"adjective":["meaty"],
		},
		"add": {
			"willpower":0.5,
		},
		"price":15,
	},
	"kidney": {
		"name":["{base_name} kidney"],
		"veggie_name":["{base_name} kidney bean"],
		"quality":1.1,
		"tags":["cooking", "meat"],
		"attributes": {
			"adjective":["meaty"],
		},
		"price":15,
	},
	"heart": {
		"name":["{base_name} heart"],
		"veggie_name":["{base_name} heartstone"],
		"quality":1.1,
		"tags":["alchemy", "meat", "gem"],
		"attributes": {
			"adjective":["meaty", "hearty"],
		},
		"add": {
			"willpower":0.5,
		},
		"price":15,
	},
	"battery": {
		"name":["{base_name} battery"],
		"quality":1.1,
		"tags":["alchemy"],
		"attributes": {
			"adjective":["acidic", "toxic", "metallic"],
		},
		"add": {
			"stamina":1.5,
			"mana":1.5,
		},
		"price":15,
	},
	"processing_unit": {
		"name":["{base_name} processing unit"],
		"quality":1.1,
		"tags":["gem"],
		"attributes": {
			"adjective":["metallic", "silicon"],
		},
		"add": {
			"magic":0.5,
		},
		"price":15,
	},
	"wires": {
		"name":["{base_name} wires"],
		"tags":["cloth"],
		"quality":1.1,
		"attributes": {
			"adjective":["metallic"],
		},
		"add": {
			"critical":0.6,
		},
		"price":15,
	},
	"ram_module": {
		"name":["{base_name} RAM module"],
		"quality":1.1,
		"tags":["gem"],
		"attributes": {
			"adjective":["metallic", "computational"],
		},
		"add": {
			"willpower":0.5,
		},
		"price":15,
	},
	
	"soul_splinter": {
		"name":["{soul_prefix} soul splinter", "soul splinter of {base_name}", "{soul_prefix} soul splinter of {base_name}"],
		"quality":0.6,
		"tags":["soul"],
		"price":2,
	},
	"soul_shard": {
		"name":["{soul_prefix} soul shard", "soul shard of {base_name}", "{soul_prefix} soul shard of {base_name}"],
		"quality":0.8,
		"tags":["soul"],
		"price":5,
	},
	"soul_stone": {
		"name":["{soul_prefix} soul stone", "soul stone of {base_name}", "{soul_prefix} soul stone of {base_name}"],
		"quality":1.0,
		"tags":["soul"],
		"price":10,
	},
	"soul_gem": {
		"name":["{soul_prefix} soul gem", "soul gem of {base_name}", "{soul_prefix} soul gem of {base_name}"],
		"quality":1.2,
		"tags":["soul"],
		"price":20,
	},
	"soul_jewel": {
		"name":["{soul_prefix} soul jewel", "soul jewel of {base_name}", "{soul_prefix} soul jewel of {base_name}"],
		"quality":1.4,
		"tags":["soul"],
		"price":30,
	},
	"soul_orb": {
		"name":["{soul_prefix} soul orb", "soul orb of {base_name}", "{soul_prefix} soul orb of {base_name}"],
		"quality":1.6,
		"tags":["soul"],
		"price":45,
	},
	
	"empty_soul_stone": {
		"name":["empty soul stone"],
		"quality":1.0,
		"tags":["cage"],
		"price":10,
	},
}
const EQUIPMENT_RECIPES = {
	"dagger": {
		"type": "weapon",
		"components":["knife", "hilt"],
		"icon": "dagger",
	},
	"sword": {
		"type": "weapon",
		"components":["blade", "hilt"],
		"icon": "sword",
	},
	"axe": {
		"type": "weapon",
		"components":["blade", "shaft"],
		"icon": "axe",
	},
	"mace": {
		"type": "weapon",
		"components":["metal_coating", "hilt"],
		"icon": "mace",
	},
	"whip": {
		"type": "weapon",
		"components":["whip", "shaft"],
		"icon": "whip",
	},
	"chain_saw": {
		"type": "weapon",
		"components":["chain_saw", "hilt"],
		"icon": "chain_saw",
	},
	"buckler": {
		"type": "weapon",
		"subtype": "shield",
		"components":["light_armour", "shaft"],
		"icon": "buckler",
	},
	"kite_shield": {
		"type": "weapon",
		"subtype": "shield",
		"components":["chain_armour", "shaft"],
		"icon": "kite_shield",
	},
	"tower_shield": {
		"type": "weapon",
		"subtype": "shield",
		"components":["plate_armour", "shaft"],
		"icon": "tower_shield",
	},
	
	"sling": {
		"type": "weapon",
		"components":["string", "shaft"],
		"icon": "sling",
	},
	"pistol": {
		"type": "weapon",
		"components":["barrel", "hilt"],
		"icon": "pistol",
	},
	
	"tome": {
		"type": "weapon",
		"components":["formula", "gem"],
		"icon": "tome",
	},
	"amplifier": {
		"type": "weapon",
		"components":["magical_coating", "gem"],
		"icon": "amplifier",
	},
	"orb": {
		"type": "weapon",
		"components":["magical_coating", "orb"],
		"icon": "orb",
	},
	"spellblade": {
		"type": "weapon",
		"components":["blade", "gem"],
		"icon": "spellblade",
	},
	
	"greatsword": {
		"type": "weapon",
		"2h":true,
		"components":["blade", "blade", "knife", "hilt"],
		"icon": "greatsword",
	},
	"greatmaul": {
		"type": "weapon",
		"2h":true,
		"components":["metal_coating", "metal_coating", "pole", "hilt"],
		"icon": "greatmaul",
	},
	"battleaxe": {
		"type": "weapon",
		"2h":true,
		"components":["blade", "blade", "pole", "shaft"],
		"icon": "battleaxe",
	},
	"spear": {
		"type": "weapon",
		"2h":true,
		"components":["knife", "pole", "pole", "shaft"],
		"icon": "spear",
	},
	"scythe": {
		"type": "weapon",
		"2h":true,
		"components":["blade", "pole", "pole", "hilt"],
		"icon": "scythe",
	},
	"morningstar": {
		"type": "weapon",
		"2h":true,
		"components":["metal_coating", "whip", "whip", "shaft"],
		"icon": "morningstar",
	},
	
	"bow": {
		"type": "weapon",
		"2h":true,
		"components":["string", "bow", "bow", "shaft"],
		"icon": "bow",
	},
	"crossbow": {
		"type": "weapon",
		"2h":true,
		"components":["string", "bow", "loader", "shaft"],
		"icon": "crossbow",
	},
	"blunderbuss": {
		"type": "weapon",
		"2h":true,
		"components":["barrel", "barrel", "loader", "hilt"],
		"icon": "blunderbuss",
	},
	"gun_blade": {
		"type": "weapon",
		"2h":true,
		"components":["knife", "barrel", "loader", "shaft"],
		"icon": "gunblade",
	},
	
	"quarterstaff": {
		"type": "weapon",
		"2h":true,
		"components":["gem", "pole", "pole", "shaft"],
		"icon": "quarterstaff",
	},
	"magestaff": {
		"type": "weapon",
		"2h":true,
		"components":["gem", "orb", "shaft", "shaft"],
		"icon": "magestaff",
	},
	
	"cloth_shirt": {
		"type": "torso",
		"name": "shirt",
		"components":["cloth_armour", "cloth_armour", "rope_joints", "magical_coating"],
	},
	"leather_chest": {
		"type": "torso",
		"components":["leather_armour", "leather_armour", "leather_joints", "paint_coating"],
	},
	"chain_cuirass": {
		"type": "torso",
		"components":["chain_armour", "chain_armour", "leather_joints", "metal_coating"],
	},
	"plate_cuirass": {
		"type": "torso",
		"components":["plate_armour", "plate_armour", "metal_joints", "metal_coating"],
	},
	
	"cloth_pants": {
		"type": "legs",
		"name": "pants",
		"components":["cloth_armour", "cloth_armour", "magical_coating"],
	},
	"leather_pants": {
		"type": "legs",
		"name": "pants",
		"components":["leather_armour", "leather_joints", "paint_coating"],
	},
	"chain_greaves": {
		"type": "legs",
		"components":["chain_armour", "chain_armour", "metal_coating"],
	},
	"plate_greaves": {
		"type": "legs",
		"components":["plate_armour", "metal_joints", "metal_coating"],
	},
	"panties": {
		"type": "legs",
		"components":["cloth_armour", "rope_joints", "magical_coating"],
	},
	
	"cloth_hat": {
		"type": "head",
		"name": "hat",
		"components":["cloth_armour", "magical_coating"],
	},
	"leather_hat": {
		"type": "head",
		"name": "hat",
		"components":["leather_armour", "paint_coating"],
	},
	"chain_coif": {
		"type": "head",
		"components":["chain_armour", "metal_coating"],
	},
	"plate_helm": {
		"type": "head",
		"components":["metal_joints", "metal_coating"],
	},
	"glasses": {
		"type": "head",
		"components":["metal_coating", "glass_coating"],
	},
	
	"cloth_sandals": {
		"type": "feet",
		"name": "sandals",
		"components":["cloth_armour", "rope_joints"],
	},
	"leather_boots": {
		"type": "feet",
		"name": "boots",
		"components":["leather_armour", "leather_joints"],
	},
	"chain_boots": {
		"type": "feet",
		"components":["chain_armour", "metal_joints"],
	},
	"plate_boots": {
		"type": "feet",
		"components":["metal_joints", "metal_coating"],
	},
	
	"cloth_sleeves": {
		"type": "hands",
		"name": "sleeves",
		"components":["cloth_armour", "rope_joints"],
	},
	"leather_gloves": {
		"type": "hands",
		"name": "gloves",
		"components":["leather_armour", "leather_joints"],
	},
	"chain_gauntlets": {
		"type": "hands",
		"components":["chain_armour", "metal_joints"],
	},
	"plate_gauntlets": {
		"type": "hands",
		"components":["metal_joints", "metal_coating"],
	},
	
	"rope_belt": {
		"type": "belt",
		"components":["cloth_armour", "rope_joints"],
	},
	"leather_belt": {
		"type": "belt",
		"components":["leather_armour", "leather_joints"],
	},
	"chain_belt": {
		"type": "belt",
		"components":["chain_armour", "metal_joints"],
	},
	
	"magical_cape": {
		"type": "cape",
		"name": "cape",
		"components":["cloth_armour", "magical_coating"],
	},
	"cloth_cape": {
		"type": "cape",
		"name": "cloak",
		"components":["cloth_armour", "paint_coating"],
	},
	"metal_cape": {
		"type": "cape",
		"name": "cape",
		"components":["chain_armour", "paint_coating"],
	},
	
	"rope_amulet": {
		"type": "amulet",
		"name": "amulet",
		"components":["rope_chain", "gem"],
	},
	"metal_amulet": {
		"type": "amulet",
		"name": "amulet",
		"components":["metal_chain", "orb"],
	},
	"leather_ring": {
		"type": "ring",
		"name": "ring",
		"components":["leather_strip"],
	},
	"metal_ring": {
		"type": "ring",
		"name": "ring",
		"components":["metal_strip"],
	},
	"metal_earring": {
		"type": "earring",
		"name": "earring",
		"components":["metal_strip"],
	},
	"gem_earring": {
		"type": "earring",
		"name": "earring",
		"components":["gem"],
	},
	"orb_earring": {
		"type": "earring",
		"name": "earring",
		"components":["orb"],
	},
	"metal_bracelet": {
		"type": "bracelet",
		"name": "bracelet",
		"components":["metal_chain"],
	},
	"wood_bracelet": {
		"type": "bracelet",
		"name": "bracelet",
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
const POTIONS = {
	"healing_salve": {
		"name": "healing salve",
		"type": "potion",
		"effect": "health",
		"status": {
			"type": "buff",
			"name": "healing",
			"health_regen": 500,
			"duration": 10.0,
		},
		"price": 10,
		"material_types":[["healing"]],
	},
	"healing_potion": {
		"name": "healing potion",
		"type": "potion",
		"effect": "health",
		"healing": 75,
		"price": 20,
		"material_types": [["healing"], ["liquid", "healing"]],
	},
	"bandage": {
		"name": "bandage",
		"type": "potion",
		"effect": "health",
		"status": {
			"type": "buff",
			"name": "healing",
			"health_regen": 200,
			"health": 20.0,
			"duration": 20.0,
		},
		"price": 10,
		"material_types": [["healing", "cloth", "leather"]],
	},
	"healing_infusion": {
		"name": "healing infusion",
		"type": "potion",
		"effect": "health",
		"healing": 75,
		"price": 20,
		"material_types": [["healing"], ["liquid", "healing"]],
	},
	"mana_salve": {
		"name": "mana salve",
		"type": "potion",
		"effect": "mana",
		"status": {
			"type": "buff",
			"name": "healing",
			"mana_regen":200,
			"duration":10.0,
		},
		"price":10,
		"material_types":[["magical"]],
	},
	"mana_potion": {
		"name": "mana potion",
		"type": "potion",
		"effect": "mana",
		"healing":75,
		"price":20,
		"material_types":[["magical"],["liquid", "magical"]],
	},
	"stamina_salve": {
		"name": "stamina salve",
		"type": "potion",
		"effect": "stamina",
		"status": {
			"type": "buff",
			"name": "healing",
			"stamina_regen":200,
			"duration":10.0,
		},
		"price":10,
		"material_types":[["elemental"]],
	},
	"stamina_potion": {
		"name": "stamina potion",
		"type": "potion",
		"effect": "stamina",
		"healing":75,
		"price":20,
		"material_types":[["elemental"],["liquid", "elemental"]],
	},
}
const FOOD = {
	"soup": {
		"name": "soup",
		"type": "food",
		"stamina":20,
		"status": {
			"type": "buff",
			"name": "regeneration",
			"health_regen":10,
			"duration":20*60,
		},
		"price":10,
		"material_types":[["cooking", "liquid"]],
	},
	"salad": {
		"name": "salad",
		"type": "food",
		"stamina":20,
		"status": {
			"type": "buff",
			"name": "agility",
			"effect":["accuracy", "evasion"],
			"effect_scale":3.0,
			"duration":20*60,
		},
		"price":10,
		"material_types":[["plant"]],
	},
	"sandwich": {
		"name": "sandwich",
		"type": "food",
		"stamina":40,
		"status": {
			"type": "buff",
			"name": "resilience",
			"effect":["armour", "willpower"],
			"effect_scale":6.0,
			"duration":20*60,
		},
		"price":20,
		"material_types":[["cooking"],["plant", "cooking"]],
	},
	"pizza": {
		"name": "pizza",
		"type": "food",
		"stamina":40,
		"status": {
			"type": "buff",
			"name": "vigor",
			"effect":["attack", "magic"],
			"effect_scale":5.5,
			"duration":20*60,
		},
		"price":20,
		"material_types":[["cooking"],["cooking"]],
	},
	"curry": {
		"name": "curry",
		"type": "food",
		"stamina":40,
		"status": {
			"type": "buff",
			"name": "vigor",
			"effect":["attack", "magic"],
			"effect_scale":5.5,
			"duration":20*60,
		},
		"price":20,
		"material_types":[["cooking"],["liquid", "cooking"]],
	},
	"tea": {
		"name": "tea",
		"type": "food",
		"stamina":40,
		"status": {
			"type": "buff",
			"name": "regeneration",
			"health_regen":10,
			"duration":20*60,
		},
		"price":20,
		"material_types":[["healing"],["plant", "healing"]],
	},
	"dessert": {
		"name": "dessert",
		"type": "food",
		"stamina":40,
		"status": {
			"type": "buff",
			"name": "joy",
			"effect":["willpower", "accuracy"],
			"effect_scale":6.0,
			"duration":20*60,
		},
		"price":20,
		"material_types":[["cooking"],["cooking"]],
	},
	"pudding": {
		"name": "pudding",
		"type": "food",
		"stamina":40,
		"status": {
			"type": "buff",
			"name": "joy",
			"effect":["speed"],
			"effect_scale":1.0,
			"duration":10*60,
		},
		"price":20,
		"material_types":[["cooking"],["liquid", "cooking"]],
	},
	"pot": {
		"name": "pot",
		"type": "food",
		"stamina":40,
		"status": {
			"type": "buff",
			"name": "satisfaction",
			"effect":["armour", "evasion"],
			"effect_scale":6.0,
			"duration":20*60,
		},
		"price":20,
		"material_types":[["cooking"],["cooking"]],
	},
	"mayonnaise": {
		"name": "mayonnaise",
		"type": "food",
		"stamina":30,
		"status": {
			"type": "buff",
			"name": "mayonnaise",
			"mana_regen":8,
			"stamina_regen":8,
			"duration":20*60,
		},
		"price":15,
		"material_types":[["cooking", "liquid"]],
	},
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

@onready
var Description:= $Description
@onready
var Enchantment:= $Enchantment


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

func format_damage_type(type: String) -> String:
	if type in Skills.DAMAGE_COLOR:
		return "[color=" + Skills.DAMAGE_COLOR[type] + "]" + tr(type.to_upper()) + "[/color]"
	return tr(type.to_upper())

func format_resource(type: String, add:= "") -> String:
	if type in Skills.RESOURCE_COLOR:
		return "[color=" + Skills.RESOURCE_COLOR[type] + "]" + tr(type.to_upper() + add) + "[/color]"
	if type.right(6)=="_regen":
		var t:= type.left(type.length()-6)
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
		if !item.has(k) || int(item[k])==0:
			continue
		if item[k]>0:
			text += tr(k.to_upper()) + ": +" + str(int(item[k])) + "\n"
		else:
			text += tr(k.to_upper()) + ": -" + str(-int(item[k])) + "\n"
	for k in Characters.DEFAULT_STATS.keys():
		if !item.has(k) || int(item[k])==0:
			continue
		if item[k]>0:
			text += tr(k.to_upper()) + ": +" + str(int(item[k])) + "\n"
		else:
			text += tr(k.to_upper()) + ": -" + str(-int(item[k])) + "\n"
	if item.has("healing"):
		text += tr("HEALING") + ": " + str(int(item.healing)) + " " + format_resource(item.effect) + "\n"
	if item.has("damage"):
		text += tr("DAMAGE") + ":\n"
		for k in item.damage.keys():
			var value:= int(100*item.damage[k])
			if value==0:
				continue
			if item.damage[k]>=0.0:
				text += "  " + format_damage_type(k) + ": +" + str(value) + "%\n"
			else:
				text += "  " + format_damage_type(k) + ": -" + str(-value) + "%\n"
	for k in Characters.RESOURCES:
		if item.has(k):
			if item[k]>=0:
				text += format_resource(k) + ": +" + str(int(item[k])) + "\n"
			else:
				text += format_resource(k) + ": -" + str(-int(item[k])) + "\n"
		if item.has(k+"_regen") && item[k+"_regen"]!=0:
			var value:= int(item[k+"_regen"])
			if value==0:
				continue
			if item[k+"_regen"]>0:
				text += format_resource(k, "_REGEN") + ": +" + str(value) + "\n"
			else:
				text += format_resource(k, "_REGEN") + ": -" + str(-value) + "\n"
	if item.has("resistance"):
		text += tr("RESISTANCE") + ":\n"
		for k in item.resistance.keys():
			var value:= int(100*item.resistance[k])
			if value==0:
				continue
			if item.resistance[k]>=0.0:
				text += "  " + format_damage_type(k) + ": +" + str(value) + "%\n"
			else:
				text += "  " + format_damage_type(k) + ": -" + str(-value) + "%\n"
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
				text += "  " + format_resource(k) + ": " + Names.make_list(item.status[k]) + "\n"
			else:
				text += "  " + format_resource(k) + ": " + str(int(item.status[k])) + "\n"
	if item.has("mod"):
		for k in item.mod.keys():
			if item.mod[k]>=0.0:
				text += format_resource(k) + ": +" + str(int(100*item.mod[k])) + "%\n"
			else:
				text += format_resource(k) + ": -" + str(-int(100*item.mod[k])) + "%\n"
	if item.has("add"):
		for k in item.add.keys():
			match typeof(item.add[k]):
				TYPE_INT, TYPE_FLOAT:
					var value:= int(item.add[k])
					if value!=0:
						if item.add[k]>=0.0:
							text += format_resource(k) + ": +" + str(value) + "\n"
						else:
							text += format_resource(k) + ": -" + str(-value) + "\n"
				TYPE_DICTIONARY:
					text += format_resource(k) + ":\n"
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
							text += "    " + format_damage_type(s) + ": +" + str(value) + unit + "\n"
						else:
							text += "    " + format_damage_type(s) + ": -" + str(-value) + unit + "\n"
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
	var text: String = format_item_name(item) + "\n" + item.type + "\n" + item.source + "\n\n" + tr("COMPONENTS") + ": "
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
	rank += int(log(1.0 + item.quality/100.0 + 0.1*item.quality/100.0 * item.quality/100.0))
	return min(rank, RANK_COLORS.size()-1)

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
	var item: Dictionary
	var dict: Dictionary = EQUIPMENT_RECIPES[type].duplicate(true)
	dict.base_type = type
	item = create_random_equipment(dict.type, dict.components, region, dict, tier, quality_mod, quality_bonus)
	item.recipe = type
	return item

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
	item = create_random_equipment(type, components, region, {"type":slot, "name":nm}, tier, quality_mod, quality_bonus)
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
		var mat_data:= {
			"name": mat.name.to_lower(),
			"attributes": {}
		}
		var comp_data:= {
#			"name": mat.name.to_lower(),
			"name": tr(components[i].to_upper()),
			"material": mat_data,
			"attributes": {}
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
	item.components = component_list
	item.erase("material")
	item.attributes = {}
	if item.name.right(1) == 's' and item.name.right(2) != "ss":
		item.attributes.plural = item.name.to_lower()
	else:
		item.attributes.singular = item.name.to_lower()
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
	item.description_plain = Skills.tooltip_remove_bb_code(item.description)
	item.story = create_description(item)
	item.component_description = create_component_tooltip(item)
	return item

func craft_equipment(type: String, materials: Array, quality_bonus:= 0) -> Dictionary:
	var item: Dictionary
	var dict: Dictionary = EQUIPMENT_RECIPES[type].duplicate(true)
	dict.base_type = type
	item = create_equipment(dict.type, dict.components, materials, dict, quality_bonus)
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
	var recipe: String = EQUIPMENT_RECIPES.keys().pick_random()
	if creature.has("equipment_quality"):
		quality *= creature.equipment_quality
	item = create_random_standard_equipment(recipe, {"level":creature.level, "tier":creature.tier, "local_materials":DEFAULT_MATERIALS}, int(creature.tier*randf_range(0.25,0.75) + randf_range(0.0,0.5)), float(quality)/100.0)
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
			item = enchant_equipment(item, enchantment, int(quality*randf_range(0.75,1.25)))
	item.source = Story.sanitize_string(tr("DROPPED_BY").format({"creature":creature.name}))
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
	#var scale:= (1.0 + 0.1 * (level - 1)) * quality / 100.0
	var creator: String
	var base_name: String
	if type not in EQUIPMENT_RECIPES:
		type = EQUIPMENT_RECIPES.keys().pick_random()
	item = create_random_standard_equipment(type, {"level": 10 + int(1.2 * level), "tier": 0, "local_materials": LEGENDARY_MATERIALS}, 2, 1.5, add_quality)
	if type in LEGENDARY_ITEM_NAME && randf() < 0.75:
		base_name = LEGENDARY_ITEM_NAME[type].pick_random().capitalize()
	else:
		base_name = item.base_type.capitalize()
	item.recipe = type
	item.name = base_name
	item = enchant_equipment(item, Enchantment.enchantments_by_tier_and_slot.legendary.minor.pick_random(), quality + add_quality + 10*level, "1")
	item = enchant_equipment(item, Enchantment.enchantments_by_tier_and_slot.legendary.greater.pick_random(), quality + add_quality + 10*level, "2")
	item.enchantment_potential = 0
	item.legendary = true
	
	item.card_set = Description.create_description_data(item, 6)
	
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
		Description.add_card(item.card_set, Description.create_card("science", {"singular": subject.to_lower(), "adjective": adjective.to_lower()}), Utils.get_closest_position(Vector2i(0, 0), item.card_set.keys()))
	else:
		creator = Names.create_name(Names.NAME_DATA.keys().pick_random(), randi_range(-1, 1))
	item.source = tr("ARTIFACT_BY_CREATOR").format({"creator": creator})
	
	for pos in item.card_set:
		if item.card_set[pos].type == "craftmanship":
			#item.card_set.erase(pos)
			item.card_set[pos].attributes.singular = creator
	Description.add_card(item.card_set, Description.create_card("theme"), Utils.get_closest_position(Vector2i(0, 0), item.card_set.keys()))
	Description.add_card(item.card_set, Description.create_card("craftmanship", {"singular": creator, "adjective": ["legendary", "epic"].pick_random(), "adverb": ["legendaryly", "masterfully"].pick_random(), "is_name": true}), Utils.get_closest_position(Vector2i(0, 0), item.card_set.keys()))
	
	item.description = create_tooltip(item)
	item.description_plain = Skills.tooltip_remove_bb_code(item.description)
	item.story = create_description(item)
	item.component_description = create_component_tooltip(item)
	return item

#func create_legendary_equipment_old(type: String, level: int, quality:= 150) -> Dictionary:
	#var item: Dictionary
	#var add_quality:= 0
	#var dict: Dictionary
	#var scale:= (1.0 + 0.1 * (level - 1)) * quality / 100.0
	#if type not in EQUIPMENT_RECIPES:
		#type = EQUIPMENT_RECIPES.keys().pick_random()
	#dict = get_artifact_name(type)
	#if dict.has("quality"):
		#add_quality = 100 * dict.quality * (1.0 + 0.1 * (level - 1))
	#item = create_random_standard_equipment(type, {"level": 10 + int(1.2 * level), "tier": 0, "local_materials": LEGENDARY_MATERIALS}, 2, 1.5, add_quality)
	#item.recipe = type
	#item = enchant_equipment(item, Enchantment.enchantments_by_tier_and_slot.legendary.minor.pick_random(), quality + add_quality + 10*level, "1")
	#item = enchant_equipment(item, Enchantment.enchantments_by_tier_and_slot.legendary.greater.pick_random(), quality + add_quality + 10*level, "2")
	#item = merge_dicts(item, dict, scale)
	#item.enchantment_potential = 0
	#item.name = dict.name
	#if dict.has("creator"):
		#item.source = tr("ARTIFACT_BY_CREATOR").format({"creator":dict.creator}) + "\n"
		#item.source += dict.description
	#else:
		#item.source = dict.description
	#item.description = create_tooltip(item)
	#item.description_plain = Skills.tooltip_remove_bb_code(item.description)
	#item.story = create_description(item)
	#item.component_description = create_component_tooltip(item)
	#item.legendary = true
	#return item

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
				if k in ["damage", "resistance"]:
					continue
				for c in material.add[k].keys():
					material.add[k][c] *= float(quality)/100.0
	material.price = int(ceil(material.price*(0.5 + float(quality)/100.0*float(quality)/100.0) + 0.25*float(material.add.size()>0)))
	material.source = Story.sanitize_string(tr("DROPPED_BY").format({"creature":creature.name}))
	material.description = create_tooltip(material)
	material.description_plain = Skills.tooltip_remove_bb_code(material.description)
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
		material.name = sanitize_name(material.name.pick_random().format({"base_name":base_mat.name, "name_prefix":base_mat.name})).capitalize()
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
		material.name = sanitize_name(material.name.pick_random().format({"base_name":dict.name, "name_prefix":dict.name})).capitalize()
	material.price = int(material.price*(0.5 + 0.5*float(quality)/100.0*float(quality)/100.0))
	material.quality = quality
	material.description = create_tooltip(material)
	material.description_plain = Skills.tooltip_remove_bb_code(material.description)
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
	var dict: Dictionary = Enchantment.enchantments[enchantment_type].duplicate(true)
	var scale:= float(quality)/100.0
	var total_quality:= quality
	var slot: String = dict.slot + enchantment_slot
	merge_dicts(dict, add_data)
	if "enchantments" in item && item.enchantments.has(slot):
		if item.enchantments[slot].quality > quality:
			return item
		quality -= item.enchantments[slot].quality
		scale -= float(item.enchantments[slot].quality)/100.0
	for k in ATTRIBUTES:
		if dict.has(k):
			var value: int
			if k=="speed":
				value = ceil(max(dict[k], 0.0))
			else:
				value = ceil(max(dict[k]*scale, 0.0))
			if item.has(k):
				item[k] += value
			else:
				item[k] = value
	for k in Characters.DEFAULT_STATS.keys():
		if dict.has(k):
			var value: int = ceil(max(dict[k]*scale, 0.0))
			if item.has(k):
				item[k] += value
			else:
				item[k] = value
	for k in Characters.RESOURCES:
		if dict.has(k):
			if item.has(k):
				item[k] += int(ceil(max(dict[k]*scale, 0.0)))
			else:
				item[k] = int(ceil(max(dict[k]*scale, 0.0)))
		if dict.has(k+"_regen"):
			if item.has(k+"_regen"):
				item[k+"_regen"] += int(ceil(dict[k+"_regen"]*scale))
			else:
				item[k+"_regen"] = int(ceil(dict[k+"_regen"]*scale))
	if dict.has("damage"):
		if item.has("damage"):
			for k in dict.damage.keys():
				if item.damage.has(k):
					item.damage[k] += dict.damage[k]*(sqrt(1.0 + scale) - 1.0)
				else:
					item.damage[k] = dict.damage[k]*(sqrt(1.0 + scale) - 1.0)
		else:
			item.damage = {}
			for k in dict.damage.keys():
				item.damage[k] = dict.damage[k]*scale
	if dict.has("resistance"):
		if item.has("resistance"):
			for k in dict.resistance.keys():
				if item.resistance.has(k):
					item.resistance[k] += dict.resistance[k]*(sqrt(1.0 + scale) - 1.0)
				else:
					item.resistance[k] = dict.resistance[k]*(sqrt(1.0 + scale) - 1.0)
		else:
			item.resistance = {}
			for k in dict.resistance.keys():
				item.resistance[k] = dict.resistance[k]*scale
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
	item.price += int(ceil(dict.price*(0.75 + 0.25*float(quality)/100.0*float(quality)/100.0)))
	item.quality = (item.quality + total_quality)/2
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


func craft_potion(type: String, materials: Array, quality_bonus:= 0) -> Dictionary:
	var item:= create_potion(type, materials.pick_random().name, get_material_quality(materials) + quality_bonus)
	item.source = tr("MADE_OUT_OF").format({"items":make_list(materials)})
	item.description = create_tooltip(item)
	item.description_plain = Skills.tooltip_remove_bb_code(item.description)
	return item

func create_potion(type: String, name_prefix: String, quality: int) -> Dictionary:
	var dict: Dictionary = POTIONS[type]
	var item:= {
		"name":sanitize_name(name_prefix + " " + dict.name).capitalize(),
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
	item.description_plain = Skills.tooltip_remove_bb_code(item.description)
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
	item.description_plain = Skills.tooltip_remove_bb_code(item.description)
	return item


func sanitize_name(string: String) -> String:
	for s in string.split(" ", false):
		while string.find(s)!=string.rfind(s):
			var pos:= string.find(s)
			var pos2:= string.find(s, pos+s.length())
			string = string.substr(0, pos) + s + string.substr(pos2+s.length())
	return string
