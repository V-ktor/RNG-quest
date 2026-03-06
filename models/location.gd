extends RefCounted
class_name Location

var name: String
var type: String
var enemies: Array[String]
var resources: Array[String]
var materials: Array[String]
var tags: Array[String]


func _init(dict: Dictionary[String, Variant]) -> void:
	self.name = dict.get("name", "region") as String
	self.type = dict.get("type", "unknown") as String
	self.enemies = Array(dict.get("enemies", []) as Array, TYPE_STRING, "", null)
	self.resources = Array(dict.get("resources", []) as Array, TYPE_STRING, "", null)
	self.materials = Array(dict.get("materials", []) as Array, TYPE_STRING, "", null)
	self.tags = Array(dict.get("tags", []) as Array, TYPE_STRING, "", null)

func to_dict() -> Dictionary[String, Variant]:
	return {
		"name": self.name,
		"type": self.type,
		"enemies": self.enemies,
		"resources": self.resources,
		"materials": self.materials,
		"tags": self.tags,
	}
