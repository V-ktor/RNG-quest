extends RefCounted
class_name Ability

var name: String
var level: int
var experience: int


func add_exp(add_experience: int) -> bool:
	self.experience += add_experience
	if self.experience > self.get_max_exp():
		self.level_up()
		return true
	return false

func level_up():
	var max_exp := self.get_max_exp()
	self.level += 1
	self.experience -= max_exp

func get_max_exp() -> int:
	return 100 + 75 * self.level + 25 * self.level * self.level


func _init(dict: Dictionary) -> void:
	self.name = dict.get("name", "unknown") as String
	self.level = dict.get("level", 1) as int
	self.experience = dict.get("experience", 0) as int

func to_dict() -> Dictionary[String, Variant]:
	return {
		"name": self.name,
		"level": self.level,
		"experience": self.experience,
	}
