extends Node

var enchantments:= {}
var enchantments_by_tier:= {}
var enchantments_by_slot:= {}
var enchantments_by_tier_and_slot := {}


func load_enchantment_data(path: String):
	for file_name in Utils.get_file_paths(path):
		var file:= FileAccess.open(file_name, FileAccess.READ)
		var error:= FileAccess.get_open_error()
		if error!=OK:
			print("Can't open file " + file_name + "!")
			continue
		else:
			print("Loading items " + file_name + '.')
		
		var raw:= file.get_as_text()
		var dict: Dictionary = JSON.parse_string(raw) as Dictionary
		if dict==null || dict.size()==0:
			printt("Error parsing " + file_name + "!")
			continue
		for key in dict:
			enchantments[key] = dict[key]
			if "tier" in dict[key]:
				var tier: String = dict[key].tier
				if tier not in enchantments_by_tier:
					enchantments_by_tier[tier] = []
				enchantments_by_tier[tier].push_back(key)
				if tier not in enchantments_by_tier_and_slot:
					enchantments_by_tier_and_slot[tier] = {}
				if "slot" in dict[key]:
					var slot: String = dict[key].slot
					if slot not in enchantments_by_tier_and_slot[tier]:
						enchantments_by_tier_and_slot[tier][slot] = []
					enchantments_by_tier_and_slot[tier][slot].push_back(key)
			if "slot" in dict[key]:
				var slot: String = dict[key].slot
				if slot not in enchantments_by_slot:
					enchantments_by_slot[slot] = []
				enchantments_by_slot[slot].push_back(key)
		file.close()

func _ready():
	load_enchantment_data("res://data/items/enchantments")
