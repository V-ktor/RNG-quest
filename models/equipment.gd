extends Item
class_name ItemEquipment

var recipe: String
var attributes: Dictionary[String, int]
var stats: Dictionary[String, int]
var resources: Dictionary[String, int]
var resource_regen: Dictionary[String, int]
var damage: Dictionary[String, float]
var resistance: Dictionary[String, float]
var is_enchanted: bool
var enchantment_potential: int
var enchantments: Dictionary[String, Enchantment]
var is_2h: bool
var is_ranged: bool
var story: String
var component_description: String
var components: Array[Component]
var card_set: Dictionary[Vector2i, ItemDescription.Card]


func _init(data: Dictionary) -> void:
	var enchantment_data := data.get("enchantments", {}) as Dictionary
	var component_data: Array[Dictionary] = Array(data.get("components", []) as Array, TYPE_DICTIONARY, "", null)
	
	super._init(data)
	
	self.recipe = data.get("recipe", "") as String
	self.attributes = Dictionary(data.get("attributes", {}) as Dictionary, TYPE_STRING, "", null, TYPE_INT, "", null)
	self.resources = Dictionary(data.get("resources", {}) as Dictionary, TYPE_STRING, "", null, TYPE_INT, "", null)
	self.damage = Dictionary(data.get("damage", {}) as Dictionary, TYPE_STRING, "", null, TYPE_FLOAT, "", null)
	self.resistance = Dictionary(data.get("resistance", {}) as Dictionary, TYPE_STRING, "", null, TYPE_FLOAT, "", null)
	self.is_enchanted = data.get("is_enchanted", false) as bool
	self.enchantment_potential = data.get("enchantment_potential", 0) as int
	self.enchantments = {}
	for key: String in enchantment_data:
		self.enchantments[key] = Item.Enchantment.new(
			(enchantment_data[key] as Dictionary).get("type", "") as String,
			(enchantment_data[key] as Dictionary).get("qulity", 0.0) as float,
		)
	self.is_2h = data.get("is_2h", false) as bool
	self.is_ranged = data.get("is_ranged", false) as bool
	self.story = data.get("story", "") as String
	self.component_description = data.get("component_description", "") as String
	self.components = []
	for c in component_data:
		self.components.push_back(Item.Component.new(
			c.get("name", "unknown") as String,
			c.get("type", "") as String,
			c.get("attributes", {}) as Dictionary,
			c.get("material", {}) as Dictionary,
		))
	
	var card_set_dict: Dictionary = data.get("card_set", {})
	for p: Variant in card_set_dict:
		if card_set_dict[p].position is String:
			card_set_dict[p].position = Utils.parse_vector2i(card_set_dict[p].position as String)
		if p is String:
			self.card_set[Utils.parse_vector2i(p as String)] = ItemDescription.Card.new(card_set_dict[p] as Dictionary)
		else:
			self.card_set[p] = ItemDescription.Card.new(card_set_dict[p] as Dictionary)

func enchant_equipment(enchantment_type: String, q: int, enchantment_slot:= "",
		add_data:= {}) -> void:
	var dict: Dictionary = Items.Enchantment.enchantments[enchantment_type].duplicate(true)
	var scale:= float(q) / 100.0
	var total_quality:= q
	var slot: String = dict.slot + enchantment_slot
	Items.merge_dicts(dict, add_data)
	if self.enchantments.has(slot):
		if self.enchantments[slot].quality > q:
			return
		self.quality -= self.enchantments[slot].quality
		scale -= self.enchantments[slot].quality / 100.0
	for k in Items.ATTRIBUTES:
		if dict.has(k):
			var value: int
			if k == "speed":
				value = maxi(ceili(dict[k] as int), 0)
			else:
				value = maxi(ceili((dict[k] as float) * scale), 0)
			if self.attributes.has(k):
				self.attributes[k] += value
			else:
				self.attributes[k] = value
	for k in Characters.DEFAULT_STATS:
		if dict.has(k):
			var value: int = ceil(max(dict[k] * scale, 0.0))
			if self.stats.has(k):
				self.stats[k] += value
			else:
				self.stats[k] = value
	for k in Characters.RESOURCES:
		if dict.has(k):
			if self.resources.has(k):
				self.resources[k] += ceili(maxf((dict[k] as float) * scale, 0.0))
			else:
				self.resources[k] = ceili(maxf((dict[k] as float) * scale, 0.0))
		if dict.has(k + "_regen"):
			if self.resource_regen.has(k + "_regen"):
				self.resource_regen[k] += ceili((dict[k + "_regen"] as float) * scale)
			else:
				self.resource_regen[k] = ceili((dict[k + "_regen"] as float) * scale)
	if dict.has("damage"):
		for k: String in dict.damage:
			if self.damage.has(k):
				self.damage[k] += dict.damage[k] * (sqrt(1.0 + scale) - 1.0)
			else:
				self.damage[k] = dict.damage[k] * (sqrt(1.0 + scale) - 1.0)
	if dict.has("resistance"):
		for k: String in dict.resistance:
			if self.resistance.has(k):
				self.resistance[k] += dict.resistance[k] * (sqrt(1.0 + scale) - 1.0)
			else:
				self.resistance[k] = dict.resistance[k] * (sqrt(1.0 + scale) - 1.0)
	if self.name.length() < 25:
		if dict.has("prefix"):
			var prefix: Variant = (dict.prefix as Array).pick_random()
			if typeof(prefix) == TYPE_ARRAY:
				var text := ""
				for list: Array in prefix:
					text += list.pick_random()
				self.name = text + " " + self.name
			else:
				self.name = str(prefix) + " " + self.name
		elif dict.has("suffix"):
			var suffix: Variant = (dict.suffix as Array).pick_random()
			if typeof(suffix) == TYPE_ARRAY:
				var text:= ""
				for list: Array in suffix:
					text += list.pick_random()
				self.name = self.name + " " + text
			else:
				self.name = self.name + " " + str(suffix)
	self.price += ceili((dict.price as float) * (0.75 + 0.25 * q / 100.0 * q / 100.0))
	self.quality = (self.quality + total_quality) / 2.0
	self.is_enchanted = true
	self.enchantments[slot] = Enchantment.new(enchantment_type, total_quality)
	self.enchantment_potential -= 1
	self.description = self.create_tooltip()
	self.story = self.create_description()
	self.component_description = self.create_component_tooltip()
	return

