extends RefCounted
class_name Location

var name: String
var type: String
var enemies: Array[String]
var resources: Array[String]
var materials: Array[String]

func _init(dict: Dictionary[String, Variant]) -> void:
	self.name = dict.get("name", "region") as String
	self.type = dict.get("type", "unknown") as String
	self.enemies = []
	for enemy in dict.get("enemies", []):
		self.enemies.push_back(String(enemy))
	self.resources = []
	for resource in dict.get("resources", []):
		self.resources.push_back(String(resource))
	self.materials = []
	for material in dict.get("materials", []):
		self.materials.push_back(String(material))

func to_dict() -> Dictionary[String, Variant]:
	return {
		"name": self.name,
		"type": self.type,
		"enemies": self.enemies,
		"resources": self.resources,
		"materials": self.materials,
	}
