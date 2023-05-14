extends Node

const NUM_CITIES = 4
const NUM_LOCATIONS = 12
const STARTER_LOCATION_MATERIALS = {
	"wood":[
		{
			"name":"pine",
			"quality":0.75,
		},
		{
			"name":"birch",
			"quality":1.0,
		},
		{
			"name":"oak",
			"quality":1.25,
		},
	],
	"metal":[
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
			"quality":1.25,
		},
	],
	"leather":[
		{
			"name":"rough",
			"quality":0.75,
		},
		{
			"name":"wolf skin",
			"quality":1.0,
		},
		{
			"name":"reinforced",
			"quality":1.25,
		},
	],
	"cloth":[
		{
			"name":"wool",
			"quality":0.75,
		},
		{
			"name":"velvet",
			"quality":1.0,
		},
		{
			"name":"silk",
			"quality":1.25,
		},
	],
	"stone":[
		{
			"name":"rock",
			"quality":0.75,
		},
		{
			"name":"quartz",
			"quality":1.0,
		},
		{
			"name":"crystal",
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
			"quality":1.0,
		},
		{
			"name":"ruby",
			"quality":1.25,
		},
	],
	"alchemy":[
		{
			"name":"bitter",
			"quality":0.75,
		},
		{
			"name":"sweet",
			"quality":1.0,
		},
		{
			"name":"crimson",
			"quality":1.25,
		},
	],
	"cooking":[
		{
			"name":"bitter",
			"quality":0.75,
		},
		{
			"name":"green",
			"quality":1.0,
		},
		{
			"name":"juicy",
			"quality":1.25,
		},
	],
}
const BASE_LOCATION_MATERIALS = {
	"wood":[
		{
			"name":"pine",
			"quality":0.75,
		},
		{
			"name":"birch",
			"quality":1.0,
		},
		{
			"name":"oak",
			"quality":1.25,
		},
	],
	"metal":[
		{
			"name":"copper",
			"quality":0.75,
		},
		{
			"name":"iron",
			"quality":1.0,
		},
		{
			"name":"steel",
			"quality":1.25,
		},
	],
	"leather":[
		{
			"name":"rough",
			"quality":0.75,
		},
		{
			"name":"reinforced",
			"quality":1.0,
		},
		{
			"name":"troll hide",
			"quality":1.25,
		},
	],
	"cloth":[
		{
			"name":"wool",
			"quality":0.75,
		},
		{
			"name":"velvet",
			"quality":1.0,
		},
		{
			"name":"silk",
			"quality":1.25,
		},
	],
	"stone":[
		{
			"name":"rock",
			"quality":0.75,
		},
		{
			"name":"quartz",
			"quality":1.0,
		},
		{
			"name":"crystal",
			"quality":1.25,
		},
	],
	"gem":[
		{
			"name":"quartz",
			"quality":0.75,
		},
		{
			"name":"sapphire",
			"quality":1.0,
		},
		{
			"name":"ruby",
			"quality":1.25,
		},
	],
	"alchemy":[
		{
			"name":"sour",
			"quality":0.75,
		},
		{
			"name":"sweet",
			"quality":1.0,
		},
		{
			"name":"potent",
			"quality":1.25,
		},
	],
	"cooking":[
		{
			"name":"green",
			"quality":0.75,
		},
		{
			"name":"juicy",
			"quality":1.0,
		},
		{
			"name":"wine",
			"quality":1.25,
		},
	],
}
const ADVANCED_LOCATION_MATERIALS = {
	"wood":[
		{
			"name":"maple",
			"quality":0.75,
		},
		{
			"name":"oak",
			"quality":1.0,
		},
		{
			"name":"strong wood",
			"quality":1.25,
		},
	],
	"metal":[
		{
			"name":"tin",
			"quality":0.75,
		},
		{
			"name":"iron",
			"quality":1.0,
		},
		{
			"name":"titanium",
			"quality":1.25,
		},
	],
	"leather":[
		{
			"name":"rough",
			"quality":0.75,
		},
		{
			"name":"reinforced",
			"quality":1.0,
		},
		{
			"name":"beast hide",
			"quality":1.25,
		},
	],
	"cloth":[
		{
			"name":"wool",
			"quality":0.75,
		},
		{
			"name":"linen",
			"quality":1.0,
		},
		{
			"name":"silk",
			"quality":1.25,
		},
	],
	"stone":[
		{
			"name":"stone",
			"quality":0.75,
		},
		{
			"name":"rock",
			"quality":1.0,
		},
		{
			"name":"granite",
			"quality":1.25,
		},
	],
	"gem":[
		{
			"name":"quartz",
			"quality":0.75,
		},
		{
			"name":"garnet",
			"quality":1.0,
		},
		{
			"name":"diamond",
			"quality":1.25,
		},
	],
	"alchemy":[
		{
			"name":"rancid",
			"quality":0.75,
		},
		{
			"name":"bitter",
			"quality":1.0,
		},
		{
			"name":"potent",
			"quality":1.25,
		},
	],
	"cooking":[
		{
			"name":"dried",
			"quality":0.75,
		},
		{
			"name":"grape",
			"quality":1.0,
		},
		{
			"name":"ripe",
			"quality":1.25,
		},
	],
}
const HOT_LOCATION_MATERIALS = {
	"wood":[
		{
			"name":"charcoal",
			"quality":0.75,
		},
		{
			"name":"cactus",
			"quality":1.0,
		},
		{
			"name":"blaze",
			"quality":1.25,
		},
	],
	"metal":[
		{
			"name":"tin",
			"quality":0.75,
		},
		{
			"name":"corrundum",
			"quality":1.0,
		},
		{
			"name":"mercury",
			"quality":1.25,
		},
	],
	"leather":[
		{
			"name":"charred",
			"quality":0.75,
		},
		{
			"name":"leather",
			"quality":1.0,
		},
		{
			"name":"blaze hide",
			"quality":1.25,
		},
	],
	"cloth":[
		{
			"name":"wool",
			"quality":0.75,
		},
		{
			"name":"linen",
			"quality":1.0,
		},
		{
			"name":"aramid",
			"quality":1.25,
		},
	],
	"stone":[
		{
			"name":"lava",
			"quality":0.75,
		},
		{
			"name":"basalt",
			"quality":1.0,
		},
		{
			"name":"granite",
			"quality":1.25,
		},
	],
	"gem":[
		{
			"name":"hematite",
			"quality":0.75,
		},
		{
			"name":"ruby",
			"quality":1.0,
		},
		{
			"name":"diamond",
			"quality":1.25,
		},
	],
	"alchemy":[
		{
			"name":"charcoal",
			"quality":0.75,
		},
		{
			"name":"sour",
			"quality":1.0,
		},
		{
			"name":"blazing",
			"quality":1.25,
		},
	],
	"cooking":[
		{
			"name":"charcoal",
			"quality":0.75,
		},
		{
			"name":"dried",
			"quality":1.0,
		},
		{
			"name":"date",
			"quality":1.25,
		},
	],
}
const COLD_LOCATION_MATERIALS = {
	"wood":[
		{
			"name":"cedar",
			"quality":0.75,
		},
		{
			"name":"pine",
			"quality":1.0,
		},
		{
			"name":"frost wood",
			"quality":1.25,
		},
	],
	"metal":[
		{
			"name":"bronze",
			"quality":0.75,
		},
		{
			"name":"steel",
			"quality":1.0,
		},
		{
			"name":"silver",
			"quality":1.25,
		},
	],
	"leather":[
		{
			"name":"frozen hide",
			"quality":0.75,
		},
		{
			"name":"leather",
			"quality":1.0,
		},
		{
			"name":"frost leather",
			"quality":1.25,
		},
	],
	"cloth":[
		{
			"name":"linen",
			"quality":0.75,
		},
		{
			"name":"wool",
			"quality":1.0,
		},
		{
			"name":"polyester",
			"quality":1.25,
		},
	],
	"stone":[
		{
			"name":"graphite",
			"quality":0.75,
		},
		{
			"name":"rock",
			"quality":1.0,
		},
		{
			"name":"granite",
			"quality":1.25,
		},
	],
	"gem":[
		{
			"name":"quartz",
			"quality":0.75,
		},
		{
			"name":"sapphire",
			"quality":1.0,
		},
		{
			"name":"diamond",
			"quality":1.25,
		},
	],
	"alchemy":[
		{
			"name":"frostbearer",
			"quality":0.75,
		},
		{
			"name":"sour",
			"quality":1.0,
		},
		{
			"name":"cooling",
			"quality":1.25,
		},
	],
	"cooking":[
		{
			"name":"frozen",
			"quality":0.75,
		},
		{
			"name":"white",
			"quality":1.0,
		},
		{
			"name":"glacial",
			"quality":1.25,
		},
	],
}
const LEVITATING_LOCATION_MATERIALS = {
	"wood":[
		{
			"name":"maple",
			"quality":0.75,
		},
		{
			"name":"helium wood",
			"quality":1.0,
		},
		{
			"name":"redwood",
			"quality":1.25,
		},
	],
	"metal":[
		{
			"name":"bronze",
			"quality":0.75,
		},
		{
			"name":"aluminum",
			"quality":1.0,
		},
		{
			"name":"silver",
			"quality":1.25,
		},
	],
	"leather":[
		{
			"name":"floating hide",
			"quality":0.75,
		},
		{
			"name":"leather",
			"quality":1.0,
		},
		{
			"name":"harpy leather",
			"quality":1.25,
		},
	],
	"cloth":[
		{
			"name":"wool",
			"quality":0.75,
		},
		{
			"name":"linen",
			"quality":1.0,
		},
		{
			"name":"velvet",
			"quality":1.25,
		},
	],
	"stone":[
		{
			"name":"levitating",
			"quality":0.75,
		},
		{
			"name":"light rock",
			"quality":1.0,
		},
		{
			"name":"granite",
			"quality":1.25,
		},
	],
	"gem":[
		{
			"name":"glass",
			"quality":0.75,
		},
		{
			"name":"lapis lazuli",
			"quality":1.0,
		},
		{
			"name":"diamond",
			"quality":1.25,
		},
	],
	"alchemy":[
		{
			"name":"floaty",
			"quality":0.75,
		},
		{
			"name":"green",
			"quality":1.0,
		},
		{
			"name":"fresh",
			"quality":1.25,
		},
	],
	"cooking":[
		{
			"name":"floaty",
			"quality":0.75,
		},
		{
			"name":"green",
			"quality":1.0,
		},
		{
			"name":"aerial",
			"quality":1.25,
		},
	],
}
const ROBOTIC_LOCATION_MATERIALS = {
	"wood":[
		{
			"name":"cedar",
			"quality":0.75,
		},
		{
			"name":"oak",
			"quality":1.0,
		},
		{
			"name":"steelwood",
			"quality":1.25,
		},
	],
	"metal":[
		{
			"name":"aluminum",
			"quality":0.75,
		},
		{
			"name":"iron",
			"quality":1.0,
		},
		{
			"name":"titanium",
			"quality":1.25,
		},
	],
	"leather":[
		{
			"name":"leather",
			"quality":0.75,
		},
		{
			"name":"polymere",
			"quality":1.0,
		},
		{
			"name":"synth skin",
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
			"quality":1.0,
		},
		{
			"name":"aramid",
			"quality":1.25,
		},
	],
	"stone":[
		{
			"name":"scrap",
			"quality":0.75,
		},
		{
			"name":"graphite",
			"quality":1.0,
		},
		{
			"name":"granite",
			"quality":1.25,
		},
	],
	"gem":[
		{
			"name":"turquoise",
			"quality":0.75,
		},
		{
			"name":"garnet",
			"quality":1.0,
		},
		{
			"name":"sapphire",
			"quality":1.25,
		},
	],
	"alchemy":[
		{
			"name":"brown",
			"quality":0.75,
		},
		{
			"name":"iron",
			"quality":1.0,
		},
		{
			"name":"synthetic",
			"quality":1.25,
		},
	],
	"cooking":[
		{
			"name":"dried",
			"quality":0.75,
		},
		{
			"name":"rehydrated",
			"quality":1.0,
		},
		{
			"name":"artificial",
			"quality":1.25,
		},
	],
}
const NECROTIC_LOCATION_MATERIALS = {
	"wood":[
		{
			"name":"rotten",
			"quality":0.75,
		},
		{
			"name":"bamboo",
			"quality":1.0,
		},
		{
			"name":"white cedar",
			"quality":1.25,
		},
	],
	"metal":[
		{
			"name":"silicon",
			"quality":0.75,
		},
		{
			"name":"iron",
			"quality":1.0,
		},
		{
			"name":"shadow steel",
			"quality":1.25,
		},
	],
	"leather":[
		{
			"name":"rotten",
			"quality":0.75,
		},
		{
			"name":"rough",
			"quality":1.0,
		},
		{
			"name":"necrotic",
			"quality":1.25,
		},
	],
	"cloth":[
		{
			"name":"rotten",
			"quality":0.75,
		},
		{
			"name":"linen",
			"quality":1.0,
		},
		{
			"name":"black silk",
			"quality":1.25,
		},
	],
	"stone":[
		{
			"name":"graphite",
			"quality":0.75,
		},
		{
			"name":"ash",
			"quality":1.0,
		},
		{
			"name":"basalt",
			"quality":1.25,
		},
	],
	"gem":[
		{
			"name":"turquoise",
			"quality":0.75,
		},
		{
			"name":"black",
			"quality":1.0,
		},
		{
			"name":"hematite",
			"quality":1.25,
		},
	],
	"alchemy":[
		{
			"name":"rotten",
			"quality":0.75,
		},
		{
			"name":"necrotic",
			"quality":1.0,
		},
		{
			"name":"cleansing",
			"quality":1.25,
		},
	],
	"cooking":[
		{
			"name":"moldy",
			"quality":0.75,
		},
		{
			"name":"clean",
			"quality":1.0,
		},
		{
			"name":"wine",
			"quality":1.25,
		},
	],
}
const WATER_LOCATION_MATERIALS = {
	"wood":[
		{
			"name":"wet",
			"quality":0.75,
		},
		{
			"name":"hydro",
			"quality":1.0,
		},
		{
			"name":"aqua",
			"quality":1.25,
		},
	],
	"metal":[
		{
			"name":"tin",
			"quality":0.75,
		},
		{
			"name":"aqua",
			"quality":1.0,
		},
		{
			"name":"mercury",
			"quality":1.25,
		},
	],
	"leather":[
		{
			"name":"wet leather",
			"quality":0.75,
		},
		{
			"name":"leather",
			"quality":1.0,
		},
		{
			"name":"impregnated",
			"quality":1.25,
		},
	],
	"cloth":[
		{
			"name":"wool",
			"quality":0.75,
		},
		{
			"name":"linen",
			"quality":1.0,
		},
		{
			"name":"impregnated",
			"quality":1.25,
		},
	],
	"stone":[
		{
			"name":"aqua",
			"quality":0.75,
		},
		{
			"name":"basalt",
			"quality":1.0,
		},
		{
			"name":"granite",
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
			"quality":1.0,
		},
		{
			"name":"sapphire",
			"quality":1.25,
		},
	],
	"alchemy":[
		{
			"name":"plankton",
			"quality":0.75,
		},
		{
			"name":"salty",
			"quality":1.0,
		},
		{
			"name":"algae",
			"quality":1.25,
		},
	],
	"cooking":[
		{
			"name":"salty",
			"quality":0.75,
		},
		{
			"name":"hydro",
			"quality":1.0,
		},
		{
			"name":"algae",
			"quality":1.25,
		},
	],
}
const JUNGLE_LOCATION_MATERIALS = {
	"wood":[
		{
			"name":"pine",
			"quality":0.75,
		},
		{
			"name":"birch",
			"quality":1.0,
		},
		{
			"name":"oak",
			"quality":1.25,
		},
	],
	"metal":[
		{
			"name":"bronze",
			"quality":0.75,
		},
		{
			"name":"steel",
			"quality":1.0,
		},
		{
			"name":"shimmering steel",
			"quality":1.25,
		},
	],
	"leather":[
		{
			"name":"monkey hide",
			"quality":0.75,
		},
		{
			"name":"reinforced",
			"quality":1.0,
		},
		{
			"name":"impregnated",
			"quality":1.25,
		},
	],
	"cloth":[
		{
			"name":"cotton",
			"quality":0.75,
		},
		{
			"name":"linen",
			"quality":1.0,
		},
		{
			"name":"silk",
			"quality":1.25,
		},
	],
	"stone":[
		{
			"name":"clay",
			"quality":0.75,
		},
		{
			"name":"sandstone",
			"quality":1.0,
		},
		{
			"name":"granite",
			"quality":1.25,
		},
	],
	"gem":[
		{
			"name":"agate",
			"quality":0.75,
		},
		{
			"name":"emerald",
			"quality":1.0,
		},
		{
			"name":"diamond",
			"quality":1.25,
		},
	],
	"alchemy":[
		{
			"name":"liana",
			"quality":0.75,
		},
		{
			"name":"moss",
			"quality":1.0,
		},
		{
			"name":"orchid",
			"quality":1.25,
		},
	],
	"cooking":[
		{
			"name":"juicy",
			"quality":0.75,
		},
		{
			"name":"banana",
			"quality":1.0,
		},
		{
			"name":"orange",
			"quality":1.25,
		},
	],
}
const REGIONS = {
	"farmland":{
		"level":1,
		"tier":-1,
		"race":["human","halfling"],
		"base_name":[" meadows"," farmland"," planes"],
		"name_prefix":["idylic","peaceful","calm"],
		"enemies":["elemental","goblin","wolf","boar","plant"],
		"enemy_amount":[1,2],
		"city_name":[
			{
				"base":["town","ville","dale","post","tower"],
				"prefix":["spring","summer","autumn","flower","trading"],
			},
			{
				"base":[" town"," village"],
				"prefix":["peaceful","quite","prosperous"],
			},
		],
		"location_name":["river","cave","cavern","fields","hills","forest"],
		"location_prefix":["calm ","light flooded ","fresh ","green ","flat ","safe ","golden "],
		"location_enemies":{
			"river":["crab","wolf","boar"],
			"cave":["goblin","wolf","bat","spider","zombie"],
			"cavern":["goblin","bat","spider","zombie"],
			"forest":["elemental","wolf","boar","plant"],
		},
		"enchantment_chance":0.1,
		"resources":["herb","flower","fruit","carrot","wood","pebble","ore","cotton","cloth"],
		"location_resources":{
			"river":["herb","flower","wood","gem","pebble","cotton"],
			"cave":["stone","ore","gem"],
			"cavern":["herb","moss","stone","ore","gem","wood","mushroom"],
			"forest":["herb","fruit","wood","cotton","mushroom"],
		},
		"resource_chance":0.1,
		"resource_amount":[1,3],
		"local_materials":STARTER_LOCATION_MATERIALS,
	},
	"elven_forest":{
		"level":1,
		"tier":-1,
		"race":["elf"],
		"base_name":[" forest"," woods"],
		"name_prefix":["peaceful","calm","elven","bright"],
		"enemies":["elemental","goblin","wolf","boar","plant"],
		"enemy_amount":[1,2],
		"city_name":[
			{
				"base":["rise","fall","ville","dale","sanctum"],
				"prefix":["spring","summer","flower","leaf","wind"],
			},
		],
		"location_name":["river","clearing","cavern","fields","hills","forest"],
		"location_prefix":["calm ","deep","fresh ","green ","flat ","safe ","wood"],
		"location_enemies":{
			"river":["crab","wolf","boar"],
			"clearing":["goblin","wolf","boar"],
			"cavern":["goblin","bat","spider","zombie"],
			"forest":["elemental","wolf","boar","plant"],
		},
		"enchantment_chance":0.1,
		"resources":["herb","flower","fruit","berry","wood","plank","pebble","ore","cotton"],
		"location_resources":{
			"river":["herb","flower","wood","gem","pebble","cotton"],
			"clearing":["stone","wood","cotton"],
			"cavern":["herb","moss","stone","ore","gem","wood","mushroom"],
			"forest":["herb","moss","fruit","wood","cotton","mushroom"],
		},
		"resource_chance":0.1,
		"resource_amount":[1,3],
		"local_materials":STARTER_LOCATION_MATERIALS,
	},
	"dwarven_mine":{
		"level":1,
		"tier":-1,
		"race":["dwarf"],
		"base_name":["mine","fortress"],
		"name_prefix":["prosperous ","rich ","calm ","dwarven ","gold","silver","copper"],
		"enemies":["elemental","goblin","wolf","spider","plant"],
		"enemy_amount":[1,2],
		"city_name":[
			{
				"base":[" town","keep","dale","post"],
				"prefix":["ore","crystal","gem","rock","stone","rich"],
			},
		],
		"location_name":["river","cave","shaft","cavern","hills","forest"],
		"location_prefix":["calm ","illuminated ","mineral-rich ","crystal","deep","safe ","ore"],
		"location_enemies":{
			"river":["crab","wolf","elemental"],
			"cave":["goblin","wolf","bat","spider","zombie"],
			"shaft":["goblin","bat","spider","elemental"],
			"cavern":["goblin","bat","spider","zombie"],
			"forest":["elemental","wolf","boar","plant"],
		},
		"enchantment_chance":0.1,
		"resources":["herb","flower","fruit","root","wood","stone","ore","ingot","cotton"],
		"location_resources":{
			"river":["herb","flower","wood","gem","pebble","cotton"],
			"cave":["stone","ore","gem"],
			"shaft":["stone","ore","gem"],
			"cavern":["herb","moss","stone","ore","gem","wood","mushroom"],
			"forest":["herb","fruit","wood","cotton","mushroom"],
		},
		"resource_chance":0.1,
		"resource_amount":[1,3],
		"local_materials":STARTER_LOCATION_MATERIALS,
	},
	
	"troll_hills":{
		"level":8,
		"tier":0,
		"race":["halfling"],
		"base_name":["hills","plains"," outskirt"],
		"name_prefix":["troll","goblin","wild ","green "],
		"enemies":["golem","goblin","gnoll","wolf","spider"],
		"enemy_amount":[1,3],
		"city_name":[
			{
				"base":[" town","ville"," outpost"," farm"," farmland"],
				"prefix":["crop","sunset","mountain","green","quite "],
			},
			{
				"base":["town","farm","tower"],
				"prefix":["crop","gold","hill"],
			},
		],
		"location_name":["river","cave","fields","hills","hill"],
		"location_prefix":["green ","golden ","steep ","dangerous ","great ","troll","goblin"],
		"location_enemies":{
			"river":["crab","crab","elemental","troll","wolf","boar"],
			"cave":["goblin","goblin","hobgoblin","gnoll","elemental","bat","spider"],
			"hills":["goblin","hobgoblin","gnoll","troll","wolf","strong_wolf","bat"],
			"hill":["goblin","hobgoblin","gnoll","troll","wolf","strong_wolf","bat"],
		},
		"enchantment_chance":0.1,
		"resources":["herb","flower","fruit","cabbage","wood","pebble","ore","cotton","cloth"],
		"location_resources":{
			"river":["herb","flower","wood","gem","pebble"],
			"cave":["pebble","ore","ore","gem"],
			"fields":["herb","flower","fruit","wood","cotton","cabbage"],
		},
		"resource_chance":0.1,
		"resource_amount":[1,3],
		"local_materials":BASE_LOCATION_MATERIALS,
	},
	"wolf_forest":{
		"level":8,
		"tier":0,
		"race":["elf"],
		"base_name":["forest","woods"," woodland"],
		"name_prefix":["deep","wolf","haunted ","dark","cursed ","spirit","feral "],
		"enemies":["spirit","goblin","gnoll","wolf","strong_wolf","elemental_wolf","plant"],
		"enemy_amount":[1,3],
		"city_name":[
			{
				"base":["village","town","keep"],
				"prefix":["green ","deepwood","forest","leaf","elven "],
			},
			{
				"base":["ville","dale","post","keep"," outpost"],
				"prefix":["green","brightwood","deepwood","leaf"],
			},
		],
		"location_name":["river","cavern","hills","forest","woods"],
		"location_prefix":["green ","moss","dangerous ","great ","dark","witching ","haunted ","overgrown "],
		"location_enemies":{
			"river":["crab","crab","goblin","hobgoblin","wolf","elemental"],
			"cavern":["elemental","goblin","hobgoblin","gnoll","bat","spider"],
			"hills":["goblin","hobgoblin","gnoll","troll","wolf","strong_wolf","bat"],
		},
		"enchantment_chance":0.1,
		"resources":["herb","moss","fruit","wood","plank","pebble","ore","cotton"],
		"location_resources":{
			"river":["herb","flower","wood","gem","pebble"],
			"cavern":["herb","moss","pebble","ore","gem","mushroom"],
		},
		"resource_chance":0.1,
		"resource_amount":[1,3],
		"local_materials":BASE_LOCATION_MATERIALS,
	},
	"coast":{
		"level":8,
		"tier":0,
		"race":["human"],
		"base_name":[" coast"," shoals"," coastline"],
		"name_prefix":["blue","bright","golden","aquamarine","azur"],
		"enemies":["elemental","water_elemental","goblin","gnoll","crab","snap_turtle"],
		"enemy_amount":[1,3],
		"city_name":[
			{
				"base":["town","post","harbour"],
				"prefix":["golden ","trading","coast","pearl","dune","quite "],
			},
		],
		"location_name":["river","cavern","dunes","coast","shoal"],
		"location_prefix":["aquamarine","blue","golden ","dangerous ","sandy ","white","crab"],
		"location_enemies":{
			"river":["crab","crab","goblin","hobgoblin","wolf","elemental"],
			"cavern":["elemental","goblin","hobgoblin","gnoll","bat","spider"],
			"dunes":["goblin","hobgoblin","gnoll","troll","wolf","strong_wolf","bat"],
		},
		"enchantment_chance":0.1,
		"resources":["herb","flower","fruit","wood","pebble","shell","ore","cotton"],
		"location_resources":{
			"river":["herb","flower","wood","gem","pebble"],
			"cavern":["herb","pebble","ore","gem","mushroom"],
			"dunes":["pebble","shell","plank","cotton"],
		},
		"resource_chance":0.1,
		"resource_amount":[1,3],
		"local_materials":BASE_LOCATION_MATERIALS,
	},
	
	"capital":{
		"level":12,
		"tier":0,
		"race":["human"],
		"base_name":[" capital"," metropole"," cradle"],
		"name_prefix":["kingdom's","imperial","grand","humanity's"],
		"enemies":["elemental","bat","thug","guard"],
		"enemy_amount":[1,3],
		"city_name":[
			{
				"base":[" district"," market"," bazar"," gate"," bridge"," tower"],
				"prefix":["golden","trading","great","north","south","west","east","central","royal"],
			},
		],
		"location_name":["slums","outskirt","dungeon","graveyard","zone","alleyways"],
		"location_prefix":["dirty ","hell's ","forbidden ","locked down ","skull","cursed ","slum","infested ","dangerous "],
		"location_enemies":{
			"graveyard":["zombie","skeletton","ghoul","spirit","ghost"],
			"outskirts":["elemental","goblin","gnoll","boar","wolf","strong_wolf"],
			"dungeon":["elemental","goblin","gnoll","crab","bat","spider"],
		},
		"enchantment_chance":0.1,
		"resources":["flower","carrot","wood","pebble","ore","cotton","coin","scrap","paper"],
		"location_resources":{
			"outskirts":["herb","flower","moss","fruit","cabbage","carrot","wood","pebble","ore","cotton"],
		},
		"resource_chance":0.1,
		"resource_amount":[1,3],
		"local_materials":BASE_LOCATION_MATERIALS,
	},
	
	"wasteland":{
		"level":16,
		"tier":0,
		"race":["orc"],
		"base_name":[" wasteland"," badlands"],
		"name_prefix":["dry","barren","deadly","forgotten","molten","singed"],
		"enemies":["golem","scorpion","goblin","gnoll","drake","thug","skeletton"],
		"enemy_amount":[1,3],
		"city_name":[
			{
				"base":[" settlement"," outpost"," oasis"],
				"prefix":["barren","forgotten","run-down","dusty","hot"],
			},
			{
				"base":["post","well","town"],
				"prefix":["dry","singe","heat","pyre","cool"],
			},
		],
		"location_name":["canyon","cave","cavern","dunes","sands","oasis"],
		"location_prefix":["dangerous ","deadly ","dusty ","barren ","dried-up ","uncharted ","pyre","singed "],
		"location_enemies":{
			"oasis":["crab","gnoll","troll","thug","plant"],
			"cave":["elemental","zombie","ghoul","skeletton","bat","spider"],
		},
		"enchantment_chance":0.1,
		"resources":["wood","pebble","stone","ore","ingot","gem"],
		"location_resources":{
			"oasis":["herb","flower","carrot","root","wood","cotton"],
			"cave":["pebble","stone","ore","ingot","gem","mushroom"],
			"cavern":["pebble","moss","stone","ore","ingot","gem","mushroom"],
		},
		"resource_chance":0.1,
		"resource_amount":[1,4],
		"local_materials":HOT_LOCATION_MATERIALS,
	},
	"mountain_pass":{
		"level":16,
		"tier":0,
		"race":["human"],
		"base_name":["pass","road","hills"],
		"name_prefix":["mountain","frost","frozen ","glacier"],
		"enemies":["elemental","yeti","goblin","gnoll","drake","elemental_wolf"],
		"enemy_amount":[1,3],
		"city_name":[
			{
				"base":["settlement","inn"],
				"prefix":["frozen ","cozy ","winter","frost","warm "],
			},
			{
				"base":["keep","wall","well"],
				"prefix":["spring","winter","frost","rock"],
			},
		],
		"location_name":["cave","mountain","hills","plain","river","forest"],
		"location_prefix":["dangerous ","deadly ","frozen ","glacial ","glazier","white ","ice","frost","frostbite "],
		"location_enemies":{
			"river":["crab","gnoll","troll","thug","elemental_wolf"],
			"cave":["elemental","zombie","ghoul","skeletton","bat","spider"],
			"forest":["wolf","strong_wolf","elemental_wolf","boar","golem","troll","plant"],
		},
		"enchantment_chance":0.1,
		"resources":["carrot","wood","plank","pebble","ore","cotton","cloth","mushroom"],
		"location_resources":{
			"river":["herb","flower","cabbage","wood","cotton"],
			"cave":["pebble","stone","ore","ingot","gem","mushroom"],
			"forest":["flower","wood","plank","cotton","mushroom"],
		},
		"resource_chance":0.1,
		"resource_amount":[1,4],
		"local_materials":COLD_LOCATION_MATERIALS,
	},
	"swamp":{
		"level":16,
		"tier":0,
		"race":["elf","halfling"],
		"base_name":["swamp","badlands"],
		"name_prefix":["humid ","toxic ","poison","orcish ","polluted ","backwater"],
		"enemies":["elemental","zombie","ghoul","skeletton","orc","plant","snap_turtle"],
		"enemy_amount":[1,3],
		"city_name":[
			{
				"base":[" settlement"," outpost"," town"],
				"prefix":["cleansed","clean","ruined","run-down","wet"],
			},
			{
				"base":["post","keep","ruins"],
				"prefix":["poison","swamp","clearwater "],
			},
		],
		"location_name":["river","swamp","cavern","lake","forest"],
		"location_prefix":["dangerous ","deadly ","poisonous ","backwater","purple","dark","pulp"],
		"location_enemies":{
			"river":["crab","zombie","ghoul","skeletton","troll","orc"],
			"cave":["elemental","zombie","ghoul","skeletton","bat","spider"],
			"lake":["elemental","crab","zombie","ghoul","skeletton","orc","snap_turtle"],
		},
		"enchantment_chance":0.1,
		"resources":["flower","herb","cabbage","mushroom","root","wood","pebble","ore","cotton"],
		"location_resources":{
			"river":["herb","flower","cabbage","wood","cotton","pebble"],
			"cave":["pebble","stone","ore","ingot","gem","mushroom"],
			"forest":["moss","wood","plank","herb","mushroom","root"],
		},
		"resource_chance":0.1,
		"resource_amount":[1,4],
		"local_materials":NECROTIC_LOCATION_MATERIALS,
	},
	
	"levitating_islands":{
		"level":22,
		"tier":0,
		"race":["human","elf"],
		"base_name":[" sky islands"," rift"," islands"],
		"name_prefix":["floating","levitating","heavenly","cloudy"],
		"enemies":["elemental","drake","harpy","bat","elemental_wolf"],
		"enemy_amount":[2,3],
		"city_name":[
			{
				"base":["town","dale","ville"],
				"prefix":["sky","cloud","rise","rain","star"],
			},
			{
				"base":[" town"," tower"],
				"prefix":["skyward","floating","skybound","aerial"],
			},
		],
		"location_name":["river","lake","sea","island","rift","forest"],
		"location_prefix":["sky","cloud","foggy ","floating ","levitating ","rising ","skyward"],
		"location_enemies":{
			"river":["crab","elemental","golem","harpy","orc"],
			"lake":["crab","elemental","golem","harpy","orc","snap_turtle"],
			"sea":["crab","elemental","golem","harpy","orc","snap_turtle"],
		},
		"enchantment_chance":0.2,
		"resources":["flower","herb","cabbage","mushroom","root","wood","plank","pebble","ore","cotton","silk"],
		"location_resources":{
			"river":["herb","flower","wood","cotton","silk","pebble","stone"],
			"lake":["herb","flower","wood","cotton","silk","pebble","stone"],
			"sea":["herb","flower","wood","cotton","silk","pebble","stone"],
		},
		"resource_chance":0.1,
		"resource_amount":[1,4],
		"local_materials":LEVITATING_LOCATION_MATERIALS,
	},
	"robotic_land":{
		"level":22,
		"tier":0,
		"race":["human","halfling"],
		"base_name":[" lands"," wasteland"," zone"],
		"name_prefix":["robotic","nanite","nanite-infested","steel","rusted"],
		"enemies":["elemental","scorpion","nanite_slime","robot","drone","mech"],
		"enemy_amount":[2,3],
		"city_name":[
			{
				"base":["city","town","keep","fort","hold"],
				"prefix":["scrap","rust","steel","deviance","synth","steam"],
			},
		],
		"location_name":["river","forest","scrapyard","yard","field","pit","hive"],
		"location_prefix":["scrap","rust","iron","steel","titanium","nanite","robotic ","artificial "],
		"location_enemies":{},
		"enchantment_chance":0.2,
		"resources":["moss","herb","carrot","wood","pebble","stone","scrap","ore","ingot","cotton","silk","gem"],
		"location_resources":{},
		"resource_chance":0.1,
		"resource_amount":[1,4],
		"local_materials":ROBOTIC_LOCATION_MATERIALS,
	},
	"necrotic_land":{
		"level":22,
		"tier":0,
		"race":["human","elf","dwarf"],
		"base_name":[" lands"," wasteland"," netherland","area"],
		"name_prefix":["forbidden","necrotic","vampire","infested","undead","revenant"],
		"enemies":["shadow_elemental","zombie","ghoul","skeletton","vampire","spirit","ghost"],
		"enemy_amount":[2,3],
		"city_name":[
			{
				"base":["keep","fortress","hold"],
				"prefix":["crimson","shadow","blessed "],
			},
			{
				"base":["shelter","citadel","chapel","town"],
				"prefix":["holy ","unholy ","sacred ","last "],
			},
			{
				"base":["shelter","chapel","bastion"],
				"suffix":[" of Light"," of Life"," of the Savior"],
			},
		],
		"location_name":["river","woods","field","pit","mountains"],
		"location_prefix":["pitch black","infested","undead","necrotic","necromantic","deadly ","blood","crimson"],
		"location_enemies":{},
		"enchantment_chance":0.2,
		"resources":["mold","moss","mushroom","wood","pebble","ore","cotton","gem","jewel"],
		"location_resources":{},
		"resource_chance":0.1,
		"resource_amount":[1,4],
		"local_materials":NECROTIC_LOCATION_MATERIALS,
	},
	
	"vulcano":{
		"level":28,
		"tier":0,
		"race":["dwarf"],
		"base_name":[" vulcano"," plains"," scape"],
		"name_prefix":["heallfire","fearfire","demonic","ash"],
		"enemies":["golem","lava_elemental","scorpion","goblin","gnoll","imp","demon"],
		"enemy_amount":[1,4],
		"city_name":[
			{
				"base":[" settlement"," outpost"," village"],
				"prefix":["barren","forgotten","run-down","ash-covered"],
			},
			{
				"base":["keep","fortress","ville"],
				"prefix":["ash","fire","lava","magma"],
			},
		],
		"location_name":["canyon","cave","cavern","vulcano","sands","mountain"],
		"location_prefix":["dangerous ","deadly ","burning ","barren ","fiery ","ash","lava","pyre"],
		"enchantment_chance":0.25,
		"resources":["mushroom","flower","moss","wood","pebble","stone","ore","ingot","gem","jewel"],
		"location_resources":{},
		"resource_chance":0.1,
		"resource_amount":[2,4],
		"local_materials":HOT_LOCATION_MATERIALS,
	},
	"deep_sea":{
		"level":28,
		"tier":0,
		"race":["halfling"],
		"base_name":[" sea"," ocean"," depths"],
		"name_prefix":["deep","dark","blue","azur"],
		"enemies":["golem","water_elemental","water_snake","snap_turtle","gnoll","imp"],
		"enemy_amount":[1,4],
		"city_name":[
			{
				"base":["bottom","post","keep"," city"],
				"prefix":["flood","rock","sea","salt","azur"],
			},
		],
		"location_name":["cave","cavern","beach","ground","sea","ocean"],
		"location_prefix":["under-water ","flooded ","deep ","rockbed","sea","salt","azur"],
		"enchantment_chance":0.25,
		"resources":["algae","plankton","moss","shell","wood","plank","pebble","stone","ore","gem","jewel"],
		"location_resources":{},
		"resource_chance":0.1,
		"resource_amount":[2,4],
		"local_materials":WATER_LOCATION_MATERIALS,
	},
	"jungle":{
		"level":28,
		"tier":0,
		"race":["human"],
		"base_name":[" jungle"," wilderness"],
		"name_prefix":["deep","dark","feral","untamed"],
		"enemies":["tiger","mud_slime","snake","harpy","gnoll","imp"],
		"enemy_amount":[1,4],
		"city_name":[
			{
				"base":["town"," city"," settlement","tower","camp"],
				"prefix":["jungle","mud","rain","rainy ","expedition "],
			},
		],
		"location_name":["cavern","forest","woods","thicket"," treetop","hills"],
		"location_prefix":["rainy","rain","wet ","green ","dark ","snake","ant"],
		"enchantment_chance":0.25,
		"resources":["leaf","moss","flower","root","carrot","wood","plank","pebble","stone","ore","gem","jewel"],
		"location_resources":{},
		"resource_chance":0.1,
		"resource_amount":[2,4],
		"local_materials":JUNGLE_LOCATION_MATERIALS,
	},
	
}

