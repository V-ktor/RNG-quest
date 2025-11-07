extends RefCounted
class_name Ability

var name: String
var level: int
var experience: float

func _init(dict: Dictionary) -> void:
	self.name = dict.get("name", "unknown") as String
	self.level = dict.get("level", 1) as int
	self.experience = dict.get("experience", 0) as float

func to_dict() -> Dictionary:
	return {
		"name": self.name,
		"level": self.level,
		"experience": self.experience,
	}

func add_exp(add_experience: float) -> bool:
	self.experience += add_experience
	if self.experience > self.get_max_exp():
		self.level_up()
		return true
	return false

func level_up():
	var max_exp := self.get_max_exp()
	self.level += 1
	self.experience -= max_exp

func get_max_exp() -> float:
	return 100 + 75 * self.level + 25 * self.level * self.level