func create_description(max_sentences:= 0) -> String:
	var r := self.get_item_rank()
	var text: String = self.format_item_name() + "\n" + self.type + "\n"
	if self.source == "":
		self.source = tr("UNKNOWN_ORIGIN")
	text += self.source + "\n\n"
	
	if self.card_set.size() == 0:
		self.card_set = Items.Description.create_description_data(self, r)
	
	if max_sentences == 0:
		@warning_ignore("integer_division")
		max_sentences = clampi((r + randi_range(0, 2)) / 2, 1, 4)
	text += Items.Description.generate_description(self.card_set, max_sentences)
	
	return text

func create_component_tooltip() -> String:
	if self.components.size() == 0:
		return ""
	if self.source == "":
		self.source = tr("UNKNOWN_ORIGIN")
	var text: String = self.format_item_name() + "\n" + self.type + "\n" + \
		self.source + "\n\n" + tr("COMPONENTS") + ": "
	for dict in self.components:
		text += "\n  " + dict.name
	return text


func get_item_rank() -> int:
	var r := 0
	if self.enchantments.size() > 0:
		r += 1
	elif self.enchantment_potential > 1:
		r += 1
	if self.is_legendary:
		r += 4
	r += int(log(1.0 + self.quality / 100.0 + 0.1 * self.quality / 100.0 * self.quality / 100.0))
	return mini(r, Items.RANK_COLORS.size() - 1)

func create_tooltip() -> String:
	var text: String = self.format_item_name() + "\n" + self.type + "\n"
	text += "\n" + "quality: " + str(int(self.quality)) + "%\n"
	for k in Items.ATTRIBUTES:
		if k not in self.attributes or self.attributes[k] == 0:
			continue
		if self.attributes[k] > 0:
			text += tr(k.to_upper()) + ": +" + str(self.attributes[k]) + "\n"
		else:
			text += tr(k.to_upper()) + ": -" + str(-self.attributes[k]) + "\n"
	for k in Characters.DEFAULT_STATS:
		if k not in self.stats or self.stats[k] == 0:
			continue
		if self.stats[k] > 0:
			text += tr(k.to_upper()) + ": +" + str(self.stats[k]) + "\n"
		else:
			text += tr(k.to_upper()) + ": -" + str(-self.stats[k]) + "\n"
	if self.damage.size() > 0:
		text += tr("DAMAGE") + ":\n"
		for k in self.damage:
			var value := int(100 * self.damage[k])
			if value == 0:
				continue
			if self.damage[k] >= 0.0:
				text += "  " + Items.format_damage_type(k) + ": +" + str(value) + "%\n"
			else:
				text += "  " + Items.format_damage_type(k) + ": -" + str(-value) + "%\n"
	if self.resistance.size() > 0:
		text += tr("RESISTANCE") + ":\n"
		for k in self.resistance:
			var value:= int(100 * self.resistance[k])
			if value == 0:
				continue
			if self.resistance[k] >= 0.0:
				text += "  " + Items.format_damage_type(k) + ": +" + str(value) + "%\n"
			else:
				text += "  " + Items.format_damage_type(k) + ": -" + str(-value) + "%\n"
	for k in Characters.RESOURCES:
		if k in self.resources and self.resources[k] != 0:
			if self.resources[k] >= 0:
				text += Items.format_resource(k) + ": +" + str(self.resources[k]) + "\n"
			else:
				text += Items.format_resource(k) + ": -" + str(-self.resources[k]) + "\n"
		if k in self.resource_regen:
			var value:= int(self.resource_regen[k])
			if value == 0:
				continue
			if self.resource_regen[k] > 0:
				text += Items.format_resource(k, "_REGEN") + ": +" + str(value) + "\n"
			else:
				text += Items.format_resource(k, "_REGEN") + ": -" + str(-value) + "\n"
	text += tr("PRICE") + ": " + str(self.price)
	self.description = text
	return text


func to_dict() -> Dictionary:
	var data := super.to_dict()
	data.recipe = self.recipe
	data.attributes = self.attributes
	data.resources = self.resources
	data.resource_regen = self.resource_regen
	data.damage = self.damage
	data.resistance = self.resistance
	data.is_enchanted = self.is_enchanted
	data.enchantment_potential = self.enchantment_potential
	data.enchantments = {}
	for key in self.enchantments:
		data.enchantments[key] = self.enchantments[key].to_dict()
	data.is_2h = self.is_2h
	data.is_ranged = self.is_ranged
	data.story = self.story
	data.component_description = self.component_description
	data.components = []
	for component in self.components:
		@warning_ignore("unsafe_method_access")
		data.components.push_back(component.to_dict())
	data.card_set = {}
	for pos in self.card_set:
		data.card_set[pos] = self.card_set[pos].to_dict()
	return data