var regions:= {}


func get_region_description(region: Dictionary) -> String:
	var text: String = region.name
	if region.race.size()>0:
		text += "\n" + tr("RACE") + ": " + Names.make_list(region.race)
	text += "\n" + tr("CITIES") + ":"
	for c in region.cities:
		text += "\n  " + c
	text += "\n" + tr("LOCATIONS") + ":"
	for l in region.locations:
		text += "\n  " + l
	return text

func get_city_name(array: Array) -> String:
	var name_dict: Dictionary = array.pick_random()
	var city_name: String = name_dict.base.pick_random()
	if name_dict.has("prefix"):
		var city_prefix: String = name_dict.prefix.pick_random()
		if city_prefix[city_prefix.length()-1]==' ' && city_name[0]==' ':
			name = (city_prefix + city_name.substr(1)).capitalize()
		else:
			name = (city_prefix + city_name).capitalize()
	if name_dict.has("suffix"):
		name += name_dict.suffix.pick_random()
	return name

func create_region(ID: String, level:= 0, tier:= 0) -> Dictionary:
	var dict: Dictionary = regions[ID]
	var data:= {
		"level":dict.level + level,
		"tier":dict.tier + tier,
		"race":dict.race,
		"enemy":dict.enemy,
		"cities":[],
		"locations":[],
		"location_enemies":{},
		"enemies":dict.enemies,
		"enemy_amount":dict.enemy_amount.duplicate(),
		"local_materials":dict.local_materials.duplicate(true),
		"enchantment_chance":dict.enchantment_chance,
		"resources":dict.resources,
		"location_resources":{},
		"resource_chance":dict.resource_chance,
		"resource_amount":dict.resource_amount,
	}
	var tier_multiplier:= 1.0
	var level_multiplier:= 1.0 + 0.1*(level-1)
	var region_name: String = dict.base_name.pick_random()
	var region_prefix: String = dict.name_prefix.pick_random()
	if region_prefix[region_prefix.length()-1]==' ' && region_name[0]==' ':
		data.name = (region_prefix + region_name.substr(1)).capitalize()
	else:
		data.name = (region_prefix + region_name).capitalize()
	if tier<0:
		tier_multiplier = 1.0/pow(1.5, -tier)
	elif tier>0:
		tier_multiplier = pow(1.5, tier)
	for i in range(NUM_CITIES):
		var city_name: String
		for _j in range(20):
			city_name = get_city_name(dict.city_name)
			if !(city_name in data.cities):
				break
		data.cities.push_back(city_name)
	for i in range(NUM_LOCATIONS):
		var base: String = dict.location_name.pick_random()
		var location_name: String
		for _j in range(20):
			location_name = (dict.location_prefix.pick_random()+" "+base).capitalize()
			if !(location_name in data.locations):
				break
		data.locations.push_back(location_name)
		if dict.has("location_enemies") && dict.location_enemies.has(base):
			data.location_enemies[location_name] = dict.location_enemies[base]
		else:
			data.location_enemies[location_name] = dict.enemies
		if dict.location_resources.has(base):
			data.location_resources[location_name] = dict.location_resources[base]
		else:
			data.location_resources[location_name] = dict.resources
	for array in data.local_materials.values():
		for mat in array:
			mat.quality *= tier_multiplier*level_multiplier
	data.description = get_region_description(data)
	return data


func select_next_region(level: int) -> String:
	var valid:= []
	var level_cap:= 5
	
	while valid.size()==0:
		for k in regions.keys():
			if abs(regions[k].level-level)<level_cap:
				valid.push_back(k)
		level_cap += randi_range(4,8)
	
	if valid.size()>0:
		return valid.pick_random()
	return regions.keys().pick_random()


func load_data(paths: Array):
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
		var ID: String
		var from: int
		if data==null || data.size()==0:
			printt("Error parsing " + file_name + "!")
			continue
		from = file_name.rfind('/') + 1
		ID = file_name.substr(from, file_name.rfind('.') - from)
		regions[ID] = data
		file.close()

func _ready():
	load_data(Skills.get_file_paths("res://data/regions"))
	
