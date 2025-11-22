extends RefCounted
class_name God

var name: String
var ID: String
var description: Array[String]
var domains: Array[String]

func _init(data: Dictionary) -> void:
	self.name = data.get("name", "unknown") as String
	self.ID = data.get("ID", "god" + str(randi())) as String
	self.description = []
	for d in data.get("description", []):
		self.description.push_back(d)
	self.domains = []
	for d in data.get("domains", []):
		self.domains.push_back(d)

func to_dict() -> Dictionary:
	return {
		"name": self.name,
		"ID": self.ID,
		"description": self.description,
		"domains": self.domains,
	}
