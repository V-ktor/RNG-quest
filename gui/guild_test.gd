extends Control


func generate_guild() -> void:
	var region:= Region.new({
		"name": "Test Region",
		"level": 1,
		"tier": 1,
		"description": "",
		"race": ["human"],
		"cities": {
			"test_city": {
				"name": "Test City",
				"type": "town"
			}
		},
		"locations": {
			"test_region": {
				"name": "Test Forest",
				"type": "forest"
			}
		},
	})
	var player:= Characters.Character.new({
		"name": "Test Player",
		"level": 1,
		"abilities": {
			"light_weapons": {
				"name": "light_weapons",
				"level": 1,
			},
			"dirty_fighting": {
				"name": "dirty_fighting",
				"level": 1,
			},
			"elemental_magic": {
				"name": "elemental_magic",
				"level": 1,
			},
			"celestial_magic": {
				"name": "celestial_magic",
				"level": 1,
			},
			"defensive_magic": {
				"name": "defensive_magic",
				"level": 1,
			},
			"healing": {
				"name": "healing",
				"level": 1,
			},
		},
		"stats": {
			"strength":10,
			"constitution":10,
			"dexterity":10,
			"intelligence":10,
			"wisdom":10,
			"cunning":10,
		},
	})
	var guild := Guilds.create_guild(region, player)
	
	var text := JSON.stringify(guild.to_dict(), "\t")
	$RichTextLabel.add_text(text)
	
	text = JSON.stringify(Guilds.get_node("Description").create_guild_description(guild, region), "\t")
	$RichTextLabel2.add_text(text)

func _input(event: InputEvent) -> void:
	if event.is_pressed():
		generate_guild()

func _ready() -> void:
	generate_guild()
