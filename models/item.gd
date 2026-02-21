extends RefCounted
class_name Item

var name: String
var base_name: String
var type: String
var subtype: Array[String]
var description: String
var source: String
var source_race: String
var quality: float
var rank: int
var is_legendary: bool
var price: int
var properties: Dictionary
var tags: Array[String]
var amount: int


class Enchantment:
	var type: String
	var quality: float
	
	func _init(t: String, q: float) -> void:
		self.type = t
		self.quality = q
	
	func to_dict() -> Dictionary:
		return {
			"type": self.type,
			"quality": self.quality,
		}


class ComponentMaterial:
	var name: String
	var properties: Dictionary[String, String]
	
	func _init(n: String, p: Dictionary) -> void:
		self.name = n
		self.properties = Dictionary(p, TYPE_STRING, "", null, TYPE_STRING, "", null)
	
	func to_dict() -> Dictionary:
		return {
			"name": self.name,
			"properties": self.properties,
		}


class Component:
	var name: String
	var type: String
	var properties: Dictionary[String, String]
	var material:  ComponentMaterial
	
	func _init(n: String, t: String, p: Dictionary, m: Dictionary) -> void:
		self.name = n
		self.type = t
		self.properties = Dictionary(p, TYPE_STRING, "", null, TYPE_STRING, "", null)
		self.material = ComponentMaterial.new(
			m.get("name", "unknown") as String,
			m.get("properties", {}) as Dictionary,
		)
	
	func to_dict() -> Dictionary:
		return {
			"name": self.name,
			"type": self.type,
			"properties": self.properties,
			"material": self.material.to_dict(),
		}


func _init(data: Dictionary) -> void:
	self.name = data.get("name", "unknown") as String
	self.base_name = data.get("base_name", "unknown") as String
	self.type = data.get("type", "") as String
	self.subtype = Array(data.get("subtype", []) as Array, TYPE_STRING, "", null)
	self.description = data.get("description", "") as String
	self.source = data.get("source", tr("UNKNOWN_ORIGIN")) as String
	self.source_race = data.get("source_race", "") as String
	self.quality = data.get("quality", 0.0) as float
	self.rank = data.get("rank", 0) as int
	self.is_legendary = data.get("is_legendary", false) as bool
	self.price = data.get("price", 0) as int
	self.properties = data.get("properties", {}) as Dictionary
	self.tags = Array(data.get("tag", []) as Array, TYPE_STRING, "", null)
	self.amount = data.get("amount", 1) as int


func get_plain_description() -> String:
	return Utils.tooltip_remove_bb_code(self.description)


func get_item_rank() -> int:
	var r := 0
	r += floori(log(1.0 + self.quality / 100.0 + 0.1 * self.quality / 100.0 * self.quality / 100.0))
	return mini(r, Items.RANK_COLORS.size() - 1)

func format_item_name() -> String:
	self.rank = self.get_item_rank()
	return "[color=" + Items.RANK_COLORS[self.rank].to_html(false) + "]" + self.name + "[/color]"

func create_tooltip() -> String:
	var text: String = self.format_item_name() + "\n" + self.type + "\n"
	text += "\n" + "quality: " + str(int(self.quality)) + "%\n"
	text += tr("PRICE") + ": " + str(self.price)
	self.description = text
	return text

func create_description(_max_sentences:= 0) -> String:
	var text: String = self.format_item_name() + "\n" + self.type + "\n"
	if self.source == "":
		self.source = tr("UNKNOWN_ORIGIN")
	text += self.source
	return text

func create_component_tooltip() -> String:
	return ""


func to_dict() -> Dictionary:
	return {
		"name": self.name,
		"base_name": self.base_name,
		"type": self.type,
		"subtype": self.subtype,
		"description": self.description,
		"source": self.source,
		"source_race": self.source_race,
		"quality": self.quality,
		"rank": self.rank,
		"is_legendary": self.is_legendary,
		"price": self.price,
		"properties": self.properties,
		"tags": self.tags,
		"amount": self.amount,
	}
